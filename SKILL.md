---
name: macbook-teammate-softlanding
description: "Use when setting up a Mac for someone using macOS for the first time, typically a user coming from Windows. Provides a one-click bootstrap.sh that handles the automatable 80% — Xcode CLT, Homebrew + brew bundle (30 packages including AltTab/Maccy/Mos/Rectangle/Karabiner/Ghostty/VS Code/Cursor/Claude Desktop), WinMacKey DMG fetch via GitHub Release, mas for Amphetamine/Hidden Bar, defaults write for Finder/Dock/scroll-direction/dark-mode/key-repeat/screenshot, Python 3.11 + uv + pipx, Git config, npm globals for Claude Code/Codex/Gemini — with dependency gating + self-heal so that e.g. Claude Code never runs without node. Demarcates the manual 20% (Apple ID, TCC permissions, Tailscale OAuth, iCloud desync, per-AI login). Excludes personal vaults, password managers, secrets, and private accounts from any prior system. Companion docs: windows-to-mac-survival.md (12 Windows-user pitfalls) and apps-usage.md (each installed app's first 5 minutes)."
version: 1.5.0
author: Hermes Agent
license: MIT
platforms: [macos]
metadata:
  hermes:
    tags: [macbook, macos-beginner, onboarding, softlanding, vibe-coding, finder, homebrew, tailscale, mlx, ai-tools]
    related_skills: [hermes-agent, hermes-omx-workspace-bootstrap, mk-workspaces-operations, macos-terminal-remapper-conflict-debugging, systematic-debugging]
---

# MacBook Teammate Soft-Landing

## Overview

이 스킬은 Mac을 처음 쓰면서 바이브 코딩(AI 보조 개발)을 시작하려는 사용자를 대상으로, MacBook/Mac mini를 한 번에 작업 가능한 기본 환경으로 소프트랜딩시키는 절차다. 동봉 HTML 가이드가 초보자 흐름의 형태 기준이며, 그 문서의 방향처럼 “처음 15분 빠른 시작 → Finder/단축키/설치/권한 → 작업 폴더 → Tailscale → 생산성 앱 → Homebrew/Node/Git → AI 도구(클라우드 + 로컬 MLX + 오케스트레이션) → 최종 검증” 순서로 간다.

목표는 개인 시스템의 복제가 아니다. 사용자가 맥을 무서워하지 않고 업무 폴더를 찾고, 앱을 설치하고, 권한을 허용하고, Git/Node/AI 도구를 검증할 수 있게 만드는 것이다. 초심자용 설명, 스크린샷/체크리스트, 복붙 가능한 명령어를 우선한다.

### 온보딩 순서 (전후관계 — 이 스킬의 척추)

빈 맥은 사실상 이 순서로 풀린다. 모든 안내는 이 흐름을 기준으로 한다.

```text
0. (빈 맥)
1. 터미널 확보  → Ghostty        "명령을 칠 창"
2. AI 조수 확보 → Claude Code    "이제 명령을 외울 필요가 없어진다"
3. 스킬 주도    → Claude Code 안에서 이 스킬 호출
                  → 나머지(앱 30개·설정·권한 20%)를 Claude Code 가 설명하며 진행
```

- `softlanding/bootstrap-min.sh` = 0→2단계만 (Ghostty + node + Claude Code + Ghostty config). "claude 를 띄우는 것"이 목표.
- `softlanding/bootstrap.sh` = 0→3단계 전부를 비대화식 한 방에. 끝에 "Ghostty 에서 `claude` 실행 → 이 스킬로 이어가라"는 핸드오프를 출력한다.
- 즉, 진짜 초심자에게 권하는 경로는 **min 으로 Claude Code 까지 띄운 뒤, 나머지는 Claude Code + 이 스킬이 대화식으로** 처리하는 것이다.

## Response Pattern (모든 응답에 적용 — 절대 어기지 않음)

시나리오가 신규 설치든, 트러블슈팅이든, 단일 기능 질문이든 **첫 응답**에 아래를 빠뜨리지 않는다. 트러블슈팅·단일 질문이라고 자동 경로/의존성/경로 인용을 생략하지 말 것 — 그게 가장 흔한 실패다.

### A. 신규 설치/환경 구축 ("새 맥북", "한 번에 깔아줘", "바이브 코딩 환경")
첫 코드블록으로 자동 설치 한 줄:
```bash
cd ~/Downloads/softlanding
GIT_NAME="..." GIT_EMAIL="..." bash bootstrap.sh
```
이어서 의존성 체인(Xcode CLT → Homebrew → brew bundle → 핵심 CLI 6종 + Tailscale.app → AI CLI/MLX)을 한 번 명시.

### B. 트러블슈팅 ("X 안 됨", "Y 망가짐")
첫 단락에 반드시:
1. `softlanding/bootstrap.sh` 는 멱등 — 다시 돌려도 안전하다는 한 줄
2. 의존성 체인에서 망가진 위치 한 줄 (예: "node 없으면 Claude Code 가 깔리는 자리에서 또 깨진다")
3. 그 후 시나리오별 진단

