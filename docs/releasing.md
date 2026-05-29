# 릴리스 · 버전 규약

버전 문자열이 여러 파일에 흩어져 drift 가 났던 문제를 막기 위한 단일 소스 규칙.

## 버전 단일 소스

- **정본(canonical) = `SKILL.md` frontmatter 의 `version`.**
- 아래 위치는 정본을 **그대로 따라가야** 한다. 버전을 올릴 때 한 번에 같이 바꾼다:
  - `softlanding/bootstrap.sh` 배너 2곳 (`v…` 헤더 + 시작 배너 printf)
  - `softlanding/Brewfile` 헤더
  - `docs/manual.md` Phase 0 제목의 `(v…)`
  - (`bootstrap-min.sh` 는 Stage 0 전용이라 독립 버전 `v1.x` 를 쓴다 — 의도적 분리)

## 올리기 전 체크

```bash
# 흩어진 버전 표기 한눈에 (전부 같은지 확인)
grep -rnE "version: [0-9]|v[0-9]+\.[0-9]+\.[0-9]+" SKILL.md softlanding/bootstrap.sh softlanding/Brewfile docs/manual.md
```

## 릴리스 직전 검수

1. `bash softlanding/verify.sh` — 현재 머신 기준 OK/WARN/FAIL.
2. `bash -n softlanding/*.sh softlanding/prompts/*.sh` — 문법.
3. Brewfile 토큰 실재 확인(설치 없이): `brew info --cask <token>` / `brew info --formula <token>`.
4. 문서 ↔ 스크립트 정합성: 패키지 수, AI CLI 로스터, 단계 수, 옵션 목록이 일치하는지.
5. 배포 중립성: `grep -rn 'lee-minki\|/Users/\|192\.' .` (의도된 repo URL 외 개인 흔적 없는지).

## 버전 의미

- patch (x.y.**z**): 버그/문서 수정, 패키지 추가·교체.
- minor (x.**y**.0): 새 단계/기능(예: Ghostty 전환, 자동전환).
- 숫자를 문서 본문에 과도하게 박지 말고, 설치 직후 `--version` 결과를 인계 문서에 기록한다.
