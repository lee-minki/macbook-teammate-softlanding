# 기여 가이드

`macbook-teammate-softlanding` 에 기여할 때 따르는 규칙.

## 구조

```
SKILL.md            스킬 정의(에이전트가 읽는 핵심). frontmatter + 원칙/트리거/Phase
GETTING-STARTED.md  맥 처음 사용자용 단계별 매뉴얼
AGENTS.md           에이전트 호환 규칙
docs/               운영 매뉴얼·보정 노트·보안·릴리스 규약
softlanding/        실행 자산(스크립트·Brewfile·config·prompts). tar.gz 로 자기완결 배포
```

- 마크다운 가이드 중 `apps-usage.md` / `windows-to-mac-survival.md` 는 **의도적으로 `softlanding/` 안**에 둔다 — `package.sh` 가 만드는 tar.gz 번들이 오프라인에서 자기완결이어야 하기 때문.

## 원칙

1. **배포 중립성** — 개인/조직 식별자(실명, 사번, 팀/회사명, 사내 IP, 내부 프로젝트명, 절대경로)를 넣지 않는다. 저장소 URL 은 예외(현재 upstream).
2. **비파괴 + 멱등** — 재실행해도 안전하고, 기존 설정은 백업 후에만 수정.
3. **시크릿 비취급** — [`docs/security-and-secrets.md`](docs/security-and-secrets.md).
4. **자동/수동 경계 유지** — macOS 가 막는 영역은 자동화하지 말고 안내한다.

## 변경 전후

```bash
# 문법
bash -n softlanding/*.sh softlanding/prompts/*.sh
# 검증(읽기 전용, 현재 머신 기준)
bash softlanding/verify.sh
# Brewfile 토큰 실재 확인(설치 없이)
brew info --cask <token>   # 또는 --formula
```

- 새 패키지/도구를 추가하면 **Brewfile/bootstrap·verify·문서(수치·로스터)** 를 한 번에 맞춘다.
- 버전은 [`docs/releasing.md`](docs/releasing.md) 단일 소스 규약을 따른다.

## GitHub 스타

에이전트는 자동으로 누르지 않는다. 사용자가 동의한 경우에만 `gh repo star` 를 실행한다.