### C. 단일 기능/도구 질문 ("스크롤 이상", "MLX vs Ollama", "오케스트레이션 구성")
첫 단락에 반드시:
1. 그 항목을 `softlanding/bootstrap.sh` 의 어느 단계(`brew bundle`/`defaults write`/MLX venv)가 이미 처리했는지 한 줄
2. 관련 의존성 한 줄 (예: MLX 는 python3.11 + uv 의존, AI CLI 는 node 의존). 외부 입력장치(마우스 스크롤 방향 등) GUI 토글은 사용자가 직접 한다는 점도 해당되면 명시
3. 그 후 상세 답변 + 정확한 경로 인용

### 의존성 체인 (어떤 시나리오에서도 관련되면 한 번은 언급)
```text
Xcode CLT → Homebrew → brew bundle → 핵심 CLI 6종(git/node/npm/python3.11/mas/gh) + Tailscale.app
  ├─ AI CLI(Claude Code/Codex/Gemini): node/npm 필수
  └─ MLX(mlx-lab venv): python3.11 + uv 필수, Apple Silicon 전용
```

### 경로 인용 규칙 (절대 어기지 않음)
모든 파일/디렉토리는 정확한 경로로 인용한다. 누락·약식 표기 금지. 단, 코드블록에서 직전에 `cd ~/Downloads/softlanding` 를 실행한 경우에는 실제 실행 가능한 로컬 이름(`bootstrap.sh`, `verify.sh`, `prompts/permissions-open.sh`)을 쓴다.

| 올바른 인용 | 잘못된 인용 |
|---|---|
| `softlanding/bootstrap.sh` | `bootstrap.sh` |
| `softlanding/verify.sh` | `verify.sh` |
| `softlanding/apps-usage.md` | `apps-usage.md` |
| `softlanding/windows-to-mac-survival.md` | `survival.md` |
| `softlanding/prompts/permissions-open.sh` | `permissions-open.sh` |
| `~/worksapces/mlx-lab/.venv/bin/python` | `mlx-lab` |

### 자동화 불가 단계 정형 표현
TCC 권한(접근성/입력 모니터링/자동화), Tailscale OAuth 로그인 + tailnet 관리자 device 승인, iCloud Drive 데스크탑/문서 동기화 해제, 각 AI 도구 계정 로그인, 로컬 모델 대용량 다운로드, 외부 마우스 스크롤 방향(Mos/시스템 설정) — 이들은 **사용자가 직접** 처리하는 영역임을 시나리오에 맞게 한 번 이상 명시한다. `softlanding/prompts/permissions-open.sh` 가 권한 페이지를 순차 오픈하는 헬퍼임을 가능하면 인용한다.

## Hard Exclusions

아래는 기본 범위에서 제외한다. “당연히 빼야 하는 것들”이다.

- 개인 Vault / Obsidian Vault 원본 / 개인 노트 구조
- Bitwarden, 1Password, 브라우저 저장 비밀번호, 패스키, OTP, SSH private key
- 개인 API token, OAuth token, Claude/OpenAI/Gemini 계정 세션
- KakaoTalk, Telegram, iMessage, 개인 메일, 개인 캘린더
- 회사 비공개 코드/문서/인증서/접속정보의 무단 복사
- 자동 메시지 전송, 이메일 발송, 외부 push 같은 side effect 자동화
- 사용자가 이해하지 못한 상태의 dotfile 대량 복사

비밀번호 관리자는 “사용자 본인이 설치/로그인해야 하는 개인 보안 도구”로만 언급한다. Bitwarden 내용을 세팅 절차에 넣지 않는다.

## When to Use

사용한다:
- 사용자가 맥을 처음 써서 Finder, Dock, 단축키, 앱 설치, 권한 허용부터 안내해야 할 때
- Windows 사용자에게 MacBook Pro/Mac mini 업무 환경을 부드럽게 적응시켜야 할 때
- `~/worksapces`, `.claude/workspace`, Tailscale, Raycast/RunCat/Chrome, Homebrew/Node/Git, Claude Code/Codex/OpenClaw 같은 표준을 단계적으로 설치/검증할 때
- HTML 온보딩 문서, 설치 체크리스트, 사용자용 Quick Start, 검증표를 만들 때

사용하지 않는다:
- 개인 지식관리 시스템을 사용자에게 이식하려는 경우
- 회사 보안망/격리망 장비 배포처럼 별도 승인 절차가 필요한 경우
- Windows Server 인계 작업
- macOS가 아닌 환경

## Goal Keyword Block

새 goal, plan, Seed, README, 온보딩 문서에 아래 키워드를 우선 사용한다.

