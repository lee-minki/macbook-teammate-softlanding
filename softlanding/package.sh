#!/usr/bin/env bash
# softlanding 폴더 전체를 tar.gz 로 패키징
# 사내망/USB/Slack/AirDrop 으로 신규 맥북에 전달용
#
# 사용:
#   bash package.sh
# 결과:
#   ../softlanding-YYYYMMDD.tar.gz
#
# 수신 측 사용법:
#   tar -xzf softlanding-*.tar.gz -C ~/Downloads
#   cd ~/Downloads/softlanding
#   GIT_NAME="..." GIT_EMAIL="..." bash bootstrap.sh

set -eu

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(dirname "$SRC_DIR")"
DATE_TAG="$(date +%Y%m%d-%H%M%S)"   # 시각 포함 — 같은 날 재실행해도 덮어쓰지 않음
OUT="$PARENT_DIR/softlanding-${DATE_TAG}.tar.gz"

# .DS_Store 등 노이즈 제외
tar --exclude='.DS_Store' --exclude='._*' \
    -czf "$OUT" \
    -C "$PARENT_DIR" \
    softlanding

SIZE=$(du -h "$OUT" | awk '{print $1}')
echo "✔ 패키지 생성: $OUT ($SIZE)"
echo ""
echo "수신 측 명령:"
echo "  tar -xzf $(basename "$OUT") -C ~/Downloads"
echo "  cd ~/Downloads/softlanding"
echo "  GIT_NAME=\"본인이름\" GIT_EMAIL=\"본인메일\" bash bootstrap.sh"
