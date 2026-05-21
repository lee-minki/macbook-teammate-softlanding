#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════════════════════╗
# ║  MacBook Soft-Landing — One-Click Bootstrap (v1.3.1)            ║
# ║  대상: Windows 에서 넘어온 사용자, "민기 표준" 베이스라인 1회 자동    ║
# ║                                                                       ║
# ║  설계 원칙:                                                            ║
# ║  ① 의존성 체인 보장 — 이전 단계가 깨지면 자가 복구 시도, 그래도       ║
# ║     안 되면 다음 단계는 skip 처리 (Claude Code 가 node 없이 깔리는    ║
# ║     일 같은 건 절대 일어나지 않게)                                     ║
# ║  ② 멱등 — 재실행해도 안전, 이미 깔린 건 ok 로 빠르게 통과              ║
# ║  ③ 마지막에 summary 로 OK/WARN/FAIL 가시화                            ║
# ╠══════════════════════════════════════════════════════════════════════╣
# ║  사용:                                                                ║
# ║    GIT_NAME="홍길동" GIT_EMAIL="hong@company.com" bash bootstrap.sh   ║
# ║    또는: bash <(curl -fsSL <URL>/bootstrap.sh)                         ║
# ║  옵션:                                                                ║
# ║    SKIP_AI=1     — AI CLI npm globals 건너뜀                          ║
# ║    SKIP_MAS=1    — App Store 앱(Amphetamine 등) 건너뜀                ║
# ║    SKIP_DEFAULTS=1 — defaults write 건너뜀                            ║
# ║    DARK_MODE=0   — 다크모드 자동 적용 안 함 (기본 1)                  ║
# ║    NATURAL_SCROLL=1 — Mac 기본 자연 스크롤 유지 (기본 0 = 윈도우식)    ║
# ╚══════════════════════════════════════════════════════════════════════╝

set -u

# ────────────────────────────────────────────────────────
# 색 / 로그
# ────────────────────────────────────────────────────────
if [[ -t 1 ]]; then
  C_RESET='\033[0m'; C_BOLD='\033[1m'
  C_G='\033[32m'; C_Y='\033[33m'; C_R='\033[31m'; C_B='\033[34m'; C_X='\033[90m'
else
  C_RESET=''; C_BOLD=''; C_G=''; C_Y=''; C_R=''; C_B=''; C_X=''
fi

STEP=0; TOTAL=13
SUMMARY=(); FAIL=0; SKIPPED=0
log()  { printf "${C_X}%s${C_RESET}\n" "$*"; }
info() { printf "${C_B}ℹ${C_RESET} %s\n" "$*"; }
ok()   { printf "${C_G}✔${C_RESET} %s\n" "$*"; SUMMARY+=("OK   $*"); }
warn() { printf "${C_Y}⚠${C_RESET} %s\n" "$*"; SUMMARY+=("WARN $*"); }
fail() { printf "${C_R}✘${C_RESET} %s\n" "$*"; SUMMARY+=("FAIL $*"); FAIL=$((FAIL+1)); }
skip() { printf "${C_Y}⊘${C_RESET} %s\n" "$*"; SUMMARY+=("SKIP $*"); SKIPPED=$((SKIPPED+1)); }
step() {
  STEP=$((STEP+1))
  local title="$1" deps="${2:-}"
  printf "\n${C_BOLD}${C_B}[%d/%d] %s${C_RESET}" "$STEP" "$TOTAL" "$title"
  [[ -n "$deps" ]] && printf "  ${C_X}(의존: %s)${C_RESET}" "$deps"
  printf "\n"
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd)" || SCRIPT_DIR="$PWD"