```text
MacBook soft-landing, Mac beginner onboarding, Mac work setup, Windows-to-macOS transition,
first 15 minutes quick start, Finder basics, column view, path bar, status bar, file extension display,
macOS shortcuts, Command/Option/Control, trackpad gestures, Dock, menu bar, System Settings,
DMG install, Applications folder, Gatekeeper warning, Accessibility permission, Input Monitoring,
Automation permission, Login Items, Full Disk Access, app restart after permission,
Downloads cleanup, zip/unzip, Trash, app uninstall, screenshots, Quick Look, file handoff,
iCloud Drive Desktop/Documents sync off, 24-hour clock, sleep prevention, Dock auto hide,
Windows-like keyboard comfort, WinMacKey, Rectangle, Karabiner optional, Hammerspoon optional,
workspace folder, /Users/<account>/worksapces, .claude/workspace, hidden files, path copy,
Tailscale install, tailscale status, remote access basics,
Raycast, RunCat, Chrome, Telegram optional, productivity apps,
Homebrew latest, Node.js latest stable, npm current bundled, Git latest, Python 3.11 baseline, uv/pipx optional,
Claude Desktop, Claude Code CLI, Codex CLI, OpenClaw CLI, Playwright CLI,
beginner-friendly Korean guide, screenshots, copy-paste commands, verification-first,
no personal vault, no Bitwarden setup, no secret copying, no private account copying,
non-destructive setup, backup before dotfile edits, team handoff, rollback notes
```

## Canonical Goal Prompt

```text
Goal: Mac을 처음 접하는 사용자를 위해 MacBook/Mac mini 소프트랜딩 환경을 구축한다.
핵심은 macOS 기초 적응, Finder/단축키/앱 설치/권한 허용 이해, 표준 작업 폴더, Tailscale, 생산성 앱, Homebrew/Node/Git, AI 도구를 초보자 친화적으로 설치·검증하는 것이다.
이전 시스템/다른 사람의 개인 Vault, Bitwarden/비밀번호 관리자 데이터, 토큰, 메시지 계정, 개인 노트, 회사 비공개 자료는 절대 복사하지 않는다.
모든 설정은 비파괴적이고 되돌릴 수 있어야 하며, 사용자가 이해할 수 있도록 스크린샷·복붙 명령어·체크리스트 중심으로 문서화한다.
우선순위는 1) 초심자 빠른 적응 2) 보안/개인정보 제외 3) Finder/설치/권한 흐름 4) 작업 폴더 5) 필수 앱 6) 개발도구 7) AI 도구 8) 검증/인계다.
```

## Reference Source

스킬 운영 매뉴얼:

```text
references/manual.md
```

실제 온보딩을 실행할 때는 먼저 `references/manual.md`를 열고, 그 매뉴얼의 진행 순서와 최종 검증표를 기준으로 작업한다. SKILL.md는 원칙과 트리거, manual.md는 현장 실행 절차다.

참고할 로컬 자료:

자산 묶음 (이 스킬과 같은 위치에 배포되는 `softlanding/` 폴더):

```text
softlanding/                       # 자동화 자산 (이 스킬이 실행 기준)
├── bootstrap-min.sh               # Stage 0: Ghostty + Claude Code 까지만 (전후관계 1·2단계)
├── bootstrap.sh                   # 14단계, 의존성 게이트 + 자가복구 (전부 한 방에)
├── Brewfile                       # 30개 (brew 13 + cask 17)
├── ghostty.config                 # Ghostty 초심자 기본 config (비파괴 복사)
├── verify.sh                      # OK/WARN/SKIP/FAIL 체크리스트
├── apps-usage.md                  # 각 앱 첫 5분
├── windows-to-mac-survival.md     # 윈도우 사용자 12가지 함정
├── install-skill.sh               # 이 스킬을 ~/.claude/skills/ + ~/.codex/skills/ 에 설치
├── package.sh                     # 배포용 .tar.gz 패키징
└── prompts/
    ├── permissions-open.sh        # TCC 권한 페이지 순차 열기
    ├── tailscale-login.sh         # Tailscale 앱 실행 + 상태 확인
    └── icloud-desync.sh           # iCloud Drive 데스크탑/문서 동기화 해제 안내
```

보조 참고 노트:
- `references/mac-beginner-baseline.md`: Mac 초심자 대상, 개인 Vault/Bitwarden 제외, 최신 안정판 앱/Node 기준, Python 3.11 기준 등 보정사항.

이 자료에서 반영할 핵심 목차:
- 처음 15분 빠른 시작
- 시작 전 체크: Apple ID, 관리자 권한, 인터넷/사내망
- macOS 기초 단축키와 트랙패드
- Finder 기본 사용과 추천 설정
- 경로 구조, 숨김 파일, 복사/이동 규칙
- 앱 설치 방식과 보안 경고 대응
- 권한 허용: 손쉬운 사용, 입력 모니터링, 자동화, 로그인 항목
- 메뉴 막대, Dock, 시스템 설정 읽는 법
- 다운로드, 압축 해제, 휴지통, 앱 제거
- 스크린샷, Quick Look, 파일 전달
- 초보자 FAQ
- iCloud/Dock/절전 등 필수 시스템 설정
- Windows식 키보드 편의: WinMacKey, Rectangle
- 워크스페이스 폴더와 Tailscale
- Raycast, RunCat, Chrome, Telegram 등 생산성 앱
- Homebrew + Node + Git
- 원격 제어 방식
- AI 도구 및 OpenClaw 설정
- 최종 검증 체크리스트

## Soft-Landing Principles

1. 맥 초심자 우선
   - “왜 이걸 하는지”부터 설명한다.
   - 단축키 이름만 던지지 말고 Windows 기준 대응을 같이 적는다.
   - 복붙 명령어는 짧게, 실행 후 기대 결과를 같이 적는다.

