# 맥을 처음 받았어요 — 따라만 하면 작업 준비 끝

> 윈도우만 쓰던 사람도, 터미널이 처음인 사람도 그대로 따라올 수 있게 적었습니다.
> **명령을 외울 필요 없습니다.** 중간(3단계)부터는 AI(Claude Code)가 당신을 도와줍니다.

소요 시간: 약 30~60분 (대부분 설치 대기 시간)

---

## 큰 그림 — 딱 3단계

```
1. 터미널 확보   →  Ghostty         "명령을 칠 창"
2. AI 조수 확보  →  Claude Code     "이제 명령을 외울 필요가 없다"
3. 나머지는 AI   →  이 스킬 호출     앱·설정·권한을 Claude Code 가 함께 진행
```

핵심: **2단계까지만 손으로 하면 됩니다.** 그다음부터는 `claude` 에게 한국어로 말하면 됩니다.

---

## 0단계. 맥을 켜기 전 점검 (5분)

처음 부팅하면 설정 마법사가 안내합니다. 아래만 확인하세요.

- [ ] **인터넷 연결** — Wi-Fi 또는 랜선. (회사면 사내 Wi-Fi)
- [ ] **Apple ID 로그인** — 없으면 만들면 됩니다. App Store 앱 설치에 필요.
- [ ] **관리자 계정인지** — 소프트웨어 설치 권한이 있어야 합니다. (보통 첫 계정이 관리자)
- [ ] **(회사 장비라면)** 설치 가능한 앱/보안 정책을 담당자에게 한 번 확인.

> 💡 비밀번호는 메모해 두세요. 설치 중 몇 번 물어봅니다.

---

## 1단계. 맥 기본기 — 윈도우와 다른 점 (10분, 꼭 읽기)

| 윈도우 | 맥 | 비고 |
|---|---|---|
| `Ctrl` | `⌘`(Command) | 복사 `⌘C`, 붙여넣기 `⌘V`, 전체선택 `⌘A` |
| `Alt` | `⌥`(Option) | |
| 창 X(닫기) = 프로그램 종료 | **창 닫기 ≠ 종료** | 앱 완전 종료는 `⌘Q` |
| 파일 탐색기 | **Finder** | Dock 맨 왼쪽 웃는 얼굴 |
| 시작 메뉴 | **Spotlight** `⌘Space` | 앱 이름 입력 → Enter 로 실행 |
| 오른쪽 클릭 | 트랙패드 **두 손가락 탭** / 마우스 우클릭 | |
| `PrtSc` | `⌘⇧4`(영역) / `⌘⇧3`(전체) | 캡처는 Downloads 에 저장됨 |
| 미리보기 | 파일 선택 후 **Space** (Quick Look) | |
| `Alt+Tab` | `⌘Tab` | (AltTab 앱 깔면 윈도우처럼 "창 단위") |
| 한/영 | **Caps Lock** 또는 🌐(지구본) 키 | |

- **숨김 파일 보기**: Finder 에서 `⌘⇧.`(마침표). 다시 누르면 숨김.
- **앱 설치**: `.dmg` 파일을 열고 → 앱 아이콘을 **Applications 폴더로 드래그**.

---

## 2단계. 터미널이 뭔가요? (3분)

- **"명령을 글자로 입력하는 창"** 입니다. 무서워할 것 없습니다.
- 우리는 명령을 **복사해서 붙여넣기**만 할 거예요:
  1. 이 문서에서 명령을 복사 (`⌘C`)
  2. 터미널 창을 클릭하고 붙여넣기 (`⌘V`)
  3. `Enter`
- ⚠️ **비밀번호를 입력할 때 화면에 아무것도 안 보이는 게 정상입니다** (보안). 그냥 타이핑하고 `Enter`.

---

## 3단계. 최소 설치 — Claude Code 까지 (자동, 10~20분)

여기서 딱 두 가지를 깝니다: **터미널(Ghostty) + AI 조수(Claude Code)**.

