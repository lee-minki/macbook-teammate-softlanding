# macbook-teammate-softlanding

맥(macOS)을 처음 쓰면서 **바이브 코딩(AI 보조 개발)** 을 시작하려는 사용자를 위한 Claude Code 스킬.
MacBook/Mac mini 를 한 번에 작업 가능한 기본 환경으로 소프트랜딩시키는 절차를 담는다.

> 🚀 **맥을 처음 받으셨나요?** → **[GETTING-STARTED.md](GETTING-STARTED.md)** 를 순서대로 따라 하세요.
> 터미널이 처음이어도, 윈도우만 쓰던 사람도 됩니다. (명령 복붙 → 중간부터는 AI 가 도와줌)

## ⚡ 빠른 시작

맥에서 **터미널**을 엽니다 — `⌘`(Command) + `Space` → `터미널` 입력 → `Enter`.

**방법 A — ZIP (새 맥에 가장 안전, git 불필요 · 권장)**
1. 이 페이지 위쪽 초록색 **`Code`** → **`Download ZIP`** → 받은 파일 더블클릭(압축 풀기)
2. 터미널에 붙여넣기:
   ```bash
   cd ~/Downloads/macbook-teammate-softlanding-main && bash softlanding/bootstrap-min.sh
   ```

**방법 B — git clone (한 줄)**
```bash
cd ~/Downloads && git clone https://github.com/lee-minki/macbook-teammate-softlanding.git && cd macbook-teammate-softlanding && bash softlanding/bootstrap-min.sh
```

끝나면 안내대로 **Ghostty** 를 열고 → `claude` 실행(로그인) → `/macbook-teammate-softlanding` 호출.
나머지 설치·설정·권한은 Claude Code 가 함께 진행합니다. 막히면 → **[GETTING-STARTED.md](GETTING-STARTED.md)** (단계별 + FAQ).

## 무엇을 하나

- **자동 80%**: Xcode CLT → Homebrew → `brew bundle`(32개: 터미널 Ghostty·에디터·윈도우 갭 메우기 앱·Discord·VDI 등) → Python 3.11 + uv/pipx → Git → AI CLI(Claude Code/Codex/Gemini/Hermes/OpenCode/oh-my-opencode/oh-my-codex + VS Code Codex 확장) → 로컬 LLM(Ollama/LM Studio/MLX). 의존성 게이트 + 자가복구로 "node 없이 Claude Code 가 깔리는" 사고를 막는다.
- **수동 20%**: TCC 권한, Tailscale OAuth, iCloud 동기화 해제, 각 AI 계정 로그인 — macOS 보안 모델상 사용자가 직접.
- **AI 스택**: 클라우드 + 로컬(MLX/Ollama/LM Studio) + 오케스트레이션(로컬↔클라우드 라우팅).

## 구성

```
SKILL.md                          # 스킬 정의 (원칙, 트리거, Response Pattern, Phase 0~11)
GETTING-STARTED.md                # 맥 처음 사용자용 0~7단계 매뉴얼
AGENTS.md · CONTRIBUTING.md       # 에이전트 호환 규칙 · 기여 가이드
docs/
├── manual.md                     # 현장 실행 운영 매뉴얼
├── mac-beginner-baseline.md      # 초심자 베이스라인 보정 노트
├── security-and-secrets.md       # 제외(시크릿/개인정보) 원칙
└── releasing.md                  # 버전 단일소스·릴리스 규약
softlanding/                      # 실행 자산 (자기완결 — tar.gz 로 그대로 배포)
├── bootstrap-min.sh              # Stage 0: Ghostty + Claude Code 까지만
├── bootstrap.sh                  # 14단계, 의존성 게이트 + 자가복구 (전부 한 방에)
├── Brewfile                      # brew bundle 정의 (Apple Silicon 32개)
├── ghostty.config                # Ghostty 초심자 기본 config (비파괴 복사)
├── verify.sh                     # 설치 검증 (OK/WARN/FAIL)
├── apps-usage.md                 # 각 앱 첫 5분 (번들 동봉)
├── windows-to-mac-survival.md    # 윈도우 사용자 12가지 함정 (번들 동봉)
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

> 실제 복붙 명령은 위 **⚡ 빠른 시작** 참고. `bootstrap-min.sh` 가 1~2단계(Ghostty + Claude Code), `bootstrap.sh` 가 전체(14단계).

## 딸깍 설치

```bash
git clone https://github.com/lee-minki/macbook-teammate-softlanding.git
cd macbook-teammate-softlanding
GIT_NAME="본인이름" GIT_EMAIL="본인메일" bash softlanding/bootstrap.sh
```

설치 후 검증과 권한 페이지 열기:

```bash
bash softlanding/verify.sh
bash softlanding/prompts/permissions-open.sh
```

### WinMacKey (선택)
WinMacKey 는 **DMG 를 자동 설치하지 않고 GitHub 레포(릴리스)를 참조·안내**한다(보안/신뢰 경계). 릴리스 저장소를 환경변수로 지정하면(미지정 시 안내 생략):

```bash
WINMACKEY_REPO="owner/repo" GIT_NAME="..." GIT_EMAIL="..." bash softlanding/bootstrap.sh
```

설치 버전과 최신 릴리스 tag 를 비교해 **새 버전이 있으면 알리고 릴리스 페이지를 열어준다**. 실제 설치/업데이트(DMG → /Applications 드래그)는 사용자가 직접 한다. 레포가 계속 업데이트되니, 새 빌드가 올라오면 릴리스 페이지에서 받아 교체하면 된다.

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
