# MacBook Soft-Landing 운영 매뉴얼

## 목적

이 매뉴얼은 `macbook-teammate-softlanding` 스킬을 실제 온보딩에 사용할 때 따라가는 운영 절차다. 대상은 Mac을 처음 쓰면서 바이브 코딩(AI 보조 개발)을 시작하려는 사용자다. 목표는 사용자가 겁먹지 않고 Finder, 앱 설치, 권한 허용, 작업 폴더, Tailscale, 개발도구, 그리고 클라우드 AI + 로컬 MLX LLM + 오케스트레이션 도구를 직접 확인할 수 있게 만드는 것이다.

## 절대 제외 항목

온보딩 범위에 넣지 않는다.

- 개인 Vault / Obsidian 원본 / 개인 노트
- Bitwarden / 1Password / 브라우저 저장 비밀번호 / 패스키 / OTP
- 개인 API token / OAuth token / 로그인 세션
- KakaoTalk / Telegram / iMessage / 개인 메일 / 개인 캘린더
- SSH private key
- 회사 비공개 코드·문서·인증서·접속정보의 무단 복사
- 자동 메시지 전송, 이메일 발송, 외부 push 자동화

## 기준 버전 정책

| 항목 | 기준 |
|---|---|
| macOS | 지급 장비 현재 버전 기준. OS 업그레이드는 별도 승인 후 진행 |
| Homebrew | 설치 시점 최신판 |
| Python | 3.11 기준. `python3.11` 명령을 명시 사용 |
| Node.js | Homebrew 최신 안정판 |
| npm | Node와 함께 설치되는 bundled 버전 |
| Git/jq/rg/fd/tree/wget | Homebrew 최신 formula |
| Raycast/RunCat/Chrome/Rectangle/Tailscale | 설치 시점 최신 안정판 |
| Claude/Codex/OpenClaw/Playwright | 설치 시점 최신 안정판, 팀 계정/정책 기준 |

원칙:
- `/usr/bin/python3`는 건드리지 않는다.
- `python` alias를 억지로 바꾸지 않는다.
- 버전 숫자를 문서에 박제하지 말고 설치 후 `--version` 결과를 기록한다.

## 진행 순서 요약

**Phase 0 (Auto):** `softlanding/bootstrap.sh` 한 번으로 1·7·9·10·11 의 설치 부분이 끝난다. 사용자는 권한 ON 과 로그인만 한다.

수동 절차 (자동 실패 시 fallback 또는 자동 안 도는 환경):

1. 시작 전 체크
2. 처음 15분 빠른 적응
3. Finder / 단축키 / Dock / 시스템 설정
4. 앱 설치 방식과 권한 허용
5. 시스템 설정 기준값
6. Windows식 키보드/창관리 편의
7. 작업 폴더 생성
8. Tailscale
9. 생산성 앱
10. Homebrew + Python 3.11 + Node + Git
11. AI 도구
12. 최종 검증과 인계

## 0. Phase 0 — 딸깍 자동 설치 (v1.3.0)

```bash
cd ~/Downloads/softlanding
GIT_NAME="홍길동" GIT_EMAIL="hong@company.com" bash bootstrap.sh
bash verify.sh
bash prompts/permissions-open.sh
```

자동 처리:
- Xcode CLT → Homebrew → 27개 앱/CLI(brew bundle) → mas 2개(Amphetamine, Hidden Bar) → WinMacKey DMG
- 폴더 구조, Finder/Dock/스크롤/다크모드/캡처 defaults
- Python 3.11 + uv + pipx
- Git 설정 (환경변수)
- AI CLI(npm globals): Claude Code, Codex, Gemini — **node 가 없으면 자동 재설치, 그래도 없으면 명시 fail**

수동 단계 (자동화 불가, prompts/permissions-open.sh 안내):
- 접근성/입력 모니터링/자동화 권한 토글
- Tailscale OAuth 로그인 + 관리자 승인
- iCloud Drive 데스크탑/문서 동기화 해제
- 각 AI 도구 계정 로그인
- WinMacKey/Karabiner 첫 실행 권한

자세한 흐름과 의존성 체인은 SKILL.md 의 "Automation Boundary" 섹션 참조.

## 1. 시작 전 체크

터미널에서 확인한다.

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

질문/확인:
- Apple ID 로그인 여부
- 관리자 권한 여부
- 계정명과 컴퓨터 이름
- 인터넷/사내망/VPN/Tailscale 필요 여부
- 회사 보안 정책상 설치 가능한 앱
- Claude/OpenAI 등 사용자가 직접 로그인 가능한 계정 여부

## 2. 처음 15분 빠른 적응

처음에는 개발도구보다 “맥을 어디서 어떻게 만지는지”부터 잡는다.

사용자에게 직접 보여준다.

- Finder 열기
- `~/worksapces` 폴더 위치
- Downloads 폴더
- Applications 폴더
- Dock과 메뉴 막대
- 시스템 설정 검색
- Command / Option / Control 차이
- 앱 종료는 `Command + Q`
- Quick Look은 파일 선택 후 Space
- 스크린샷은 `Command + Shift + 4`