# ────────────────────────────────────────────────────────
# 의존성 게이트 — 단계 진입 전 필수 명령어 확인 + 자가 복구
# require_cmd <cmd> [self_heal_cmd]
#   - cmd 가 있으면 0 리턴
#   - 없으면 self_heal_cmd 실행 시도 → 후 재확인
#   - 그래도 없으면 1 리턴 (호출 측이 skip 처리)
# ────────────────────────────────────────────────────────
require_cmd() {
  local cmd="$1" heal="${2:-}"
  if command -v "$cmd" >/dev/null 2>&1; then return 0; fi
  if [[ -n "$heal" ]]; then
    warn "$cmd 없음 — 자가 복구 시도: $heal"
    eval "$heal" >/dev/null 2>&1 || true
    # PATH 재반영 (brew install 후)
    [[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null
    command -v "$cmd" >/dev/null 2>&1 && return 0
  fi
  return 1
}

# ────────────────────────────────────────────────────────
# 시작 배너
# ────────────────────────────────────────────────────────
printf "${C_BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}\n"
printf "${C_BOLD}  MacBook Soft-Landing — One-Click Bootstrap (v1.3.1)${C_RESET}\n"
printf "${C_BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}\n\n"

if [[ "$(uname)" != "Darwin" ]]; then printf "${C_R}macOS 전용입니다.${C_RESET}\n"; exit 1; fi

ARCH="$(uname -m)"
log "사용자: $(whoami)   컴퓨터: $(scutil --get ComputerName 2>/dev/null || hostname)"
log "macOS:  $(sw_vers -productVersion) ($ARCH)"
log ""
log "흐름: Xcode CLT → Homebrew → brew bundle → mas → WinMacKey →"
log "      폴더 → defaults → 절전 → Git → Python 검증 → AI CLI → 안내"
log "각 단계는 이전 단계가 실패하면 자동으로 자가 복구 후 재시도하거나 skip 됩니다."

# ────────────────────────────────────────────────────────
# [1/12] Xcode CLT — Homebrew 의 일부 빌드/cask 가 의존
# ────────────────────────────────────────────────────────
step "Xcode Command Line Tools" "최상위 의존성"
if xcode-select -p >/dev/null 2>&1; then
  ok "Xcode CLT 이미 설치됨"
else
  info "Xcode CLT 설치 다이얼로그 트리거"
  xcode-select --install 2>/dev/null || true
  W=0
  until xcode-select -p >/dev/null 2>&1 || [[ $W -ge 600 ]]; do sleep 10; W=$((W+10)); done
  if xcode-select -p >/dev/null 2>&1; then
    ok "Xcode CLT 설치 완료"
  else
    fail "Xcode CLT 미설치 — 이 상태에선 brew/cask 빌드 일부 실패 가능. 수동 설치 후 재실행 권장"
  fi
fi

# ────────────────────────────────────────────────────────
# [2/12] Homebrew — 거의 모든 후속 단계가 의존
# ────────────────────────────────────────────────────────
step "Homebrew" "Xcode CLT"
if command -v brew >/dev/null 2>&1; then
  ok "Homebrew 이미 설치됨"
else
  info "Homebrew 설치 (관리자 비밀번호 필요)"
  if /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
    ok "Homebrew 설치 스크립트 완료"
  else
    fail "Homebrew 설치 실패 — 인터넷/방화벽 점검 후 재실행"
  fi
  if [[ "$ARCH" == "arm64" && -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    grep -q 'brew shellenv' "$HOME/.zprofile" 2>/dev/null \
      || echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
  fi
fi

if ! command -v brew >/dev/null 2>&1; then
  fail "brew 명령 미인식 — 이후 단계 대부분 skip 됩니다"
  BREW_OK=0
else
  BREW_OK=1
  log "brew = $(command -v brew)"
fi

# ────────────────────────────────────────────────────────
# [3/12] brew bundle — formulae + casks 일괄
# ────────────────────────────────────────────────────────
step "brew bundle (CLI + 앱 일괄)" "Homebrew"
if [[ "$BREW_OK" != "1" ]]; then
  skip "brew 미설치 → brew bundle skip"
else
  BF="${SCRIPT_DIR}/Brewfile"
  if [[ ! -f "$BF" ]]; then
    info "Brewfile 미존재 → 인라인 생성"
    BF="$(mktemp -t Brewfile.XXXXXX)"
    cat > "$BF" <<'BREWEOF'
brew "mas"
brew "git"; brew "gh"; brew "node"
brew "python@3.11"; brew "uv"; brew "pipx"
brew "jq"; brew "ripgrep"; brew "fd"; brew "tree"; brew "wget"
cask "alt-tab"; cask "maccy"; cask "the-unarchiver"
cask "mos"; cask "logi-options-plus"; cask "rectangle"
cask "karabiner-elements"
cask "stats"
cask "raycast"; cask "google-chrome"; cask "telegram-desktop"; cask "tailscale-app"
cask "iterm2"; cask "visual-studio-code"; cask "cursor"
cask "claude"
brew "ollama"; cask "lm-studio"
BREWEOF
  fi
  brew bundle --file="$BF" && ok "brew bundle 완료" || warn "brew bundle 일부 실패 — 아래 핵심 도구 자동 점검"

  # ── 핵심 CLI 6종 즉시 재검증 + 자동 재설치 (다음 단계가 의존하므로 필수) ──
  declare -a CRITICAL=(
    "git:git"
    "node:node"
    "npm:node"           # npm 은 node 와 함께
    "python3.11:python@3.11"
    "mas:mas"
    "gh:gh"
  )
  info "핵심 CLI 6종 즉시 검증"
  for entry in "${CRITICAL[@]}"; do
    bin="${entry%%:*}"; pkg="${entry##*:}"
    if command -v "$bin" >/dev/null 2>&1; then
      ok "  $bin OK"
    else
      warn "  $bin 미설치 — brew install $pkg 재시도"
      brew install "$pkg" >/dev/null 2>&1
      command -v "$bin" >/dev/null 2>&1 && ok "  $bin 재설치 성공" || fail "  $bin 재설치 실패"
    fi
  done
fi

# ────────────────────────────────────────────────────────
# [4/12] App Store 앱 (mas)
# ────────────────────────────────────────────────────────
step "App Store 앱 (mas)" "mas, Apple ID 로그인"
if [[ "${SKIP_MAS:-0}" == "1" ]]; then
  skip "SKIP_MAS=1"
elif ! require_cmd mas "brew install mas"; then
  skip "mas CLI 없음 — App Store 앱 자동 설치 불가"
elif ! mas account >/dev/null 2>&1; then
  warn "App Store 로그인 안 됨 — 앱을 열어 Apple ID 로그인 후 재실행"
  open -a "App Store" 2>/dev/null || true
else
  for entry in "937984704:Amphetamine" "1452453066:Hidden Bar"; do
    mas_id="${entry%%:*}"; mas_name="${entry##*:}"
    if mas list 2>/dev/null | grep -q "^${mas_id} "; then
      ok "${mas_name} 이미 설치됨"
    else
      mas install "$mas_id" >/dev/null 2>&1 && ok "${mas_name} 설치" || warn "${mas_name} 설치 실패"
    fi
  done
fi

# ────────────────────────────────────────────────────────
# [5/12] WinMacKey (GitHub Release DMG)
# ────────────────────────────────────────────────────────
step "WinMacKey (GitHub Release DMG)" "curl 또는 gh, WINMACKEY_REPO 환경변수"
# WinMacKey 저장소는 환경변수로 주입한다 (예: WINMACKEY_REPO="owner/repo").
# 미지정 시 자동 다운로드를 건너뛰고 안내만 한다 — 특정 개인/조직 저장소를 하드코딩하지 않음.
WM_REPO="${WINMACKEY_REPO:-}"
if [[ -d "/Applications/WinMacKey.app" ]]; then
  ok "WinMacKey 이미 설치됨"
elif [[ -z "$WM_REPO" ]]; then
  skip "WINMACKEY_REPO 미지정 — WinMacKey 자동 설치 건너뜀 (WINMACKEY_REPO=\"owner/repo\" 로 지정하거나 수동 설치)"
elif ! command -v curl >/dev/null 2>&1; then
  skip "curl 없음 — WinMacKey 자동 다운로드 불가"
else
  WD="$(mktemp -d -t winmackey.XXXXXX)"; DMG=""
  if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
    (cd "$WD" && gh release download --repo "$WM_REPO" --pattern '*.dmg' >/dev/null 2>&1) \
      && DMG="$(ls "$WD"/*.dmg 2>/dev/null | head -1)"
  fi
  if [[ -z "$DMG" ]]; then
    URL="$(curl -fsSL "https://api.github.com/repos/${WM_REPO}/releases/latest" 2>/dev/null \
      | grep -oE '"browser_download_url":[[:space:]]*"[^"]+\.dmg"' | head -1 | cut -d'"' -f4)"
    [[ -n "$URL" ]] && curl -fsSL -o "$WD/WinMacKey.dmg" "$URL" && DMG="$WD/WinMacKey.dmg"
  fi
  if [[ -n "$DMG" && -f "$DMG" ]]; then
    MNT="$(hdiutil attach -nobrowse -noverify -noautoopen "$DMG" | awk '/\/Volumes\//{print $NF; exit}')"
    if [[ -n "$MNT" ]]; then
      APP="$(ls -d "$MNT"/*.app 2>/dev/null | head -1)"
      [[ -n "$APP" ]] && cp -R "$APP" /Applications/ && ok "WinMacKey 설치 완료" || fail "WinMacKey 복사 실패"
      hdiutil detach "$MNT" >/dev/null 2>&1 || true
    else fail "WinMacKey DMG 마운트 실패"; fi
  else
    warn "WinMacKey DMG 자동 다운로드 실패 — 릴리스 페이지를 엽니다"
    open "https://github.com/${WM_REPO}/releases/latest" 2>/dev/null || true
  fi
fi

# ────────────────────────────────────────────────────────
# [6/12] 작업 폴더
# ────────────────────────────────────────────────────────
step "팀 표준 작업 폴더" "없음"
mkdir -p "$HOME/worksapces/api-server" \
         "$HOME/worksapces/frontend-web" \
         "$HOME/worksapces/infra-tools" \
         "$HOME/worksapces/data-pipeline" \
         "$HOME/worksapces/shared-lib" \
         "$HOME/.claude/workspace"
ok "~/worksapces + ~/.claude/workspace 준비됨"

# ────────────────────────────────────────────────────────
# [7/12] defaults write
# ────────────────────────────────────────────────────────
step "macOS 기본값 (Finder/Dock/스크롤/다크모드/캡처)" "없음"
if [[ "${SKIP_DEFAULTS:-0}" == "1" ]]; then
  skip "SKIP_DEFAULTS=1"
else
  defaults write com.apple.finder ShowPathbar -bool true
  defaults write com.apple.finder ShowStatusBar -bool true
  defaults write com.apple.finder FXPreferredViewStyle -string "clmv"
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true
  defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
  defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
  defaults write NSGlobalDomain AppleICUForce24HourTime -bool true
  defaults write com.apple.dock autohide -bool true
  defaults write com.apple.dock autohide-delay -float 0
  defaults write com.apple.dock autohide-time-modifier -float 0.4
  defaults write com.apple.dock expose-animation-duration -float 0.12
  defaults write com.apple.dock mineffect -string "scale"
  defaults write NSGlobalDomain KeyRepeat -int 2
  defaults write NSGlobalDomain InitialKeyRepeat -int 15
  defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
  if [[ "${NATURAL_SCROLL:-0}" == "0" ]]; then
    defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
    ok "스크롤: 윈도우식 (자연 스크롤 OFF)"
  fi
  if [[ "${DARK_MODE:-1}" == "1" ]]; then
    defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"
    ok "다크모드 ON"
  fi
  defaults write com.apple.screencapture type -string "png"
  defaults write com.apple.screencapture disable-shadow -bool true
  defaults write com.apple.screencapture location -string "$HOME/Downloads"
  defaults write com.apple.screencapture include-date -bool true
  defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
  defaults write com.apple.menuextra.battery ShowPercent -string "YES" 2>/dev/null || true
  killall Finder Dock SystemUIServer 2>/dev/null || true
  ok "Finder/Dock/키보드/스크롤/스크린샷 설정 적용"
fi

# ────────────────────────────────────────────────────────
# [8/12] 절전 정책
# ────────────────────────────────────────────────────────
step "절전 정책 (AC 어댑터)" "pmset, sudo"
if command -v pmset >/dev/null 2>&1; then
  sudo -n pmset -c displaysleep 30 sleep 0 2>/dev/null \
    && ok "AC: 디스플레이 30분, 시스템 sleep 0" \
    || warn "pmset sudo 필요 — Amphetamine 으로 임시 방지 가능"
fi

# ────────────────────────────────────────────────────────
# [9/12] Git 기본 설정
# ────────────────────────────────────────────────────────
step "Git 설정" "git"
if ! require_cmd git "brew install git"; then
  skip "git 없음 — Git 설정 skip"
else
  GN="${GIT_NAME:-}"; GE="${GIT_EMAIL:-}"
  if [[ -n "$GN" ]]; then git config --global user.name "$GN" && ok "git user.name = $GN"
  else
    cur="$(git config --global user.name 2>/dev/null)"
    [[ -n "$cur" ]] && ok "git user.name 유지: $cur" || warn "GIT_NAME 미지정 — 나중에  git config --global user.name '이름'"
  fi
  if [[ -n "$GE" ]]; then git config --global user.email "$GE" && ok "git user.email = $GE"
  else
    cur="$(git config --global user.email 2>/dev/null)"
    [[ -n "$cur" ]] && ok "git user.email 유지: $cur" || warn "GIT_EMAIL 미지정"
  fi
  git config --global init.defaultBranch main 2>/dev/null
  git config --global pull.rebase false 2>/dev/null
  ok "init.defaultBranch=main, pull.rebase=false"
fi

# ────────────────────────────────────────────────────────
# [10/12] Python 3.11 검증
# ────────────────────────────────────────────────────────
step "Python 3.11 검증" "brew, python@3.11"
if require_cmd python3.11 "brew install python@3.11"; then
  ok "python3.11 $(python3.11 --version 2>&1)"
  command -v uv >/dev/null 2>&1 && ok "uv $(uv --version 2>&1 | head -1)" || warn "uv 미설치"
  command -v pipx >/dev/null 2>&1 && ok "pipx $(pipx --version 2>&1)" || warn "pipx 미설치"
else
  skip "python3.11 자가복구 실패"
fi

# ────────────────────────────────────────────────────────
# [11/12] AI CLI (npm globals) — ★ node/npm 의존 명시 검증 ★
# ────────────────────────────────────────────────────────
step "AI CLI 설치 (Claude Code / Codex / Gemini)" "node, npm"
if [[ "${SKIP_AI:-0}" == "1" ]]; then
  skip "SKIP_AI=1"
elif ! require_cmd node "brew install node"; then
  fail "node 미설치 — Claude Code/Codex/Gemini CLI 설치 불가 (brew install node 자가복구도 실패)"
elif ! require_cmd npm "brew reinstall node"; then
  fail "npm 미설치 — node 가 비정상. brew reinstall node 후 재실행"
else
  log "  node $(node --version)  npm $(npm --version)"
  for p in "@anthropic-ai/claude-code" "@openai/codex" "@google/gemini-cli"; do
    info "  npm i -g $p"
    if npm install -g "$p" >/dev/null 2>&1; then
      bin="${p##*/}"; [[ "$p" == "@anthropic-ai/claude-code" ]] && bin="claude"
      [[ "$p" == "@openai/codex" ]] && bin="codex"
      [[ "$p" == "@google/gemini-cli" ]] && bin="gemini"
      command -v "$bin" >/dev/null 2>&1 && ok "  $bin 설치 (path: $(command -v "$bin"))" || warn "  $p 설치는 OK 같지만 PATH 미반영"
    else
      warn "  $p 설치 실패 — 네트워크/권한 확인"
    fi
  done
  npm install -g openclaw >/dev/null 2>&1 && ok "  openclaw" || warn "  openclaw 패키지명 변동 가능 — 수동 확인"
fi

# ────────────────────────────────────────────────────────
# [12/13] MLX 로컬 LLM 환경 (Apple Silicon) + Ollama
# ────────────────────────────────────────────────────────
step "로컬 LLM (MLX venv + Ollama)" "python3.11, uv (MLX는 Apple Silicon 전용)"
if [[ "${SKIP_MLX:-0}" == "1" ]]; then
  skip "SKIP_MLX=1"
else
  # Ollama (brew formula 로 이미 깔렸을 수 있음)
  if command -v ollama >/dev/null 2>&1; then
    ok "ollama $(ollama --version 2>&1 | head -1)"
  else
    warn "ollama 미설치 — brew install ollama 재시도"
    brew install ollama >/dev/null 2>&1 && ok "ollama 재설치" || warn "ollama 설치 실패"
  fi

  # MLX (Apple Silicon 전용 Python 패키지)
  if [[ "$ARCH" != "arm64" ]]; then
    skip "MLX 는 Apple Silicon 전용 — Intel Mac 이라 건너뜀"
  elif ! command -v python3.11 >/dev/null 2>&1; then
    skip "python3.11 없음 — MLX venv 생성 불가"
  else
    MLX_DIR="$HOME/worksapces/mlx-lab"
    mkdir -p "$MLX_DIR"
    if [[ ! -d "$MLX_DIR/.venv" ]]; then
      if command -v uv >/dev/null 2>&1; then
        (cd "$MLX_DIR" && uv venv --python 3.11 >/dev/null 2>&1 \
          && uv pip install --python "$MLX_DIR/.venv/bin/python" mlx mlx-lm >/dev/null 2>&1) \
          && ok "MLX venv 생성 + mlx/mlx-lm 설치 ($MLX_DIR/.venv)" \
          || warn "MLX 설치 실패 — 수동: cd $MLX_DIR && uv venv && uv pip install mlx mlx-lm"
      else
        (cd "$MLX_DIR" && python3.11 -m venv .venv \
          && "$MLX_DIR/.venv/bin/pip" install -q --upgrade pip mlx mlx-lm >/dev/null 2>&1) \
          && ok "MLX venv 생성 + mlx/mlx-lm 설치 ($MLX_DIR/.venv)" \
          || warn "MLX 설치 실패 — 수동 확인"
      fi
    else
      ok "MLX venv 이미 존재 ($MLX_DIR/.venv)"
    fi
  fi
fi

# ────────────────────────────────────────────────────────
# [13/13] 수동 단계 안내
# ────────────────────────────────────────────────────────
step "수동 단계 안내 (자동화 불가)" "사용자"
cat <<EOF
  ${C_BOLD}macOS 보안상 자동화 불가능한 단계입니다.${C_RESET}

  1) 시스템 설정 → 개인정보 보호 및 보안 → 접근성 / 입력 모니터링
     (WinMacKey, Karabiner-Elements, Rectangle, AltTab, Maccy, Stats 권한 ON)
  2) Tailscale: 메뉴바 아이콘 → Log in → 회사 계정 OAuth → 관리자 승인
  3) iCloud Drive 데스크탑/문서 동기화 해제 (혼란 방지)
  4) Claude / Codex / Gemini 각자 로그인
  5) Karabiner-Elements: CapsLock → HyperKey 매핑 (선택)
  6) Logi Options+: 외부 로지텍 마우스 연결 시 첫 실행
  7) Amphetamine: 메뉴바 아이콘 → Start New Session
  8) Ollama 모델 받기 (용량 큼, 수동): ${C_BOLD}ollama run llama3.2${C_RESET} 또는 ${C_BOLD}ollama run qwen2.5-coder${C_RESET}
  9) MLX 로컬 LLM 테스트 (Apple Silicon):
     ${C_BOLD}~/worksapces/mlx-lab/.venv/bin/python -m mlx_lm.generate --model mlx-community/Llama-3.2-3B-Instruct-4bit --prompt "hi"${C_RESET}

  → ${C_BOLD}bash $SCRIPT_DIR/prompts/permissions-open.sh${C_RESET} 로 권한 페이지를 한 번에 엽니다.
