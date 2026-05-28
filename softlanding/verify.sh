#!/usr/bin/env bash
# MacBook Soft-Landing — 설치/설정 검증
# 사용: bash verify.sh

set -u
if [[ -t 1 ]]; then
  G='\033[32m'; Y='\033[33m'; R='\033[31m'; B='\033[1m'; D='\033[0m'; X='\033[90m'
else
  G=''; Y=''; R=''; B=''; D=''; X=''
fi

OK=0; WARN=0; FAIL=0
chk_ok()   { printf "${G}✔${D} %s\n" "$*"; OK=$((OK+1)); }
chk_warn() { printf "${Y}⚠${D} %s\n" "$*"; WARN=$((WARN+1)); }
chk_fail() { printf "${R}✘${D} %s\n" "$*"; FAIL=$((FAIL+1)); }

section() { printf "\n${B}━━ %s ━━${D}\n" "$*"; }

# ── 시스템 ──
section "시스템"
printf "${X}sw_vers : %s${D}\n" "$(sw_vers -productVersion)"
printf "${X}arch    : %s${D}\n" "$(uname -m)"
printf "${X}user    : %s${D}\n" "$(whoami)"
printf "${X}shell   : %s${D}\n" "$SHELL"

# ── 폴더 ──
section "폴더"
[[ -d "$HOME/worksapces" ]] && chk_ok "~/worksapces" || chk_fail "~/worksapces 없음"
for sub in api-server frontend-web infra-tools data-pipeline shared-lib; do
  [[ -d "$HOME/worksapces/$sub" ]] && chk_ok "~/worksapces/$sub" || chk_warn "~/worksapces/$sub 없음"
done
[[ -d "$HOME/.claude/workspace" ]] && chk_ok "~/.claude/workspace" || chk_fail "~/.claude/workspace 없음"

# ── CLI ──
section "CLI 도구"
v() {
  local name="$1"; shift
  if command -v "$name" >/dev/null 2>&1; then
    chk_ok "$name $("$@" 2>&1 | head -1)"
  else
    chk_fail "$name 미설치"
  fi
}
v brew brew --version
v git git --version
v gh gh --version
v node node --version
v npm npm --version
v python3.11 python3.11 --version
v uv uv --version
v pipx pipx --version
v mas mas version
v jq jq --version
v rg rg --version
v fd fd --version
v tree tree --version
v wget wget --version
if command -v tailscale >/dev/null 2>&1; then
  chk_ok "tailscale $(tailscale version 2>&1 | head -1)"
elif [[ -x "/Applications/Tailscale.app/Contents/MacOS/Tailscale" ]]; then
  chk_ok "Tailscale.app 설치됨 (GUI 앱 기준, CLI PATH 없음)"
else
  chk_warn "tailscale CLI 없음 — Tailscale.app 설치 여부를 아래 앱 검증에서 확인"
fi

# ── 앱 ──
section "앱 (/Applications)"
apps=(
  "AltTab"
  "Maccy"
  "Mos"
  "logioptionsplus"
  "Rectangle"
  "Karabiner-Elements"
  "Stats"
  "RunCat"
  "Amphetamine"
  "Hidden Bar"
  "Ghostty"
  "Visual Studio Code"
  "Cursor"
  "Google Chrome"
  "Raycast"
  "Telegram Desktop"
  "Discord"
  "Claude"
  "WinMacKey"
  "Tailscale"
  "LM Studio"
)
for app in "${apps[@]}"; do
  if [[ -d "/Applications/${app}.app" ]]; then
    chk_ok "${app}.app"
  else
    chk_warn "${app}.app 없음"
  fi
done

# ── Tailscale 상태 ──
section "Tailscale 상태"
TAILSCALE_BIN=""
if command -v tailscale >/dev/null 2>&1; then
  TAILSCALE_BIN="$(command -v tailscale)"
elif [[ -x "/Applications/Tailscale.app/Contents/MacOS/Tailscale" ]]; then
  TAILSCALE_BIN="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
fi
if [[ -n "$TAILSCALE_BIN" ]]; then
  if "$TAILSCALE_BIN" status >/dev/null 2>&1; then
    chk_ok "tailscale status OK"
    "$TAILSCALE_BIN" status 2>&1 | head -5 | sed "s/^/  ${X}/;s/$/${D}/"
  else
    chk_warn "tailscale 로그인 필요 (메뉴바 아이콘 → Log in)"
  fi
else
  chk_warn "Tailscale 상태 확인 불가 — Tailscale.app 설치/실행 확인"
fi

# ── Finder/Dock 설정 ──
section "macOS 기본값"
pb=$(defaults read com.apple.finder ShowPathbar 2>/dev/null || echo "0")
[[ "$pb" == "1" ]] && chk_ok "Finder 경로 막대 ON" || chk_warn "Finder 경로 막대 OFF"
sb=$(defaults read com.apple.finder ShowStatusBar 2>/dev/null || echo "0")
[[ "$sb" == "1" ]] && chk_ok "Finder 상태 막대 ON" || chk_warn "Finder 상태 막대 OFF"
ext=$(defaults read NSGlobalDomain AppleShowAllExtensions 2>/dev/null || echo "0")
[[ "$ext" == "1" ]] && chk_ok "확장자 표시 ON" || chk_warn "확장자 표시 OFF"
h24=$(defaults read NSGlobalDomain AppleICUForce24HourTime 2>/dev/null || echo "0")
[[ "$h24" == "1" ]] && chk_ok "24시간제 ON" || chk_warn "24시간제 OFF"
dh=$(defaults read com.apple.dock autohide 2>/dev/null || echo "0")
[[ "$dh" == "1" ]] && chk_ok "Dock 자동 숨김 ON" || chk_warn "Dock 자동 숨김 OFF"
[[ -f "$HOME/.config/ghostty/config" ]] && chk_ok "Ghostty config" || chk_warn "Ghostty config 없음 (~/.config/ghostty/config)"

# ── Git 설정 ──
section "Git 설정"
gn=$(git config --global user.name 2>/dev/null)
ge=$(git config --global user.email 2>/dev/null)
[[ -n "$gn" ]] && chk_ok "git user.name = $gn" || chk_warn "git user.name 미설정"
[[ -n "$ge" ]] && chk_ok "git user.email = $ge" || chk_warn "git user.email 미설정"

# ── AI CLI ──
section "AI CLI"
for c in claude codex gemini hermes opencode oh-my-opencode omx; do
  if command -v "$c" >/dev/null 2>&1; then
    chk_ok "$c (path: $(command -v "$c"))"
  else
    chk_warn "$c 미설치 또는 PATH 미반영"
  fi
done

# ── 요약 ──
section "요약"
printf "${G}OK %d${D}  ${Y}WARN %d${D}  ${R}FAIL %d${D}\n" "$OK" "$WARN" "$FAIL"
if [[ $FAIL -gt 0 ]]; then
  printf "\n${R}${B}일부 항목 실패.${D} bootstrap.sh 를 다시 실행하거나 위 fail 항목을 수동 설치하세요.\n"
  exit 1
elif [[ $WARN -gt 0 ]]; then
  printf "\n${Y}${B}수동 단계 남음.${D} prompts/permissions-open.sh 로 권한 페이지를 열고 로그인하세요.\n"
  exit 0
else
  printf "\n${G}${B}모두 OK. 인계 가능.${D}\n"
  exit 0
fi
