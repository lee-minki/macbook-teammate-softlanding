# macbook-teammate-softlanding

맥(macOS)을 처음 쓰면서 **바이브 코딩(AI 보조 개발)** 을 시작하려는 사용자를 위한 Claude Code 스킬.
MacBook/Mac mini 를 한 번에 작업 가능한 기본 환경으로 소프트랜딩시키는 절차를 담는다.

## 무엇을 하나

- **자동 80%**: Xcode CLT → Homebrew → `brew bundle`(에디터/터미널/윈도우 갭 메우기 앱) → Python 3.11 + uv/pipx → Git → AI CLI(Claude Code/Codex/Gemini) → 로컬 LLM(Ollama/LM Studio/MLX). 의존성 게이트 + 자가복구로 "node 없이 Claude Code 가 깔리는" 사고를 막는다.
- **수동 20%**: TCC 권한, Tailscale OAuth, iCloud 동기화 해제, 각 AI 계정 로그인 — macOS 보안 모델상 사용자가 직접.
- **AI 스택**: 클라우드 + 로컬(MLX/Ollama/LM Studio) + 오케스트레이션(로컬↔클라우드 라우팅).

## 구성

```
SKILL.md                          # 스킬 정의 (원칙, 트리거, Response Pattern, Phase 0~11)
references/
├── manual.md                     # 현장 실행 운영 매뉴얼
└── mac-beginner-baseline.md      # 초심자 베이스라인 보정 노트
softlanding/                      # 실행 자산 (딸깍 설치)
├── bootstrap-min.sh              # Stage 0: Ghostty + Claude Code 까지만
├── bootstrap.sh                  # 14단계, 의존성 게이트 + 자가복구 (전부 한 방에)
├── Brewfile                      # brew bundle 정의 (30개)
├── ghostty.config                # Ghostty 초심자 기본 config (비파괴 복사)
├── verify.sh                     # 설치 검증 (OK/WARN/SKIP/FAIL)
├── apps-usage.md                 # 각 앱 첫 5분
├── windows-to-mac-survival.md    # 윈도우 사용자 12가지 함정
├── install-skill.sh              # 스킬을 ~/.claude/skills 등에 설치
├── package.sh                    # 배포용 .tar.gz 패키징
└── prompts/                      # 권한/로그인 안내 헬퍼
```

## 시작 순서 (전후관계)

맥을 처음 켰다면 이 순서로 풀립니다. 핵심은 **먼저 Claude Code 를 띄우고, 나머지는 AI 가 돕게** 하는 것:

```
1. 터미널 확보  → Ghostty        "명령을 칠 창"
2. AI 조수 확보 → Claude Code    "이제 명령을 외울 필요가 없다"
3. 스킬 주도    → Claude Code 에서 이 스킬 호출 → 나머지(앱·설정·권한)를 AI 가 진행
```

```bash
# 1~2단계만 빠르게 (Ghostty + Claude Code 까지)
bash softlanding/bootstrap-min.sh
# → Ghostty 열고 `claude` 실행 → /macbook-teammate-softlanding 호출
```

## 딸깍 설치

```bash
# <OWNER> 는 이 저장소 주소로 교체 (GitHub 의 Code 버튼에서 URL 복사)
git clone https://github.com/<OWNER>/macbook-teammate-softlanding.git
cd macbook-teammate-softlanding
GIT_NAME="본인이름" GIT_EMAIL="본인메일" bash softlanding/bootstrap.sh
```

설치 후 검증과 권한 페이지 열기:

```bash
bash softlanding/verify.sh
bash softlanding/prompts/permissions-open.sh
```

### WinMacKey (선택)
WinMacKey 자동 설치를 원하면 GitHub Release 저장소를 환경변수로 지정한다 (미지정 시 건너뜀):

```bash
WINMACKEY_REPO="owner/repo" GIT_NAME="..." GIT_EMAIL="..." bash softlanding/bootstrap.sh
```

## 스킬로 설치

Claude Code 에서 스킬로 쓰려면 디렉토리를 스킬 경로로 복사한다.

```bash
cp -R macbook-teammate-softlanding ~/.claude/skills/
```

이후 `/macbook-teammate-softlanding` 또는 자연어로 호출한다.

## 설계 원칙

Andrej Karpathy 의 에이전트 지침 원칙과 정렬:
- **Simplicity First** — 자동 가능한 범위만, 무리한 자동화 안 함
- **Surgical Changes** — 비파괴(dotfile 백업 후 marker block만), 멱등 스크립트
- **Goal-Driven Execution** — success criteria + 검증(`verify.sh`, 체크리스트)
- **Response Pattern** — 신규설치/트러블슈팅/단일질문 시나리오별 응답 골격

## 라이선스

MIT