### 3-1. 이 저장소 받기

**방법 A — ZIP (가장 쉬움, git 불필요)**

1. 이 프로젝트의 GitHub 페이지에서 초록색 **`Code`** 버튼 → **`Download ZIP`**.
2. `다운로드` 폴더의 ZIP 파일을 더블클릭해 압축을 풉니다.
3. 폴더 이름을 기억하세요 (보통 `macbook-teammate-softlanding-main`).

**방법 B — git clone (터미널에 익숙하면)**

기본 터미널을 먼저 엽니다: `⌘Space` → `터미널` 입력 → `Enter`. 그리고:

```bash
cd ~/Downloads
git clone https://github.com/<OWNER>/macbook-teammate-softlanding.git
```

> `<OWNER>` 는 GitHub 페이지 주소의 사용자/조직 이름입니다. 초록색 `Code` 버튼 → `HTTPS` 의 URL 을 그대로 복사해 쓰면 됩니다.
> 처음이라 `git` 이 없다고 뜨면, 화면에 나타나는 **"설치"** 창에서 설치를 누르고 몇 분 기다린 뒤 다시 실행하세요.

### 3-2. 최소 부트스트랩 실행

기본 터미널(`⌘Space` → `터미널`)에서, 위에서 받은 폴더로 이동한 뒤 실행합니다.

```bash
# ZIP 으로 받았다면 (폴더명이 -main 으로 끝남)
cd ~/Downloads/macbook-teammate-softlanding-main

# git clone 으로 받았다면
# cd ~/Downloads/macbook-teammate-softlanding

bash softlanding/bootstrap-min.sh
```

이 스크립트가 순서대로 합니다 (중간에 **관리자 비밀번호**를 물어볼 수 있음 — 화면에 안 보여도 정상):

1. Xcode Command Line Tools (개발 기본 도구)
2. Homebrew (맥용 설치 관리자)
3. **Ghostty**(터미널) + node
4. Ghostty 기본 설정 파일
5. **Claude Code**

끝나면 화면에 *"Ghostty 를 열고 `claude` 를 실행하세요"* 안내가 뜹니다.

---

## 4단계. Ghostty 열고 Claude Code 로그인 (5분)

1. `⌘Space` → **`ghostty`** 입력 → `Enter`. (이제부터 기본 터미널 대신 이걸 씁니다.)
   - 처음 열 때 **"확인되지 않은 개발자"** 또는 **"인터넷에서 다운로드"** 경고가 뜨면:
     - 앱 아이콘을 **우클릭 → 열기**, 또는
     - **시스템 설정 → 개인정보 보호 및 보안** → 맨 아래 *"확인 없이 열기"*.
2. Ghostty 창에서 입력:

   ```bash
   claude
   ```

3. 브라우저가 열리며 로그인 화면이 나옵니다. 안내대로 로그인하세요.

✅ 여기까지 오면 **AI 조수가 준비된 상태**입니다.

---

## 5단계. 나머지는 AI 에게 맡기기 (스킬 주도)

`claude` 가 실행된 상태에서, 다음 중 하나를 입력하세요.

```text
/macbook-teammate-softlanding
```

또는 그냥 한국어로:

```text
맥북 소프트랜딩 진행해줘
```

그러면 Claude Code 가 **나머지를 설명하면서** 진행합니다:

- 업무용 앱 30개 설치 (또는 전체 설치 스크립트 실행 안내)
- Finder/Dock/스크린샷 등 기본값 정리
- **권한 켜는 법을 화면 위치까지** 알려줌

> 한 번에 전부 깔고 싶다면 (대화 없이), 위 폴더에서 직접:
> ```bash
> GIT_NAME="본인이름" GIT_EMAIL="본인메일@example.com" bash softlanding/bootstrap.sh
> ```