2. 개인 정보 제외
   - 개인 데이터와 보안 도구는 세팅 범위가 아니다.
   - 비밀번호/토큰/개인 계정은 사용자가 직접 로그인한다.

3. 비파괴 우선
   - 기존 `.zshrc`, `.gitconfig`, SSH 설정은 백업 후 marker block으로만 수정한다.
   - dotfile 통째 복사는 금지한다.

4. 스크린샷/체크리스트 우선
   - 초심자는 터미널 출력보다 화면 위치와 체크박스가 빠르다.
   - `softlanding/screenshots/` 스타일의 근거 이미지를 우선 활용한다.

5. 설치보다 검증
   - 설치 성공은 끝이 아니다. `open -a`, `which`, `--version`, `tailscale status`까지 확인한다.

6. 버전 기준점은 명시하되, 앱은 최신 안정판
   - Chrome/Raycast/RunCat/Rectangle/Tailscale/Claude/Codex/OpenClaw 같은 일반 앱과 CLI는 설치 시점의 최신 안정판을 기본값으로 한다.
   - Node.js는 Homebrew가 제공하는 최신 안정판을 기본으로 설치한다. 별도 프로젝트가 특정 LTS를 요구할 때만 버전 매니저를 검토한다.
   - Python은 3.11을 기준점으로 둔다. “시스템 Python을 건드리지 않고 Python 3.11 사용자 공간을 추가한다”가 원칙이다.
   - 버전 숫자를 문서에 박제하지 말고, 설치 직후 `--version` 결과를 인계 문서에 기록한다.

## Target Architecture

기본 팀 구조:

```text
/Users/<account>/
├── worksapces/              # 표준 작업 폴더. 문서 기준 경로도 이쪽.
│   ├── api-server/
│   ├── frontend-web/
│   ├── infra-tools/
│   ├── data-pipeline/
│   └── shared-lib/
├── Downloads/               # 설치 파일/압축 파일 임시 위치. 방치 금지.
├── Documents/               # 일반 문서/보고서. 코드 저장소와 섞지 않기.
└── .claude/workspace/       # Claude/AI 작업용 숨김 폴더.
```

주의:
- 이 스킬에서는 개인 지식관리 Vault를 만들지 않는다.
- `worksapces` 오타는 팀 문서/스크립트 호환을 위해 유지한다.
- 사용자가 오타를 혼란스러워하면 문서에 “표준 경로라서 그대로 쓴다”고 명시한다.

## Automation Boundary (v1.5.0)

"딸깍"의 현실적 경계를 먼저 명시한다. 무리하게 자동화를 시도하지 않는다.

자동화 **가능** — `softlanding/bootstrap.sh` 가 의존성 게이트 + 자가복구로 처리:
- Xcode CLT → Homebrew → `brew bundle` (30 패키지)
- 핵심 CLI 6종(git/node/npm/python3.11/mas/gh) 즉시 재검증 + 빠진 것 자동 재설치. Tailscale은 초심자 로그인 흐름을 위해 `tailscale-app` cask GUI 앱을 기본 설치
- 윈도우 갭 메우기 cask: AltTab, Maccy, Mos, Rectangle, The Unarchiver, Logi Options+, Karabiner-Elements, Stats
- 터미널: Ghostty (GPU 가속, 초심자 첫 "명령 치는 창") + `~/.config/ghostty/config` 기본값 비파괴 작성(기존 있으면 .bak 백업 후 보존)
- 에디터: VS Code, Cursor
- 클라우드 AI: Claude Desktop + npm globals (Claude Code/Codex/Gemini)
- 로컬 LLM: Ollama(brew), LM Studio(cask), MLX(`~/worksapces/mlx-lab` venv, Apple Silicon 전용 — `uv pip install mlx mlx-lm`)
- App Store(mas): Amphetamine(절전 방지), Hidden Bar(메뉴바 정리)
- WinMacKey: 팀이 지정한 GitHub Release 의 Latest(Published) DMG 를 `gh release download` 또는 GitHub API 로 fetch. 저장소는 `WINMACKEY_REPO` 환경변수로 주입한다. 미지정 시 `softlanding/bootstrap.sh` 는 자동 설치를 건너뛰고 수동 설치 안내만 한다. Draft 릴리스는 자동으로 건너뛴다.
- `~/worksapces/{api-server,frontend-web,infra-tools,data-pipeline,shared-lib}` + `~/.claude/workspace`
- `defaults write` 일괄 — Finder(경로/상태 막대, 컬럼, 확장자), Dock(자동 숨김), 키 반복(가장 빠름), 자연 스크롤 OFF, 다크모드 ON, 스크린샷(PNG/그림자 제거/다운로드 폴더), .DS_Store 네트워크/USB 비생성, 24시간제
- `pmset -c displaysleep 30 sleep 0` (sudo 가능할 때)
- `git config --global user.name/email/init.defaultBranch/pull.rebase` (환경변수 `GIT_NAME`, `GIT_EMAIL`)