## 3. Finder 추천 설정

Finder에서 켜둘 것:

- 컬럼 보기
- 경로 막대 표시
- 상태 막대 표시
- 모든 파일 확장자 보기

숨김 파일:
- `Command + Shift + .` 로 토글
- `.claude/workspace`처럼 점으로 시작하는 폴더가 숨겨진다는 점 설명

## 4. 앱 설치와 권한 허용

설치 방식:

| 형식 | 설명 |
|---|---|
| `.dmg` | 열고 앱 아이콘을 Applications로 드래그 |
| `.pkg` | 설치 마법사 진행 |
| `.zip` | 압축 해제 후 앱/폴더 확인 |
| App Store | 설치/업데이트/삭제가 쉬움 |

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
3. 목록에서 해당 앱 스위치 켜기
4. 관리자 비밀번호 또는 Touch ID 승인
5. 앱을 완전히 종료 후 재실행

## 5. 시스템 설정 기준값

권장:
- iCloud Drive Desktop/Documents 동기화는 초심자 혼란 방지를 위해 기본 해제 권장
- 날짜/시간은 24시간제
- Dock 자동 숨기기
- 잠금/절전 시간은 업무 패턴에 맞게 조정
- 손쉬운 사용 확대/축소는 사용자 선호 확인

주의:
- Apple ID/iCloud 데이터 자체를 임의로 건드리지 않는다.
- iCloud 동기화 변경은 데이터 위치에 영향이 있으므로 화면을 보여주며 설명하고 진행한다.

## 6. Windows식 편의

권장 기본:
- WinMacKey: Windows식 키감 유지
- Rectangle: 창 분할
- Karabiner-Elements: 고급 키 리매핑이 필요할 때만
- Hammerspoon: 고급 자동화 사용자에게만

초기 테스트:
- 한영 전환
- 복사/붙여넣기
- 창 좌우 분할
- 원격/VDI 단축키 충돌 여부

## 7. 작업 폴더 생성

```bash
mkdir -p ~/worksapces/{api-server,frontend-web,infra-tools,data-pipeline,shared-lib}
mkdir -p ~/.claude/workspace
open ~/worksapces
open ~/.claude/workspace
```

설명:
- `worksapces` 오타는 팀 문서 기준 경로라서 유지한다.
- `.claude/workspace`는 숨김 폴더다.
- 코드/프로젝트는 `~/worksapces` 아래에 둔다.
- Downloads는 설치 파일 임시 보관소로만 쓴다.

## 8. Tailscale

검증:

```bash
tailscale status
```

안 되면:
- Tailscale 앱 실행 여부
- 로그인 여부
- 팀/회사 계정 여부
- 네트워크 차단 여부

## 9. 생산성 앱 (v1.3.0 — 윈도우 전환자 표준 확장)

### 윈도우→맥 갭 메우기 (이것만큼은 반드시)
- **AltTab** — ⌘Tab 을 "창 단위" 로 (윈도우 Alt+Tab 그대로). 손쉬운 사용 권한 필요
- **Maccy** — 클립보드 히스토리 (윈도우 Win+V 대체). 손쉬운 사용 권한 필요
- **Rectangle** — 창 분할 (`⌃⌥←`, `⌃⌥→`, `⌃⌥Enter`)
- **The Unarchiver** — rar/7z 압축 해제
- **Mos** — 외부 마우스 부드러운 스크롤 + 방향 반전 (로지텍 사용자 필수)
- **Logi Options+** — 로지텍 마우스/키보드 공식 (버튼 매핑, 제스처)

### 키보드 편의
- **WinMacKey** — Windows 키감 (GitHub Release DMG, 자동 fetch)
- **Karabiner-Elements** — Hyper Key/Leader Key 고급 매핑 (선택)

### 메뉴바
- **Stats** — CPU/RAM/GPU/배터리/네트워크 실시간 (RunCat 상위 호환)
- **Hidden Bar** — 메뉴바 아이콘 정리 (App Store)
- **Amphetamine** — 절전 방지 (App Store, 발표/회의/긴 다운로드)

### 에디터/터미널
- **iTerm2** — 표준 터미널 (분할, 검색, 프로파일)
- **VS Code** — 표준 에디터. `code` 명령 PATH 등록 필요 (`⌘⇧P → Install code command`)
- **Cursor** — AI-native 에디터 (Claude/GPT 통합)

### Spotlight / 브라우저 / 메신저
- **Raycast** — Spotlight 강화. 시스템 Spotlight 단축키 해제 후 `⌘Space` 잡기
- **Google Chrome** — 업무/개인 프로필 분리 권장
- **Telegram Desktop** — 팀 정책상 필요할 때만

검증:

```bash
open -a "AltTab" || true
open -a "Maccy" || true
open -a "Rectangle" || true
open -a "Mos" || true
open -a "Stats" || true
open -a "Amphetamine" || true
open -a "iTerm" || true
open -a "Visual Studio Code" || true
open -a "Cursor" || true
open -a "Raycast" || true
open -a "Google Chrome" || true
```