> 🔧 **WinMacKey(윈도우식 키감)는 선택입니다.** 자동 설치하려면 릴리스 저장소를 함께 지정하세요
> (지정 안 하면 그냥 건너뜁니다):
> ```bash
> WINMACKEY_REPO="<owner>/<repo>" GIT_NAME="본인이름" GIT_EMAIL="본인메일@example.com" bash softlanding/bootstrap.sh
> ```

---

## 6단계. 손으로만 되는 것 (macOS 보안 — AI 도 대신 못 함)

macOS 는 보안상 아래를 **사용자가 직접** 켜야 합니다. 페이지를 한 번에 열어주는 도우미가 있습니다.

```bash
bash softlanding/prompts/permissions-open.sh
```

순서대로 뜨는 화면에서 스위치를 **ON** 하세요.

- **접근성(손쉬운 사용)** — Rectangle, WinMacKey, AltTab, Maccy, Stats 등
- **입력 모니터링** — WinMacKey 같은 키보드 앱
- **자동화 / 로그인 항목**
- ⚠️ **권한을 켠 뒤에는 그 앱을 `⌘Q` 로 완전히 끄고 다시 실행**해야 적용됩니다.

추가로(필요한 경우):

- **Tailscale**(사내망): 메뉴바 아이콘 → `Log in` → 회사 계정 → 관리자 승인
- **iCloud Drive 데스크탑/문서 동기화**: 파일 위치 혼란 방지를 위해 **끄기 권장**
- **각 AI 도구 로그인** (Claude / Codex / Gemini)

---

## 7단계. 잘 됐는지 확인

```bash
bash softlanding/verify.sh
```

- **초록 `OK`** 위주면 성공입니다.
- 노랑 `WARN` 은 "아직 안 깔았거나 로그인 안 한 항목" — 대부분 정상입니다.
- 빨강 `FAIL` 이 있으면 그 줄을 보고 부트스트랩을 다시 돌리면 됩니다 (여러 번 돌려도 안전).

각 앱 첫 5분 사용법 → [`softlanding/apps-usage.md`](softlanding/apps-usage.md)
윈도우 → 맥 헷갈리는 12가지 → [`softlanding/windows-to-mac-survival.md`](softlanding/windows-to-mac-survival.md)

---

## 막혔을 때 (자주 묻는 것)

| 증상 | 해결 |
|---|---|
| `command not found: git` | Xcode CLT 설치가 안 끝남. "설치" 창 완료 후 다시. (또는 ZIP 방법 사용) |
| **"확인되지 않은 개발자"** 경고 | 앱 우클릭 → 열기, 또는 설정 → 개인정보 보호 및 보안 → "확인 없이 열기" |
| 비밀번호 쳐도 화면에 안 보임 | **정상입니다.** 그냥 타이핑하고 `Enter` |
| `brew` 명령을 못 찾음 | 터미널 창을 **새로 열고** 다시 (PATH 반영) |
| `claude` 가 없다고 함 | `bash softlanding/bootstrap-min.sh` 다시, 또는 `npm install -g @anthropic-ai/claude-code` |
| 권한 줬는데 앱이 안 먹음 | 그 앱을 `⌘Q` 로 끄고 다시 실행 |
| 한/영 전환이 안 됨 | `Caps Lock` 또는 🌐 키. WinMacKey 설정에서도 조정 가능 |
| 설치가 중간에 멈춤 | 인터넷/사내 방화벽 확인 후 같은 명령 재실행 (멱등 — 여러 번 OK) |

---

## 안전 / 개인정보 (안심하세요)

- 이 과정은 **비파괴**입니다. 기존 설정 파일은 **백업한 뒤에만** 손댑니다 (예: Ghostty 설정이 이미 있으면 `.bak` 로 보관).
- **비밀번호·토큰·개인 계정**은 당신이 직접 로그인합니다. 어디서도 복사하지 않습니다.
- 개인 메모/패스워드 매니저/메신저 계정은 설치 범위에 **포함하지 않습니다.**

---

준비 끝! 이제부터 막히는 건 **Ghostty 에서 `claude` 에게 물어보세요.** 그게 이 스킬의 핵심입니다.