자동화 **불가능** — 사용자가 직접 (macOS 보안 모델상):
- Apple ID 로그인, iCloud Drive 데스크탑/문서 동기화 해제
- TCC 권한 토글 (접근성, 입력 모니터링, 자동화) — SIP 보호로 GUI 토글 필수
- Tailscale OAuth 로그인 + tailnet 관리자 device 승인
- WinMacKey 초기 권한 부여 후 첫 실행
- Claude / Codex / Gemini / OpenClaw 각 계정 로그인

→ `bootstrap.sh` 마지막 단계에서 `prompts/permissions-open.sh` 안내. 그 스크립트가 권한/iCloud 페이지를 순차 자동 오픈.

### 의존성 체인 (★ 핵심)

```text
Xcode CLT  ─→  Homebrew  ─→  brew bundle  ─→  핵심 CLI 6종 재검증 + Tailscale.app
                                                    │
                                                    ├─→  mas (Amphetamine, Hidden Bar)
                                                    ├─→  git config (GIT_NAME/GIT_EMAIL)
                                                    ├─→  python3.11 검증 (uv, pipx)
                                                    └─→  ★ AI CLI (node/npm 필수)
```

`require_cmd <cmd> <self_heal>` 게이트가 각 단계 진입 전 의존 명령어를 확인하고, 없으면 자동 재설치를 시도한다. 그래도 안 되면 그 단계만 SKIP 하고 다음으로 진행 — 줄줄이 실패하지 않게.

## Phase 0 (Auto): bootstrap.sh

```bash
# 옵션 A — 최소 부트스트랩: 터미널(Ghostty) + Claude Code 까지만.
#          그다음은 Ghostty 에서 claude 를 띄워 이 스킬로 이어간다 (권장 초심자 경로)
cd ~/Downloads/softlanding
bash bootstrap-min.sh

# 옵션 B — 풀 부트스트랩: 0→3단계 전부 한 방에
cd ~/Downloads/softlanding
GIT_NAME="홍길동" GIT_EMAIL="hong@company.com" bash bootstrap.sh

# 원격 (public mirror 가 있다면)
GIT_NAME="홍길동" GIT_EMAIL="hong@company.com" \
bash <(curl -fsSL <URL>/bootstrap.sh)
```

옵션:
- `SKIP_AI=1` — AI CLI npm globals 건너뜀
- `SKIP_MAS=1` — Amphetamine/Hidden Bar 건너뜀
- `SKIP_DEFAULTS=1` — defaults write 건너뜀
- `DARK_MODE=0` — 다크모드 적용 안 함 (기본 1)
- `NATURAL_SCROLL=1` — Mac 기본 자연 스크롤 유지 (기본 0 = 윈도우식)

멱등(idempotent). 재실행 안전. 출력 마지막에 OK/WARN/SKIP/FAIL 요약 + 다음 명령 안내.

검증:
```bash
bash verify.sh
```

권한 페이지 일괄 오픈:
```bash
bash prompts/permissions-open.sh
```

## Claude Code / Codex 등록

`install-skill.sh` 한 번 실행으로 이 스킬이 Claude Code(`~/.claude/skills/`) 와 Codex(`~/.codex/skills/`) 에 등록된다. 이후 사용자는 Claude Code 에서 `/macbook-teammate-softlanding` 또는 자연어로 호출해 자동 설치 흐름을 받는다.

```bash
bash softlanding/install-skill.sh
```

## Phase 0 (Manual fallback): Start Check

```bash
sw_vers
uname -m
whoami
pwd
echo $SHELL
xcode-select -p 2>/dev/null || true
which brew || true
which git || true
which python3.11 || true
which python3 || true
which node || true
which npm || true
```

확인 항목:
- Apple ID 로그인 여부
- 관리자 권한 여부
- 계정명과 컴퓨터 이름
- 인터넷/사내망/VPN/Tailscale 필요 여부
- Apple Silicon 여부
- 회사 보안 정책상 설치 가능한 앱
- Claude/OpenAI 등 사용자가 직접 로그인 가능한 계정 여부

## Phase 1: First 15 Minutes

처음 15분은 이것만 한다.

1. 작업 폴더 위치 확인
   - `/Users/<account>/worksapces`
   - Finder에서 해당 폴더를 열어 보여준다.

2. Finder 기본값 맞추기
   - 컬럼 보기
   - 경로 막대 표시
   - 상태 막대 표시
   - 모든 파일 확장자 보기

3. 설치/권한 흐름 익히기
   - DMG는 앱 아이콘을 Applications로 드래그
   - 권한은 시스템 설정에서 허용
   - 허용 후 앱 재실행

4. Tailscale 연결 확인
   - 설치보다 로그인과 `tailscale status`가 중요하다.

## Phase 2: Finder and macOS Basics

초심자에게 반드시 설명할 내용:

- `Command`는 Windows의 `Ctrl`과 비슷하게 자주 쓰인다.
- `Option`은 숨은 메뉴/복사-이동 동작에 영향을 준다.
- 창의 빨간 버튼은 앱 종료가 아니라 창 닫기일 수 있다. 앱 종료는 `Command + Q`.
- Finder는 파일 탐색기 역할이다.
- `Command + Space` 또는 Raycast로 앱을 실행한다.
- Quick Look은 파일 선택 후 Space.
- 스크린샷은 `Command + Shift + 4`부터 익힌다.

