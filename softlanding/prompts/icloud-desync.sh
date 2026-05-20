#!/usr/bin/env bash
# iCloud Drive 데스크탑/문서 동기화 해제 안내
# (자동화 불가 — Apple ID 영역, 사용자가 직접 해제)

B='\033[1m'; D='\033[0m'; Y='\033[33m'

cat <<EOF
${B}━━ iCloud Drive 동기화 해제 (권장) ━━${D}

${Y}왜?${D} 데스크탑/문서가 iCloud 와 동기화되면 파일이 어디 있는지
헷갈리고 회사망 환경에서 업로드가 막힐 수 있습니다.

순서:
1) 시스템 설정 → Apple ID → iCloud → iCloud Drive
2) ${B}데스크탑 및 문서 폴더${D} 항목의 스위치 OFF
3) "이 Mac에 사본 보관" 선택 (Mac 안 데이터 유지)
4) ${B}~/Desktop${D}, ${B}~/Documents${D} 가 로컬 폴더로 돌아왔는지 Finder 에서 확인

EOF

open "x-apple.systempreferences:com.apple.preferences.AppleIDPrefPane?iCloud" 2>/dev/null
echo "${B}iCloud 설정 페이지를 열었습니다.${D}"