EOF

# ────────────────────────────────────────────────────────
# Summary
# ────────────────────────────────────────────────────────
printf "\n${C_BOLD}━━━ 요약 ━━━${C_RESET}\n"
for line in "${SUMMARY[@]}"; do
  case "$line" in
    OK*)   printf "${C_G}%s${C_RESET}\n" "$line" ;;
    WARN*) printf "${C_Y}%s${C_RESET}\n" "$line" ;;
    SKIP*) printf "${C_Y}%s${C_RESET}\n" "$line" ;;
    FAIL*) printf "${C_R}%s${C_RESET}\n" "$line" ;;
  esac
done
printf "\n"
if [[ $FAIL -eq 0 && $SKIPPED -eq 0 ]]; then
  printf "${C_G}${C_BOLD}자동 설치 완료.${C_RESET}\n"
elif [[ $FAIL -eq 0 ]]; then
  printf "${C_Y}${C_BOLD}완료 (skip %d개) — 안내 따라 수동 처리 후 재실행 권장.${C_RESET}\n" "$SKIPPED"
else
  printf "${C_R}${C_BOLD}실패 %d개 — 원인 해결 후 같은 명령 재실행 (멱등).${C_RESET}\n" "$FAIL"
fi
printf "\n다음:\n"
printf "  ${C_BOLD}bash %s/verify.sh${C_RESET}\n" "$SCRIPT_DIR"
printf "  ${C_BOLD}bash %s/prompts/permissions-open.sh${C_RESET}\n" "$SCRIPT_DIR"
printf "  ${C_BOLD}open %s/apps-usage.md${C_RESET}             (각 앱 첫걸음)\n" "$SCRIPT_DIR"
printf "  ${C_BOLD}open %s/windows-to-mac-survival.md${C_RESET}  (윈도우 사용자 생존 가이드)\n" "$SCRIPT_DIR"
exit 0