권장 Finder 설정 예시:

```bash
# 숨김 파일 보기 토글에 익숙해질 때 사용
# Finder UI에서도 Command + Shift + . 로 가능
defaults write com.apple.finder AppleShowAllFiles -bool true
killall Finder
```

단, 초심자 장비에서는 숨김 파일을 항상 켜는 것이 부담일 수 있다. 필요할 때만 알려줘도 된다.

## Phase 3: App Install and Permissions

설치 파일 이해:

```text
.dmg      디스크 이미지. 열고 앱을 Applications로 드래그.
.pkg      설치 마법사. 다음/계속으로 설치.
.zip      압축 파일. 더블클릭 후 앱/폴더 확인.
App Store 앱  자동 업데이트/삭제가 쉬움.
```

권한 위치:

```text
시스템 설정 → 개인정보 보호 및 보안 → 손쉬운 사용
시스템 설정 → 개인정보 보호 및 보안 → 입력 모니터링
시스템 설정 → 개인정보 보호 및 보안 → 자동화
시스템 설정 → 일반 → 로그인 항목 및 확장 프로그램
```

권한 허용 순서:
1. 앱을 먼저 한 번 실행
2. 경고창에서 시스템 설정 열기 또는 허용 선택
3. 목록에서 앱 스위치 켜기
4. 관리자 비밀번호 또는 Touch ID 승인
5. 앱 완전 종료 후 재실행

## Phase 4: System Settings Baseline

권장값:

- iCloud Drive의 데스크탑/문서 동기화는 업무 초심자에게 혼란을 만들 수 있으므로 기본 해제 권장
- 날짜/시간은 24시간제 권장
- Dock 자동 숨기기 권장
- 잠금/절전 시간은 업무 패턴에 맞춰 조정
- 손쉬운 사용의 확대/축소, 스크롤 방향은 사용자 선호 확인

주의:
- Apple ID/iCloud 데이터 자체를 건드리지 않는다.
- iCloud 동기화 변경은 데이터 위치에 영향을 줄 수 있으므로 화면을 보여주며 설명하고 진행한다.

## Phase 5: Windows-Like Comfort

권장 기본:
- WinMacKey: Windows식 키감 유지
- Rectangle: 창 분할 관리
- Karabiner-Elements: 고급 키 리매핑이 필요한 경우에만
- Hammerspoon: 자동화 고급 사용자에게만

권한:
- WinMacKey/Rectangle류는 손쉬운 사용 권한이 필요할 수 있다.
- 키보드 후킹류는 입력 모니터링 권한이 필요할 수 있다.

초기 테스트:
- 한영 전환
- 복사/붙여넣기
- 창 좌우 분할
- 원격/VDI 환경에서 단축키 충돌 여부

## Phase 6: Workspace Folder

```bash
mkdir -p ~/worksapces/{api-server,frontend-web,infra-tools,data-pipeline,shared-lib}
mkdir -p ~/.claude/workspace
```

Finder로 열기:

```bash
open ~/worksapces
open ~/.claude/workspace
```

숨김 폴더 설명:
- 점(`.`)으로 시작하는 폴더는 Finder에서 기본으로 안 보인다.
- `Command + Shift + .` 로 숨김 파일 표시를 토글한다.

## Phase 7: Tailscale

최소 이해:
- Tailscale은 안전한 사설 네트워크 연결 도구다.
- 설치보다 로그인/상태 확인이 중요하다.
- 본인/조직 정책에 따라 계정/기기명이 정해질 수 있다.

검증:

```bash
tailscale status
```

안 되면 확인:
- 앱이 실행 중인지
- 로그인했는지
- 회사/팀 계정이 맞는지
- 네트워크가 막혀 있지 않은지

## Phase 8: Productivity Apps

추천 앱:

- Raycast: Spotlight 대체, 앱 실행/검색
- RunCat: 메뉴바 시스템 모니터
- Chrome: 웹 업무 기본 브라우저
- Telegram: 본인/조직 정책상 필요할 때만
- Rectangle: 창 분할
- WinMacKey: Windows식 키감

검증 예시:

```bash
open -a "Raycast" || true
open -a "RunCat" || true
open -a "Google Chrome" || true
open -a "Rectangle" || true
```

## Phase 9: Homebrew + Python 3.11 + Node + Git

기준점:
- Homebrew: 설치 시점 최신판
- Python: 3.11 기준. macOS 시스템 Python은 건드리지 않는다.
- Node.js/npm: 설치 시점 최신 안정판. npm은 Node와 함께 제공되는 버전을 우선 사용한다.
- Git/jq/ripgrep/fd/tree/wget: Homebrew 최신 formula 기준

Homebrew 설치 후:

```bash
brew --version
brew update
brew install python@3.11 git node jq ripgrep fd tree wget uv pipx
```

Python 3.11 사용자 공간 기준 확인:

```bash
python3.11 --version
python3.11 -m pip --version

# 선택: pipx가 Python 3.11 기반으로 동작하는지 확인
pipx --version
uv --version
```

