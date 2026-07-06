# .config

Minimal, XDG-first dotfiles for zsh, Neovim, Git, Ghostty, Homebrew, and more.

Requires git and zsh. `bootstrap` additionally needs curl and bash (macOS: Xcode CLT).
Ghostty workspace automation is macOS-only.

## Install

```sh
./install.sh install
```

- Links each top-level config directory into `$XDG_CONFIG_HOME`
- Links `$HOME/.zshenv` to the zsh entrypoint
- Links the installer to `$HOME/.local/bin/dotfiles` (the `dotfiles` command)

Conflicting paths are never deleted: they are moved aside as `<path>.backup.<timestamp>`.
Re-running is safe and idempotent.

## Bootstrap

```sh
./install.sh bootstrap
```

Installs links, ensures Homebrew is available, then runs the Brewfile.

## Daily use

```sh
dotfiles status                  # show repo status
dotfiles update                  # safe update; refuses to touch local changes
dotfiles update --discard        # review and discard local changes, then update
dotfiles update --discard --yes  # discard local changes without prompting
dotfiles bundle                  # run the Brewfile
dotfiles doctor                  # show environment status
dotfiles cleanup                 # remove only safe empty legacy home files
dotfiles workspace               # launch the Ghostty coding workspace layout (macOS)
```

`dotfiles code` is an alias for `workspace`.

## Local overrides

Machine-local files are intentionally untracked (see the tracked `*.example` templates). Use:

- `$XDG_CONFIG_HOME/zsh/local.zsh`
- `$XDG_CONFIG_HOME/git/config.d/local`
- `$XDG_CONFIG_HOME/git/config.d/personal`
- `$XDG_CONFIG_HOME/git/config.d/work`
- `$XDG_CONFIG_HOME/homebrew/local.Brewfile`

## Uninstall

```sh
dotfiles uninstall
```

Only symlinks owned by this repo are removed; `*.backup.*` files and created
directories are left in place.

