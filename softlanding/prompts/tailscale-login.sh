#!/usr/bin/env bash
# Tailscale 로그인 안내

set -u
B='\033[1m'; D='\033[0m'; G='\033[32m'; Y='\033[33m'

cat <<EOF
${B}━━ Tailscale 로그인 ━━${D}

1) 메뉴바의 Tailscale 아이콘 클릭 → ${B}Log in${D}
2) 브라우저에서 회사/팀 계정으로 로그인
3) 기기 이름 승인

EOF

# 앱 실행
if [[ -d "/Applications/Tailscale.app" ]]; then
  open -a "Tailscale"
  echo "${G}Tailscale 앱을 실행했습니다.${D} 메뉴바 아이콘을 확인하세요."
else
  echo "${Y}Tailscale.app 이 /Applications 에 없습니다. 먼저 bootstrap.sh 를 실행하세요.${D}"
fi

echo
echo "잠시 후 상태를 확인합니다 (10초 대기)..."
sleep 10
if command -v tailscale >/dev/null 2>&1; then
  tailscale status 2>&1 | head -10
else
  echo "${Y}tailscale CLI 미설치 — brew install tailscale 필요${D}"
fi
