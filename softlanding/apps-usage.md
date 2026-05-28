# 설치된 앱 첫걸음

bootstrap.sh 가 깔아준 앱들의 **왜 깔았는지 + 첫 5분 사용법 + 권한**.

> 깊은 설정은 안 다룬다. 첫 실행에서 막히지 않게 하는 게 목적.

---

## 🧑‍💻 개발 도구

### Ghostty — 터미널 (`⌘Space → ghostty`)
- **왜?** 초심자가 처음 "명령을 치는 창". GPU 가속으로 빠르고, 설정이 단순한 텍스트 파일 하나
- **순서상 가장 먼저**: 터미널이 있어야 `claude`(Claude Code)를 띄우고, 그다음 이 스킬로 나머지를 진행한다
- 기본 설정 자동 적용: bootstrap 이 `~/.config/ghostty/config` 에 초심자 기본값을 비파괴로 작성(기존 파일은 `.bak` 백업 후 보존)
  - 테마 catppuccin-mocha, 내장 JetBrains Mono 14pt, `macos-option-as-alt`(개발용 ⌥키)
- 핵심 단축키: `⌘T` 새 탭, `⌘D` 세로 분할, `⌘⇧D` 가로 분할, `⌘⇧,` 설정 리로드
- 더 바꾸려면 `~/.config/ghostty/config` 편집 후 `⌘⇧,` 또는 재실행

### Visual Studio Code — 표준 에디터 (`⌘Space → Code`)
- **왜?** 사실상 표준. 거의 모든 언어/프레임워크 지원
- 첫 실행:
  - `⌘⇧P` → "Shell Command: Install 'code' command in PATH" → 터미널에서 `code .` 사용 가능
  - 한글 폰트 깨지면 Settings → Font Family → `"D2Coding", "JetBrains Mono", monospace`
- 추천 확장: Python, ESLint, Prettier, GitLens, Korean Language Pack
- 단축키: `⌘P` 파일 열기, `⌘⇧F` 전체 검색, `⌃\`` 터미널 열기

### Cursor — AI 에디터 (`⌘Space → Cursor`)
- **왜?** VS Code 기반 + Claude/GPT 통합. Tab 자동완성이 강함
- 첫 실행: 로그인 (본인 계정 — 무료 plan 도 충분히 강함)
- VS Code 설정 자동 import 가능
- 핵심 단축키: `⌘K` 인라인 명령, `⌘L` 사이드 채팅

### Homebrew — 패키지 매니저
- 이미 bootstrap 이 설치 완료
- 추가 패키지: `brew install <name>` / `brew install --cask <name>`
- 업데이트: `brew update && brew upgrade`
- 검색: `brew search <name>`

### Git + GitHub CLI (`gh`)
- bootstrap 이 `git config --global user.name/email` 자동 적용
- `gh auth login` 으로 GitHub 인증 한 번
- 이후 `gh repo clone`, `gh pr create`, `gh pr view --web` 등 활용

### Python 3.11 + uv + pipx
- 팀 표준 (Alarm-Checker_Server 결정. 2026-05-12)
- 가상환경: `cd ~/worksapces/myproject && uv venv && source .venv/bin/activate`
- 글로벌 CLI 도구: `pipx install httpie` 같은 식
- ⚠️ `/usr/bin/python3` (시스템) 은 건드리지 말 것. 항상 `python3.11` 명시 호출

---

## 🤖 AI 도구

### Claude Desktop
- `⌘Space → Claude` 또는 `open -a Claude`
- 로그인 후 Settings → Developer → MCP 서버 추가 가능
- 로컬 파일 접근 권한 ON 하면 데스크탑/문서 폴더 등 직접 조작 가능

### Claude Code CLI (`claude`)
- 터미널에서 `claude` 한 번 실행 → 첫 인증 (브라우저 OAuth)
- 프로젝트 폴더에서 실행하면 그 폴더 컨텍스트로 작업
- `/help`, `/config`, `/agents` 등 슬래시 커맨드

### Codex CLI (`codex`)
- OpenAI 계정 필요
- `codex --help` 로 시작

### Gemini CLI (`gemini`)
- Google 계정 필요
- 대용량 컨텍스트(~1M token) 이 강점 — 큰 코드베이스 한 번에 분석

---

## 🖥️ 로컬 LLM (오프라인 / 프라이버시 / 비용 절감)

### Ollama (`ollama`)
- **왜?** 가장 쉬운 로컬 LLM 런타임. 인터넷 없이, 토큰 비용 없이 모델 실행
- 첫 사용:
  ```bash
  ollama run qwen2.5-coder    # 코딩용 (자동 다운로드)
  ollama run llama3.2         # 범용
  ```
- 백그라운드 서버: `ollama serve` (OpenAI 호환 endpoint: `http://localhost:11434`)
- 모델 목록: `ollama list`, 삭제: `ollama rm <model>`

### LM Studio (GUI 로컬 LLM)
- **왜?** 터미널 없이 모델 탐색/다운로드/채팅. 초보자 친화
- 첫 실행: 좌측 검색에서 모델(예: Qwen2.5-Coder 7B) 다운로드 → Chat 탭
- Developer 탭 → Start Server 하면 OpenAI 호환 API 서버 (다른 도구에서 endpoint 로 사용)

### MLX (Apple Silicon 전용, 가장 빠름)
- **왜?** Apple Silicon GPU 를 직접 쓰는 추론 프레임워크. Ollama 보다 빠른 경우 많음
- bootstrap 이 `~/worksapces/mlx-lab/.venv` 에 `mlx`, `mlx-lm` 설치
- 첫 사용:
  ```bash
  cd ~/worksapces/mlx-lab
  .venv/bin/python -m mlx_lm.generate \
    --model mlx-community/Llama-3.2-3B-Instruct-4bit --prompt "안녕"
  ```