주의:
- `/usr/bin/python3`를 지우거나 교체하지 않는다. macOS 시스템 Python은 그대로 둔다.
- `python` 명령을 억지로 3.11에 연결하지 않는다. 초심자 장비에서는 `python3.11`을 명시해서 혼란을 줄인다.
- 프로젝트별 가상환경은 `python3.11 -m venv .venv` 또는 `uv venv --python 3.11` 중 하나로 만든다.
- Node는 기본적으로 `brew install node`의 최신 안정판을 쓴다. 특정 프로젝트가 Node LTS/구버전을 요구할 때만 `nvm`/`fnm`을 추가 검토한다.

검증:

```bash
python3.11 --version
python3.11 -m pip --version
git --version
node --version
npm --version
jq --version
rg --version
fd --version
uv --version
pipx --version
```

Git 기본 설정은 사용자 본인 정보로 한다. 다른 사람의 정보를 복사하지 않는다.

```bash
git config --global user.name "<teammate-name>"
git config --global user.email "<teammate-email>"
git config --global init.defaultBranch main
```

## Phase 10: AI Tools — 바이브 코딩 스택 (클라우드 + 로컬 + 오케스트레이션)

이 스킬의 핵심 대상은 "바이브 코딩" 사용자다. AI 스택은 세 층으로 나눠 설치·검증한다.

### 10-1. 클라우드 AI (CLI + 데스크톱)

```bash
# Claude Code — 바이브 코딩의 중심. 프로젝트 폴더에서 실행
npm install -g @anthropic-ai/claude-code
which claude && claude --version

# Codex CLI
npm install -g @openai/codex
which codex && codex --version

# Gemini CLI — 대용량 컨텍스트(~1M token), 큰 코드베이스 분석
npm install -g @google/gemini-cli
which gemini && gemini --version

# Playwright (브라우저 자동화/테스트)
npx playwright --version
```

- Claude Desktop(cask)은 MCP 서버 + 로컬 파일 접근으로 데스크톱 오케스트레이션 거점.
- Gemini CLI / OpenClaw 는 본인/조직 정책 및 토큰 비용 정책 확인 후 선택.

### 10-2. 로컬 LLM (MLX / Ollama / LM Studio)

오프라인·프라이버시·비용 절감 작업은 로컬 모델로. Apple Silicon 의 MLX 가 가장 빠르다.

```bash
# Ollama — 가장 쉬운 로컬 LLM 런타임
ollama --version
ollama run qwen2.5-coder      # 코딩용 로컬 모델
ollama run llama3.2           # 범용

# MLX (Apple Silicon 전용) — bootstrap 이 ~/worksapces/mlx-lab venv 에 설치
~/worksapces/mlx-lab/.venv/bin/python -m mlx_lm.generate \
  --model mlx-community/Llama-3.2-3B-Instruct-4bit --prompt "hello"

# MLX 로컬 OpenAI 호환 서버 (다른 도구에서 endpoint 로 사용)
~/worksapces/mlx-lab/.venv/bin/python -m mlx_lm.server --model <mlx-model>
```

- LM Studio(cask)는 GUI 로 모델 탐색/다운로드 + OpenAI 호환 서버를 띄울 수 있다 (초보자 친화).
- 로컬 모델은 용량이 크므로 첫 다운로드는 사용자가 직접 트리거한다 (자동화하지 않음).

### 10-3. 오케스트레이션

여러 모델/도구를 묶어 쓰는 전략을 사용자가 이해하게 한다.

- Claude Code 의 subagent + MCP 서버가 오케스트레이션 거점.
- 라우팅 기본값: 빠른/민감/오프라인 작업 → 로컬(MLX/Ollama), 복잡한 추론/대규모 컨텍스트 → 클라우드(Claude/Gemini).
- 로컬 OpenAI 호환 서버(MLX server / Ollama / LM Studio)를 endpoint 로 등록하면 같은 코드에서 로컬↔클라우드 전환 가능.
- OpenClaw 같은 멀티-provider 게이트웨이를 쓸 경우 provider/비용 정책을 먼저 확인한다.

### 원칙
- 사용자 개인 계정으로 로그인한다. 비밀번호가 필요한 단계는 사용자가 직접 입력한다.
- 다른 시스템의 설정 파일/토큰을 복사하지 않는다.
- AI 도구는 설치 후 샘플 실행(클라우드는 `--version`/간단 호출, 로컬은 짧은 generate)까지 확인한다.
- 로컬 모델 대용량 다운로드는 사용자 트리거. bootstrap 은 런타임/venv 만 준비한다.

## Phase 11: Verification Checklist

시스템:

```bash
sw_vers
uname -m
whoami
echo $SHELL
```

폴더:

```bash
[ -d ~/worksapces ] && echo "worksapces ok"
[ -d ~/.claude/workspace ] && echo "claude workspace ok"
```

도구:

```bash
brew --version || true
python3.11 --version || true
python3.11 -m pip --version || true
git --version || true
node --version || true
npm --version || true
jq --version || true
rg --version || true
fd --version || true
uv --version || true
pipx --version || true
tailscale status || true
claude --version || true
codex --version || true
npx playwright --version || true
```

