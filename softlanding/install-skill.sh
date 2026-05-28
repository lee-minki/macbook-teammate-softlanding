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

if [[ -t 1 ]]; then G=$'\033[32m'; B=$'\033[1m'; D=$'\033[0m'; else G=''; B=''; D=''; fi

# 이 스크립트는 softlanding/ 안에 있고, SKILL.md/references 는 그 부모(저장소 루트)에 있다.
SRC_ASSETS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"   # .../softlanding
REPO_ROOT="$(cd "$SRC_ASSETS_DIR/.." && pwd)"                    # 저장소 루트

if [[ ! -f "$REPO_ROOT/SKILL.md" ]]; then
  echo "SKILL.md 를 $REPO_ROOT 에서 찾지 못했습니다."
  echo "이 스크립트는 저장소를 clone 한 뒤 softlanding/install-skill.sh 로 실행해야 합니다."
  exit 1
fi

install_to() {
  local target_root="$1" name="$2"
  local target="$target_root/macbook-teammate-softlanding"
  rm -rf "$target"
  mkdir -p "$target"
  # 스킬 정의 + 참고 문서를 저장소 루트에서 복사
  cp "$REPO_ROOT/SKILL.md" "$target/"
  [[ -f "$REPO_ROOT/README.md" ]] && cp "$REPO_ROOT/README.md" "$target/"
  [[ -d "$REPO_ROOT/references" ]] && cp -R "$REPO_ROOT/references" "$target/"
  # softlanding 자산(스크립트, 매뉴얼)도 같이 둠 — 스킬이 직접 참조 가능
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
