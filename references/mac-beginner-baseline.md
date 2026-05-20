# Mac Beginner Baseline Notes

Session-derived guidance for `macbook-teammate-softlanding`.

## User Corrections Captured

- This is for teammates who may be touching a Mac for the first time, not for cloning the operator's personal system.
- Personal assets must be excluded by default:
  - Operator's personal Vault / Obsidian vault contents
  - Bitwarden / 1Password / browser-saved passwords
  - passkeys, OTP, SSH private keys
  - personal tokens, OAuth sessions, messaging accounts, personal mail/calendar
- The companion HTML guide is the local shape reference for the beginner flow.
- Required baseline philosophy:
  - General apps and CLIs: install the current/latest stable version at setup time.
  - Node.js/npm: latest stable via Homebrew by default; only add nvm/fnm if a project specifically requires version pinning.
  - Python: use Python 3.11 as the explicit baseline.
  - Do not replace or mutate macOS system Python; use `python3.11` explicitly.

## Beginner Flow to Preserve

1. First 15 minutes: workspace path, Finder basics, installation/permission flow, Tailscale status.
2. macOS basics before developer tooling: Command/Option/Control, Dock, menu bar, Finder, Quick Look, screenshots.
3. App installation concepts: DMG to Applications, pkg installer, zip extraction, Gatekeeper warnings.
4. Permissions: Accessibility, Input Monitoring, Automation, Login Items, Full Disk Access; restart apps after granting permissions.
5. Team workspace: `/Users/<account>/worksapces` and `~/.claude/workspace`.
6. Productivity tools: Raycast, RunCat, Chrome, Rectangle, WinMacKey; Tailscale if team networking requires it.
7. Developer baseline: Homebrew latest, Python 3.11, Node latest stable, Git and CLI utilities.
8. AI tools only after basics: Claude Desktop/Code, Codex, OpenClaw, Playwright; user enters credentials directly.
9. Verification-first handoff: record `--version` outputs instead of hard-coding dated exact versions.

## Copyable Baseline Commands

```bash
brew update
brew install python@3.11 git node jq ripgrep fd tree wget uv pipx

python3.11 --version
python3.11 -m pip --version
node --version
npm --version
git --version
uv --version
pipx --version
```

## Pitfall Reminder

If future sessions drift toward Obsidian/Vault replication, password-manager setup, or personal account transfer, stop and reframe: this skill is a Mac beginner onboarding baseline, not a personal-system clone.
