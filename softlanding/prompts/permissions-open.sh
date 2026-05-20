#!/usr/bin/env bash
# 권한 설정 페이지를 자동으로 열어주는 안내 스크립트
# (TCC 권한은 SIP 보호로 사용자가 직접 토글해야 합니다)

set -u
B='\033[1m'; D='\033[0m'; G='\033[32m'; Y='\033[33m'

cat <<EOF
${B}━━ macOS 권한 허용 안내 ━━${D}

각 권한 페이지가 순서대로 열립니다.
화면 좌측 목록에서 ${B}WinMacKey, Rectangle, Tailscale${D} 등의 스위치를 ON 하세요.
설정 변경 후에는 해당 앱을 완전 종료 후 재실행해야 반영됩니다.

EOF

press() { read -r -p "  ${G}Enter${D} 를 누르면 다음 페이지를 엽니다... " _; }

echo "1) ${B}접근성 (Accessibility)${D} — Rectangle, WinMacKey"
press
open "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility" 2>/dev/null

echo
echo "2) ${B}입력 모니터링 (Input Monitoring)${D} — WinMacKey"
press
open "x-apple.systempreferences:com.apple.preference.security?Privacy_ListenEvent" 2>/dev/null

echo
echo "3) ${B}자동화 (Automation)${D}"
press
open "x-apple.systempreferences:com.apple.preference.security?Privacy_Automation" 2>/dev/null

echo
echo "4) ${B}로그인 항목 (Login Items)${D} — 자동 시작 앱 점검"
press
open "x-apple.systempreferences:com.apple.LoginItems-Settings.extension" 2>/dev/null

echo
echo "5) ${B}iCloud Drive${D} — 데스크탑/문서 동기화 ${Y}해제${D} 권장"
press
open "x-apple.systempreferences:com.apple.preferences.AppleIDPrefPane?iCloud" 2>/dev/null

echo
echo "${G}${B}완료.${D} 권한 ON 후 각 앱을 종료→재실행하세요."
