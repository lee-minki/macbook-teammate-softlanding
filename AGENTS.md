# AGENTS.md — 에이전트용 사용 규칙

이 저장소는 단일 Claude Code 스킬 `macbook-teammate-softlanding` 이다. Claude Code / Codex / OpenCode 등 코딩 에이전트가 이 규칙을 따른다.

## 스킬 설치 위치

에이전트로 쓰려면 저장소를 글로벌 스킬 경로에 복사한다 (`softlanding/install-skill.sh` 가 자동 처리):

- Claude Code: `~/.claude/skills/macbook-teammate-softlanding/`
- Codex: `~/.codex/skills/macbook-teammate-softlanding/`
- agents 호환: `~/.agents/skills/macbook-teammate-softlanding/` (있으면)
- OpenCode: 별도 복사 불필요(자동 스캔)

저장소 루트에 `.claude`/`.agents` 같은 repo-local 스킬 디렉토리를 만들지 않는다(사용자가 명시적으로 요청한 테스트 픽스처가 아닌 한).

## 동작 원칙

1. **자동 80% / 수동 20%**: 설치·설정은 `softlanding/bootstrap.sh`(전체) 또는 `bootstrap-min.sh`(Stage 0)로 자동화한다. TCC 권한 토글·각종 OAuth 로그인·iCloud 해제는 macOS 보안 모델상 **사용자가 직접** 하며, 에이전트는 안내만 한다.
2. **side effect 금지**: 사용자 동의 없이 외부 push/메시지 전송/계정 로그인/`gh repo star` 등을 실행하지 않는다.
3. **시크릿 비취급**: 자격증명·토큰·키를 읽거나 저장·복사하지 않는다. [`docs/security-and-secrets.md`](docs/security-and-secrets.md) 참조.
4. **비파괴**: 기존 dotfile 은 백업 후에만 수정한다.

## 검증 / 릴리스

- 변경 후 `bash softlanding/verify.sh`(읽기 전용) 와 `bash -n` 문법 검사.
- 버전은 [`docs/releasing.md`](docs/releasing.md) 의 단일 소스 규약을 따른다.
- 스크립트를 임의로 실행해 사용자 시스템을 바꾸기 전, 무엇을 설치/변경하는지 먼저 설명한다.
