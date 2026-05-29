#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════════════════════╗
# ║  MacBook Soft-Landing — 최소 부트스트랩 (Stage 0, v1.0.0)             ║
# ║                                                                       ║
# ║  목적: 빈 맥을 "Claude Code 를 띄울 수 있는 상태" 까지만 데려간다.     ║
# ║        터미널(Ghostty) → AI 조수(Claude Code) 까지.                   ║
# ║  그다음: Ghostty 에서 `claude` 실행 → 이 스킬 호출 → 나머지는          ║
# ║          Claude Code 가 bootstrap.sh 로 함께 진행 (앱 30개·설정·권한).║
# ║                                                                       ║
# ║  전체를 한 방에 깔고 싶으면 이 스크립트 대신 bootstrap.sh 를 쓰세요.   ║
# ╚══════════════════════════════════════════════════════════════════════╝

set -u

if [[ -t 1 ]]; then
  C_RESET='\033[0m'; C_BOLD='\033[1m'; C_G='\033[32m'; C_Y='\033[33m'; C_R='\033[31m'; C_X='\033[90m'
else
  C_RESET=''; C_BOLD=''; C_G=''; C_Y=''; C_R=''; C_X=''
fi
ok()   { printf "${C_G}✔${C_RESET} %s\n" "$*"; }
warn() { printf "${C_Y}⚠${C_RESET} %s\n" "$*"; }
info() { printf "${C_X}%s${C_RESET}\n" "$*"; }
step() { printf "\n${C_BOLD}[%s] %s${C_RESET}\n" "$1" "$2"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd)" || SCRIPT_DIR="$PWD"

printf "${C_BOLD}━━ MacBook Soft-Landing — 최소 부트스트랩 (Ghostty → Claude Code) ━━${C_RESET}\n"
[[ "$(uname)" != "Darwin" ]] && { printf "${C_R}macOS 전용입니다.${C_RESET}\n"; exit 1; }
ARCH="$(uname -m)"

# 1) Xcode CLT — Homebrew 의존
step "1/5" "Xcode Command Line Tools"
if xcode-select -p >/dev/null 2>&1; then ok "이미 설치됨"; else
  info "설치 다이얼로그 트리거 (완료까지 대기)"
  xcode-select --install 2>/dev/null || true
  W=0; until xcode-select -p >/dev/null 2>&1 || [[ $W -ge 600 ]]; do sleep 10; W=$((W+10)); done
  xcode-select -p >/dev/null 2>&1 && ok "설치 완료" || { printf "${C_R}✘ Xcode CLT 미설치 — 수동 설치 후 재실행${C_RESET}\n"; exit 1; }
fi

# 2) Homebrew
step "2/5" "Homebrew"
if command -v brew >/dev/null 2>&1; then ok "이미 설치됨"; else
  info "Homebrew 설치 (관리자 비밀번호 필요)"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || { printf "${C_R}✘ Homebrew 설치 실패${C_RESET}\n"; exit 1; }
  if [[ "$ARCH" == "arm64" && -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    grep -q 'brew shellenv' "$HOME/.zprofile" 2>/dev/null \
      || echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
  fi
fi
command -v brew >/dev/null 2>&1 || { printf "${C_R}✘ brew 미인식 — 터미널 새로 열고 재실행${C_RESET}\n"; exit 1; }

# 3) Ghostty(터미널) + node(Claude Code 의존)
step "3/5" "Ghostty + node 설치"
brew install --cask ghostty >/dev/null 2>&1 && ok "Ghostty 설치" || warn "Ghostty 설치 실패 — brew install --cask ghostty 수동 확인 (Terminal 로도 진행 가능)"
# node 는 Claude Code 의 필수 의존 — 실패 시 즉시 중단(이 스크립트의 목표 자체가 안 됨)
brew install node >/dev/null 2>&1 || true
if command -v node >/dev/null 2>&1 && command -v npm >/dev/null 2>&1; then
  ok "node $(node --version 2>/dev/null) / npm $(npm --version 2>/dev/null)"
else
  printf "${C_R}✘ node/npm 설치 실패 — Claude Code 를 깔 수 없습니다. 인터넷/권한 확인 후 'brew install node' 다시.${C_RESET}\n"; exit 1
fi

# 4) Ghostty 기본 config (비파괴)
step "4/5" "Ghostty 기본 config"
GHOSTTY_DIR="$HOME/.config/ghostty"; GHOSTTY_CFG="$GHOSTTY_DIR/config"
mkdir -p "$GHOSTTY_DIR"
if [[ -f "$GHOSTTY_CFG" ]]; then
  cp "$GHOSTTY_CFG" "${GHOSTTY_CFG}.bak.$(date +%Y%m%d_%H%M%S)" 2>/dev/null
  warn "기존 config 보존 (백업 .bak 생성)"
elif [[ -f "${SCRIPT_DIR}/ghostty.config" ]]; then
  cp "${SCRIPT_DIR}/ghostty.config" "$GHOSTTY_CFG" && ok "기본 config 생성"
else
  warn "ghostty.config 미발견 — 설정은 나중에"
fi

# 5) Claude Code (npm global)
step "5/5" "Claude Code CLI"
if command -v npm >/dev/null 2>&1; then
  npm install -g @anthropic-ai/claude-code >/dev/null 2>&1 \
    && ok "claude 설치 (path: $(command -v claude 2>/dev/null))" \
    || warn "claude 설치 실패 — 네트워크/권한 확인 후 npm i -g @anthropic-ai/claude-code"
else
  printf "${C_R}✘ npm 없음 — node 설치 실패. brew install node 후 재실행${C_RESET}\n"; exit 1
fi

# 핸드오프
printf "\n${C_G}${C_BOLD}최소 부트스트랩 완료.${C_RESET}\n"
printf "${C_BOLD}━━ 다음: Claude Code 에게 나머지를 맡깁니다 ━━${C_RESET}\n"
printf "  1) ${C_BOLD}Ghostty${C_RESET} 를 엽니다 (⌘Space → ghostty)\n"
printf "  2) ${C_BOLD}claude${C_RESET} 실행 → 로그인\n"
printf "  3) ${C_BOLD}/macbook-teammate-softlanding${C_RESET} 호출 (또는 \"맥북 소프트랜딩 진행해줘\")\n"
printf "     → 앱 30개·설정·권한 등 나머지를 Claude Code 가 설명하며 진행합니다.\n"
printf "  ${C_X}한 방에 다 깔고 싶다면: bash %s/bootstrap.sh${C_RESET}\n" "$SCRIPT_DIR"
exit 0
