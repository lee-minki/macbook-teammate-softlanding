#!/usr/bin/env bash
# 이 스킬을 Claude Code / Codex / OpenCode 가 찾을 수 있는 위치로 복사한다.
# 메모리상 reference_skill_install_paths 패턴 그대로:
#   - Claude Code: ~/.claude/skills/
#   - Codex:       ~/.codex/skills/
#   - OpenCode:    자동 스캔 (skip)
#
# 사용:
#   bash install-skill.sh
#
# 결과:
#   사용자가 Claude Code 에서 macbook-teammate-softlanding 스킬을 호출할 수 있음
#   호출하면 Claude 가 bootstrap.sh 실행을 안내함

set -eu

if [[ -t 1 ]]; then G='\033[32m'; B='\033[1m'; D='\033[0m'; else G=''; B=''; D=''; fi

SRC_SKILL_DIR="$HOME/.hermes/skills/software-development/macbook-teammate-softlanding"
SRC_ASSETS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ ! -f "$SRC_SKILL_DIR/SKILL.md" ]]; then
  echo "SKILL.md 가 $SRC_SKILL_DIR 에 없습니다."
  echo "이 install-skill.sh 는 hermes 스킬이 그 위치에 있을 때만 동작합니다."
  exit 1
fi

install_to() {
  local target_root="$1" name="$2"
  local target="$target_root/macbook-teammate-softlanding"
  mkdir -p "$target"
  cp -R "$SRC_SKILL_DIR/." "$target/"
  # softlanding 자산(스크립트, 매뉴얼)도 같이 둠 — 스킬이 직접 참조 가능
  rm -rf "$target/softlanding"
  cp -R "$SRC_ASSETS_DIR" "$target/softlanding"
  printf "${G}✔${D} %s → %s\n" "$name" "$target"
}

# Claude Code
mkdir -p "$HOME/.claude/skills"
install_to "$HOME/.claude/skills" "Claude Code"

# Codex (있을 때만)
if [[ -d "$HOME/.codex" ]]; then
  mkdir -p "$HOME/.codex/skills"
  install_to "$HOME/.codex/skills" "Codex"
else
  printf "  ${B}(skip)${D} ~/.codex 없음 — Codex 미사용으로 간주\n"
fi

cat <<EOF

${G}${B}완료.${D} Claude Code 에서 다음과 같이 사용할 수 있습니다:

  cd /  (또는 아무 곳)
  claude
  > /macbook-teammate-softlanding   # 또는 자연어로 "맥북 소프트랜딩 진행해줘"

스킬이 호출되면 SKILL.md 흐름에 따라 안내합니다. 자동 설치를 바로 돌리려면:

  bash ~/.claude/skills/macbook-teammate-softlanding/softlanding/bootstrap.sh

EOF