- OpenAI 호환 서버:
  ```bash
  .venv/bin/python -m mlx_lm.server --model mlx-community/Llama-3.2-3B-Instruct-4bit
  ```
- 모델은 huggingface 의 `mlx-community/` 에서 자동 다운로드 (첫 실행 시 용량 큼)

---

## 🔀 AI 오케스트레이션 (바이브 코딩의 핵심)

- **Claude Code** 가 중심 오케스트레이터 — subagent + MCP 서버로 도구/모델을 묶음
- 라우팅 감각:
  - 빠르고 민감하거나 오프라인 작업 → 로컬 (MLX / Ollama)
  - 복잡한 추론, 대규모 코드베이스 → 클라우드 (Claude / Gemini)
- 로컬 OpenAI 호환 서버(MLX server, Ollama, LM Studio)를 endpoint 로 등록하면 같은 코드에서 로컬↔클라우드 전환
- 처음에는 Claude Code 하나로 시작하고, 비용/속도 이슈가 생기면 로컬 모델을 붙이는 순서를 권장

---

## 🪟 윈도우 갭 메우기

### AltTab — 진짜 Alt+Tab
- **왜?** 맥 기본 ⌘Tab 은 앱 단위만 보여줌
- 권한: 시스템 설정 → 손쉬운 사용 → AltTab ON
- 기본 단축키: `⌥Tab` (또는 설정에서 `⌘Tab` 가로채기)

### Maccy — 클립보드 히스토리
- **왜?** 윈도우 Win+V 대체
- 권한: 시스템 설정 → 손쉬운 사용 → Maccy ON
- 단축키: `⌘⇧C`

### Rectangle — 창 분할
- **왜?** 윈도우 Win+화살표 대체
- 권한: 손쉬운 사용 ON
- 단축키: `⌃⌥←` 왼쪽 절반, `⌃⌥→` 오른쪽 절반, `⌃⌥Enter` 전체

### Mos — 외부 마우스 부드러운 스크롤
- **왜?** 맥 기본은 외부 마우스 스크롤이 뚝뚝 끊김
- 메뉴바 아이콘 → 일반 → 외부 마우스 스크롤 방향 **반전 ON** (윈도우식)

### Logi Options+ — 로지텍 전용
- MX Master, MX Keys 등 로지텍 제품 연결 시 자동 인식
- 버튼 매핑, 제스처, 앱별 프로파일

### The Unarchiver
- **왜?** macOS 기본은 rar/7z 못 풂
- 설정에서 "기본 압축 해제 앱" 으로 지정
- `.zip`, `.rar`, `.7z`, `.tar.gz` 등 다 처리

### WinMacKey
- **왜?** 윈도우 키감 유지 (⌘↔⌃ 스왑 등)
- 첫 실행: 시스템 설정 → 손쉬운 사용 + 입력 모니터링 모두 ON
- 권한 ON 후 **반드시 ⌘Q 후 재실행**
- 기본 프로필이 "윈도우 키감 표준". 그대로 시작하면 됨

### Karabiner-Elements
- **왜?** 고급 키 리매핑 (Hyper Key, Leader Key)
- 권한: 시스템 설정 → 손쉬운 사용 + 입력 모니터링
- 처음에는 안 깔린 것처럼 두고, 필요할 때 windows-to-mac-survival.md 참고

---

## ☕ 시스템 유틸

### Amphetamine — 절전 방지
- 메뉴바 ☕ 아이콘 → Start New Session → 시간 선택
- 트리거: 시간, 앱 실행 중, 다운로드 중, 화면 켜져 있는 동안 등

### Stats — 시스템 모니터
- 메뉴바에 CPU/RAM/GPU/배터리/네트워크 실시간
- 첫 실행: 화면 좌상단의 톱니바퀴 → 각 모듈 ON/OFF 선택

### Hidden Bar — 메뉴바 정리
- 메뉴바 아이콘이 화면 폭 넘어가면 사용
- ⌘ 누르고 드래그로 어떤 아이콘을 숨길지 결정

### Tailscale — 사내망 VPN
- 메뉴바 아이콘 → Log in → 회사 계정 OAuth
- tailnet 관리자가 device 승인하면 즉시 사내 서버 접근 가능
- 터미널: `tailscale status`, `tailscale ip`, `tailscale ping <hostname>`

### Raycast — Spotlight 강화
- 단축키 `⌘Space` (Spotlight 대신 잡으면 충돌 — 시스템 설정에서 Spotlight 단축키 해제 권장)
- 첫 5분: Calendar, Calculator, Window Management, Clipboard History (Maccy 와 중복) 활성화
- Extension 마켓에서 GitHub, Notion, Linear 등 통합 가능

---

## 🌐 브라우저/메신저

### Google Chrome
- 표준 브라우저. 업무용/개인용 **프로필 분리** 권장
- 첫 실행 → 우측 상단 프로필 → 추가 → "업무" 프로필 생성

### Telegram
- 팀 정책상 필요할 때만 로그인
- 알림: 시스템 설정 → 알림 → Telegram → 방해 금지 시간 설정

---

## 권한 한 번에 열기

```bash
bash ~/Downloads/softlanding/prompts/permissions-open.sh
```

이 스크립트가 접근성, 입력 모니터링, 자동화, 로그인 항목, iCloud 페이지를 순차적으로 열어준다.