각 앱의 "왜 깔았나 / 첫 5분 / 권한" 상세는 `softlanding/apps-usage.md` 참조.  
윈도우 사용자가 가장 헷갈리는 12가지는 `softlanding/windows-to-mac-survival.md` 참조.

## 10. Homebrew + Python 3.11 + Node + Git

설치:

```bash
brew --version
brew update
brew install python@3.11 git node jq ripgrep fd tree wget uv pipx
```

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

가상환경 예시:

```bash
mkdir -p ~/worksapces/python-test
cd ~/worksapces/python-test
python3.11 -m venv .venv
source .venv/bin/activate
python --version
deactivate
```

Git 기본 설정:

```bash
git config --global user.name "<teammate-name>"
git config --global user.email "<teammate-email>"
git config --global init.defaultBranch main
```

다른 사람의 이름/이메일을 복사하지 않는다.

## 11. AI 도구

후보:
- Claude Desktop
- Claude Code CLI
- Codex CLI
- OpenClaw CLI
- Playwright CLI

검증 예시:

```bash
npm install -g @anthropic-ai/claude-code
which claude && claude --version

npm install -g @openai/codex
which codex && codex --version

npx playwright --version
```

원칙:
- 사용자 개인/팀 계정으로 로그인한다.
- 다른 시스템의 설정 파일이나 토큰을 복사하지 않는다.
- 비밀번호 입력은 사용자가 직접 한다.
- 설치 후 샘플 실행까지 확인한다.

## 12. 최종 검증표

```bash
sw_vers
uname -m
whoami
echo $SHELL
[ -d ~/worksapces ] && echo "worksapces ok"
[ -d ~/.claude/workspace ] && echo "claude workspace ok"
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

사용자 체감 체크:
- [ ] Finder에서 `~/worksapces`를 찾을 수 있다
- [ ] 숨김 파일 표시를 토글할 수 있다
- [ ] DMG 설치 흐름을 이해한다
- [ ] 권한 허용 후 앱 재실행을 이해한다
- [ ] Command/Option/Control 차이를 대략 이해한다
- [ ] Quick Look과 스크린샷을 사용할 수 있다
- [ ] Tailscale 상태를 확인할 수 있다
- [ ] Python 3.11/Git/Node/npm 버전을 확인할 수 있다
- [ ] Claude/Codex 등 AI 도구를 실행할 수 있다
- [ ] 개인 Vault/Bitwarden/비밀번호/토큰/개인 계정 세션이 복사되지 않았다

## 인계 문서 템플릿

````markdown
# Mac Soft-Landing 인계

## 장비/계정
- 계정명:
- 컴퓨터 이름:
- macOS 버전:
- Apple Silicon 여부:

## 완료한 설정
- [ ] Finder 기본 설정
- [ ] 작업 폴더 생성
- [ ] Tailscale 설치/로그인
- [ ] 생산성 앱 설치
- [ ] Homebrew 설치
- [ ] Python 3.11 설치
- [ ] Node.js/npm 설치
- [ ] Git 설정
- [ ] AI 도구 설치

## 버전 기록
```bash
python3.11 --version
node --version
npm --version
git --version
```

## 남은 수동 작업
- 

## 제외한 항목
- 개인 Vault/Obsidian 원본
- Bitwarden/비밀번호/토큰
- 개인 메시지/메일/캘린더 계정
- 회사 비공개 자료 무단 복사
````

## 트러블슈팅

### 앱이 열리지 않음
- Applications에 들어갔는지 확인
- Gatekeeper 경고면 시스템 설정 → 개인정보 보호 및 보안 확인
- 앱을 우클릭 → 열기로 한 번 실행

### 권한을 줬는데 동작하지 않음
- 앱 완전 종료 후 재실행
- 손쉬운 사용/입력 모니터링 둘 다 필요한지 확인
- 로그인 항목 등록 여부 확인

### python 명령이 이상함
- `python`이 아니라 `python3.11`을 기준으로 확인
- `/usr/bin/python3`는 macOS 시스템 Python이라 건드리지 않음

### node/npm 버전이 안 나옴
- `brew install node` 확인
- 터미널 새로 열기
- `which node`, `which npm` 확인

### Tailscale status가 안 됨
- 앱 실행 여부
- 로그인 여부
- 팀 계정 여부
- 네트워크 차단 여부 확인

## 최종 보고 포맷

```text
Mac 소프트랜딩 완료했습니다.

완료:
- Finder/기초 사용법 안내
- 작업 폴더 생성: ~/worksapces, ~/.claude/workspace
- 필수 앱 설치/확인: ...
- 개발도구 설치/확인: Python 3.11, Node.js, npm, Git, ...
- AI 도구 설치/확인: ...

버전:
- Python: ...
- Node: ...
- npm: ...
- Git: ...

제외:
- 개인 Vault/Bitwarden/토큰/개인 계정 세션은 복사하지 않았습니다.

남은 작업:
- ...
```
