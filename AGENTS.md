# AGENTS.md

Operating rules for anyone (human or agent) working on this dotfiles repository.

## Core principles

- **Minimal**: prefer consolidated defaults over customization. Every dependency,
  command, file, or option must clearly improve day-to-day workflow or robustness
  over sensible defaults. Never add for the sake of it.
- **XDG-first**: configs live under `$XDG_CONFIG_HOME`; state, cache, and data go
  to their XDG homes. `$HOME` stays nearly empty (only the `.zshenv` symlink).
- **Native-first**: prefer app-native config locations and mechanisms
  (e.g. `vim.pack` and native LSP in nvim, `vcs_info` for the prompt, Ghostty key
  tables, `brew bundle --global`). No frameworks, no plugin managers.
- **Terminal-focused, cross-OS-friendly**: macOS is primary; guard macOS-only
  behavior (`uname -s`, `OS.mac?`, `has("macunix")`) so Linux degrades cleanly.
- **Tidy and explicit**: readable code, descriptive naming, clear structure.
  Avoid clever abstractions, generated config drift, noisy startup behavior,
  and premature file/module splitting.
- **Safe lifecycle**: install/update/uninstall must be safe, idempotent, and
  environment-aware. Conflicting paths are backed up aside, never deleted.
  Uninstall removes only symlinks owned by this repo.

## Repository conventions

- `install.sh` symlinks **every non-hidden top-level directory** into
  `$XDG_CONFIG_HOME`. Consequently:
  - New config domains are added as top-level directories.
  - Documentation and planning live as **root-level files** (`*.md`), which are
    never symlinked.
- Machine-local files are untracked by design (see `.gitignore`): `**/local*`,
  `**/personal`, `**/work`. Each has a tracked `*.example` template next to it.
- Generated runtime files (e.g. opencode's `package.json`/`node_modules`) are
  ignored explicitly in the repo `.gitignore` — never tracked, never relied on
  to ignore themselves.
- Commit style (user-owned; see Agent rules): conventional commits,
  `type(scope): lowercase summary`, scope = domain directory
  (e.g. `chore(zsh): ...`, `fix(ghostty): ...`).

## Parity contracts

Deliberate duplication that must stay behavior-identical across copies:

1. **Vim navigation surface** exists in three places, one per context:
   - `ghostty/vim.ghostty` — native Ghostty key table (any program running)
   - `zsh/ghostty-vicmd-keymaps.zsh` — zsh vicmd bridge (at the shell prompt)
   - `nvim/lua/config/ghostty.lua` — nvim mappings (inside the editor)
   A keymap change lands in all three or none. The vicmd `k`/`j` remap to
   Ghostty scrollback (sacrificing history navigation) is deliberate.
2. **Non-admin cask `--appdir`** logic exists in two places, one per
   invocation path:
   - `zsh/.zprofile` — every interactive/login shell (direct `brew` use)
   - `install.sh` — `bootstrap`/`bundle` from non-login contexts
   Both must keep the same guard against a pre-existing `--appdir` so they
   compose in any order. Casks for non-admin users always install to
   `$HOME/Applications`, never `/Applications`.

## Agent working rules

- **NEVER `git commit`. NEVER `git push`.** The user owns all commits.
- Checkpoint instead: at the start of work and at every phase boundary run
  `git stash push -u -m "checkpoint: <description>"` followed by
  `git stash apply`. The stash list is the revert history.
- Verify before declaring done:
  - `sh -n install.sh` (and `shellcheck install.sh` when available)
  - `zsh -n zsh/.zshrc zsh/.zprofile zsh/.zshenv zsh/*.zsh`
  - `nvim --headless "+lua vim.print('ok')" +q` for nvim config health
  - `git config --file git/config --list` for git config syntax
  - Re-run `./install.sh install` to confirm idempotence when it changed