사용자 체감 확인:
- [ ] Finder에서 `~/worksapces`를 찾을 수 있다
- [ ] 숨김 파일 표시를 토글할 수 있다
- [ ] DMG 설치 흐름을 이해한다
- [ ] 권한 허용 후 앱 재실행을 이해한다
- [ ] Command/Option/Control 차이를 대략 이해한다
- [ ] Quick Look과 스크린샷을 사용할 수 있다
- [ ] Tailscale 상태를 확인할 수 있다
- [ ] Python 3.11/Git/Node/npm 버전을 확인할 수 있다
- [ ] Claude/Codex 등 AI 도구를 실행할 수 있다
- [ ] 개인 데이터/비밀번호/토큰/개인 노트가 복사되지 않았다

## Deliverables

완료 산출물:

```text
1. 사용자용 Mac Quick Start 문서
2. 설치/설정 요약
3. 변경한 설정 파일 목록
4. 백업 위치
5. 설치된 도구 버전 표
6. 앱별 남은 수동 로그인 항목
7. 제외한 항목: 개인 Vault, Bitwarden/비밀번호 데이터, 토큰, 메시지 계정, 회사 비공개 자료
8. 초심자 FAQ / 자주 막히는 상황
9. 다음 자동화 후보
```

## Teammate Quick Start Template

```markdown
# Mac Soft-Landing Quick Start

## 1. 처음 15분
- 작업 폴더: `~/worksapces`
- Finder: 컬럼 보기, 경로 막대, 상태 막대, 확장자 표시
- 설치: DMG는 Applications로 드래그
- 권한: 시스템 설정에서 허용 후 앱 재실행
- 버전 기준: 일반 앱/Node.js/Git은 설치 시점 최신 안정판, Python은 3.11
- Tailscale: 설치보다 `tailscale status` 확인

## 2. 꼭 익힐 단축키
- 앱 종료: `Command + Q`
- 복사/붙여넣기: `Command + C/V`
- 앱 검색: `Command + Space` 또는 Raycast
- Quick Look: 파일 선택 후 Space
- 스크린샷: `Command + Shift + 4`
- 숨김 파일 보기: `Command + Shift + .`

## 3. 작업 위치
- 코드/프로젝트: `~/worksapces/`
- AI 작업 공간: `~/.claude/workspace/`
- 설치 파일 임시 위치: `~/Downloads/`

## 4. 개발도구 기준
- Python: `python3.11` 명령을 기준으로 사용
- Node.js/npm: Homebrew 최신 안정판 기준
- Git/Homebrew 도구: 설치 시점 최신판 기준
- 버전 확인: `python3.11 --version`, `node --version`, `npm --version`, `git --version`

## 5. 보안 원칙
- 개인 비밀번호 관리자/토큰/개인 노트는 복사하지 않습니다.
- 회사 자료는 승인된 경로에서만 다룹니다.
- 비밀번호가 필요한 로그인은 본인이 직접 입력합니다.

## 6. 문제가 생기면
- 어떤 앱에서 막혔는지
- 어떤 권한 화면인지
- 어떤 명령어를 실행했는지
- 에러 메시지 전체
를 기록해서 공유하세요.
```

## Common Pitfalls

1. 맥 초심자에게 개발도구부터 설치함
   - 먼저 Finder, Dock, 단축키, 설치/권한 흐름을 익힌다.

2. 개인 Vault/Bitwarden/토큰을 세팅에 포함함
   - 제외한다. 사용자가 직접 로그인해야 하는 영역이다.

3. iCloud Desktop/Documents 동기화를 방치함
   - 파일 위치 혼란이 생길 수 있다. 초기에 설명하고 기본 해제를 권장한다.

4. 권한 허용 후 앱 재실행을 안 함
   - 손쉬운 사용/입력 모니터링 권한은 재실행해야 반영되는 경우가 많다.

5. `worksapces` 오타를 마음대로 고침
   - 팀 문서 기준 경로라면 유지한다.

6. 앱 설치만 하고 검증하지 않음
   - `open -a`, `which`, `--version`, `tailscale status`를 확인한다.

7. 숨김 폴더를 설명하지 않음
   - `.claude/workspace`가 안 보인다고 바로 막힌다.

8. 외부 push/자동 메시지/이메일 같은 side effect를 자동화함
   - 초심자 온보딩 범위에서는 금지한다.

## Final Response Pattern

```text
Mac 소프트랜딩 기준으로 반영했습니다.

변경:
- 초심자용 macOS/Finder/설치/권한 흐름 추가
- 작업 폴더: ...
- 설치 도구: ...
- 설정 파일: ...
- 백업: ...

확인 완료:
- Finder/폴더: OK
- Tailscale: OK 또는 로그인 필요
- brew/git/node/npm: OK
- Claude/Codex/AI 도구: OK 또는 수동 로그인 필요

제외:
- 개인 Vault/Obsidian 원본
- Bitwarden/비밀번호/토큰
- 메시지 계정/개인 계정 세션
- 회사 비공개 자료 무단 복사

남은 수동 작업:
- ...
```
