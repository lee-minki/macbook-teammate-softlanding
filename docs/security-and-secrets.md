# 보안 · 시크릿 · 개인정보 원칙

이 스킬은 **남의 시스템을 복제하지 않고**, 새 맥을 작업 가능한 베이스라인으로 올리는 것만 한다. 아래는 설계상 강제되는 경계다.

## 절대 포함하지 않는 것 (Hard Exclusions)

- 개인 Vault / Obsidian 원본 / 개인 노트
- 비밀번호 관리자(1Password·Bitwarden), 브라우저 저장 비밀번호, 패스키, OTP, SSH private key
- 개인 API 토큰 / OAuth 토큰 / 로그인 세션
- KakaoTalk / Telegram / iMessage / 개인 메일·캘린더 계정
- 회사 비공개 코드·문서·인증서·접속정보의 무단 복사
- 자동 메시지 전송·이메일 발송·외부 push 같은 side effect 자동화
- 사용자가 이해하지 못한 상태의 dotfile 대량 복사

비밀번호 관리자는 "사용자 본인이 설치/로그인하는 개인 보안 도구"로만 언급한다.

## 시크릿은 사용자 손에

- 모든 계정 로그인(Apple ID, Tailscale OAuth, Claude/Codex/Gemini/Hermes/OpenCode 등)은 **사용자가 직접** 입력한다.
- 스크립트·문서·저장소 어디에도 자격증명/토큰/키를 박지 않는다.
- 관리자 비밀번호가 필요한 단계(Homebrew, pmset)는 사용자가 직접 입력하며, 화면에 표시되지 않는 것이 정상이다.

## 다운로드 신뢰 경계

- 모든 다운로드는 HTTPS.
- **Homebrew 설치**: 공식 `raw.githubusercontent.com/Homebrew/install/HEAD/install.sh` 를 그대로 실행한다(업계 표준). 신뢰 경계를 사용자에게 고지한다.
- **WinMacKey**(선택, `WINMACKEY_REPO` 지정 시): **DMG 를 자동 다운로드·설치하지 않는다.** GitHub 릴리스 페이지를 참조·안내하고 새 버전이 있으면 알릴 뿐이며, 설치/업데이트는 사용자가 릴리스에서 직접 받아 한다(macOS Gatekeeper 가 공증을 확인). 신뢰 경계를 스크립트 밖(사용자 판단)에 둔다.
- **npm 글로벌 / VS Code 확장**: 공식 레지스트리/마켓플레이스만 사용. 설치 시점 최신 안정판을 추적한다(버전 고정 안 함 — 의도된 정책).

## 비파괴 원칙

- 기존 설정 파일(`.zprofile`, `~/.config/ghostty/config` 등)은 **백업 후에만** 손대고, 가능한 한 marker/append 만 한다.
- `defaults write` 는 되돌릴 수 있는 사용자 환경설정만 변경한다.
