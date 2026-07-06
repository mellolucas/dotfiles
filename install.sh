#!/bin/sh
# dotfiles-cli: installer and daily driver for this dotfiles repository.
set -eu

invocation_name=${0##*/}
script_path=$0

case "$script_path" in
  */*) ;;
  *) script_path=$(command -v "$script_path") ;;
esac

resolve_path() {
  path=$1
  dir=$(dirname "$path")
  base=$(basename "$path")

  (
    cd -P "$dir" 2>/dev/null
    printf '%s/%s\n' "$PWD" "$base"
  )
}

resolve_script() {
  path=$1

  while [ -L "$path" ]; do
    target=$(readlink "$path")

    case "$target" in
      /*) path=$target ;;
      *) path=$(dirname "$path")/$target ;;
    esac
  done

  resolve_path "$path"
}

script_path=$(resolve_script "$script_path")
repo_dir=$(dirname "$script_path")
installer="$repo_dir/install.sh"

xdg_config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
xdg_data_home="${XDG_DATA_HOME:-$HOME/.local/share}"
xdg_state_home="${XDG_STATE_HOME:-$HOME/.local/state}"
xdg_cache_home="${XDG_CACHE_HOME:-$HOME/.cache}"
user_bin_home="$HOME/.local/bin"

export XDG_CONFIG_HOME="$xdg_config_home"
export XDG_DATA_HOME="$xdg_data_home"
export XDG_STATE_HOME="$xdg_state_home"
export XDG_CACHE_HOME="$xdg_cache_home"

timestamp() {
  date +%Y%m%d%H%M%S
}

backup_path() {
  path=$1
  backup="${path}.backup.$(timestamp)"

  mv "$path" "$backup"
  printf 'backed up %s -> %s\n' "$path" "$backup"
}

link_path() {
  src=$1
  dest=$2

  [ -e "$src" ] || {
    printf 'skip: missing %s\n' "$src"
    return 0
  }

  mkdir -p "$(dirname "$dest")"

  src_real=$(resolve_path "$src")

  if [ -L "$dest" ]; then
    dest_real=$(resolve_script "$dest")

    if [ "$dest_real" = "$src_real" ]; then
      printf 'ok: %s already linked\n' "$dest"
      return 0
    fi

    backup_path "$dest"
  elif [ -e "$dest" ]; then
    dest_real=$(resolve_path "$dest")

    if [ "$dest_real" = "$src_real" ]; then
      printf 'ok: %s already in place\n' "$dest"
      return 0
    fi

    backup_path "$dest"
  fi

  ln -s "$src_real" "$dest"
  printf 'linked %s -> %s\n' "$dest" "$src_real"
}

remove_owned_link() {
  dest=$1
  expected=$2

  [ -L "$dest" ] || {
    printf 'skip: not a symlink: %s\n' "$dest"
    return 0
  }

  dest_real=$(resolve_script "$dest")
  expected_real=$(resolve_path "$expected")

  if [ "$dest_real" = "$expected_real" ]; then
    rm "$dest"
    printf 'removed %s\n' "$dest"
  else
    printf 'skip: not owned by this repo: %s\n' "$dest"
  fi
}

managed_dirs() {
  for src in "$repo_dir"/*; do
    [ -d "$src" ] || continue

    name=${src##*/}

    case "$name" in
      .*) continue ;;
    esac

    printf '%s\n' "$src"
  done
}

brew_bin() {
  if command -v brew >/dev/null 2>&1; then
    command -v brew
    return 0
  fi

  for candidate in \
    /opt/homebrew/bin/brew \
    /usr/local/bin/brew \
    /home/linuxbrew/.linuxbrew/bin/brew
  do
    if [ -x "$candidate" ]; then
      printf '%s\n' "$candidate"
      return 0
    fi
  done

  return 1
}

ensure_macos_command_line_tools() {
  [ "$(uname -s)" = Darwin ] || return 0

  if xcode-select -p >/dev/null 2>&1; then
    return 0
  fi

  printf 'macOS Command Line Tools are missing.\n'
  printf 'Starting installer with: xcode-select --install\n'

  xcode-select --install >/dev/null 2>&1 || true

  printf '\nAfter the installer finishes, rerun:\n'
  printf '  dotfiles bootstrap\n'
  exit 1
}

# Parity contract with zsh/.zprofile (see AGENTS.md): non-admin macOS users
# install casks into $HOME/Applications, never /Applications. This copy covers
# bootstrap/bundle from non-login contexts; .zprofile covers direct brew use.
ensure_homebrew_cask_appdir() {
  [ "$(uname -s)" = Darwin ] || return 0

  if id -Gn | grep -qw admin; then
    return 0
  fi

  mkdir -p "$HOME/Applications"

  case " ${HOMEBREW_CASK_OPTS:-} " in
    *" --appdir="* | *" --appdir "*)
      ;;
    *)
      export HOMEBREW_CASK_OPTS="--appdir=$HOME/Applications${HOMEBREW_CASK_OPTS:+ $HOMEBREW_CASK_OPTS}"
      ;;
  esac
}

ensure_homebrew() {
  if brew_bin >/dev/null 2>&1; then
    printf 'ok: Homebrew already installed\n'
    return 0
  fi

  ensure_macos_command_line_tools

  if ! command -v curl >/dev/null 2>&1; then
    printf 'error: curl is required to install Homebrew\n' >&2
    exit 1
  fi

  if ! command -v bash >/dev/null 2>&1; then
    printf 'error: bash is required to install Homebrew\n' >&2
    exit 1
  fi

  printf 'installing Homebrew...\n'
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

install_dotfiles() {
  mkdir -p \
    "$xdg_config_home" \
    "$xdg_data_home" \
    "$xdg_state_home" \
    "$xdg_cache_home" \
    "$user_bin_home" \
    "$xdg_state_home/zsh" \
    "$xdg_cache_home/zsh"

  managed_dirs | while IFS= read -r src; do
    name=${src##*/}
    link_path "$src" "$xdg_config_home/$name"
  done

  if [ -f "$xdg_config_home/zsh/.zshenv" ]; then
    link_path "$xdg_config_home/zsh/.zshenv" "$HOME/.zshenv"
  else
    printf 'skip: no zsh entrypoint found at %s\n' "$xdg_config_home/zsh/.zshenv"
  fi

  link_path "$installer" "$user_bin_home/dotfiles"

  printf '\ndone.\n'
  printf 'restart your shell or run: exec zsh\n'
}

bundle_dotfiles() {
  brew=$(brew_bin) || {
    printf 'error: Homebrew is not installed. Run: dotfiles bootstrap\n' >&2
    exit 1
  }

  brewfile="$xdg_config_home/homebrew/Brewfile"

  if [ ! -f "$brewfile" ]; then
    printf 'skip: no Brewfile found at %s\n' "$brewfile"
    return 0
  fi

  ensure_homebrew_cask_appdir

  printf 'running brew bundle --file %s\n' "$brewfile"
  "$brew" bundle --file "$brewfile"
}

bootstrap_dotfiles() {
  install_dotfiles
  ensure_homebrew
  bundle_dotfiles

  printf '\nbootstrap complete.\n'
  printf 'restart your terminal, then open Ghostty.\n'
}

doctor_dotfiles() {
  printf 'dotfiles repo: %s\n' "$repo_dir"
  printf 'XDG_CONFIG_HOME: %s\n' "$xdg_config_home"

  printf 'dotfiles command: '
  if command -v dotfiles >/dev/null 2>&1; then
    command -v dotfiles
  else
    printf 'missing\n'
  fi

  printf 'Homebrew: '
  if brew=$(brew_bin 2>/dev/null); then
    printf '%s\n' "$brew"
  else
    printf 'missing\n'
  fi

  printf 'Brewfile: '
  if [ -f "$xdg_config_home/homebrew/Brewfile" ]; then
    printf '%s\n' "$xdg_config_home/homebrew/Brewfile"
  else
    printf 'missing\n'
  fi

  printf 'zsh entrypoint: '
  if [ -L "$HOME/.zshenv" ]; then
    resolve_script "$HOME/.zshenv"
  elif [ -e "$HOME/.zshenv" ]; then
    printf 'exists but is not a symlink\n'
  else
    printf 'missing\n'
  fi

  if [ "$(uname -s)" = Darwin ]; then
    printf 'Xcode CLT: '

    if xcode-select -p >/dev/null 2>&1; then
      xcode-select -p
    else
      printf 'missing; run: xcode-select --install\n'
    fi

    printf 'macOS admin user: '

    if id -Gn | grep -qw admin; then
      printf 'yes\n'
    else
      printf 'no; Homebrew casks will use %s\n' "$HOME/Applications"
    fi
  fi
}

cleanup_dotfiles() {
  printf 'checking for safe home cleanup candidates...\n'

  for path in \
    "$HOME/.zcompdump" \
    "$HOME/.viminfo" \
    "$HOME/.lesshst"
  do
    if [ -f "$path" ]; then
      if [ ! -s "$path" ]; then
        rm "$path"
        printf 'removed empty %s\n' "$path"
      else
        printf 'keep: non-empty %s\n' "$path"
      fi
    fi
  done

  for dir in \
    "$HOME/.vim" \
    "$HOME/.zsh_sessions"
  do
    if [ -d "$dir" ]; then
      if rmdir "$dir" 2>/dev/null; then
        printf 'removed empty %s\n' "$dir"
      else
        printf 'keep: non-empty %s\n' "$dir"
      fi
    fi
  done

  if [ -f "$HOME/.zsh_history" ]; then
    if [ ! -s "$HOME/.zsh_history" ]; then
      rm "$HOME/.zsh_history"
      printf 'removed empty %s\n' "$HOME/.zsh_history"
    else
      printf 'keep: non-empty %s\n' "$HOME/.zsh_history"
      printf 'hint: manually review before merging into %s\n' "$xdg_state_home/zsh/history"
    fi
  fi

  printf 'cleanup complete.\n'
}

git_require_repo() {
  if ! command -v git >/dev/null 2>&1; then
    printf 'error: git is required\n' >&2
    exit 1
  fi

  if [ ! -d "$repo_dir/.git" ]; then
    printf 'error: not a git repo: %s\n' "$repo_dir" >&2
    exit 1
  fi
}

git_is_dirty() {
  [ -n "$(git -C "$repo_dir" status --porcelain)" ]
}

git_status_summary() {
  printf '\nlocal changes:\n'

  if git_is_dirty; then
    git -C "$repo_dir" status --short | sed 's/^/  /'
  else
    printf '  none\n'
  fi
}

git_log_summary() {
  upstream=$1

  incoming_count=$(git -C "$repo_dir" rev-list --count "HEAD..$upstream" 2>/dev/null || printf '0')
  local_count=$(git -C "$repo_dir" rev-list --count "$upstream..HEAD" 2>/dev/null || printf '0')

  printf '\nrepository state:\n'
  printf '  upstream: %s\n' "$upstream"
  printf '  incoming commits: %s\n' "$incoming_count"
  printf '  local-only commits: %s\n' "$local_count"

  if [ "$incoming_count" -gt 0 ] 2>/dev/null; then
    printf '\nincoming commits:\n'
    git -C "$repo_dir" log --oneline --decorate --max-count=10 "HEAD..$upstream" | sed 's/^/  /'
  fi

  if [ "$local_count" -gt 0 ] 2>/dev/null; then
    printf '\nlocal-only commits:\n'
    git -C "$repo_dir" log --oneline --decorate --max-count=10 "$upstream..HEAD" | sed 's/^/  /'
  fi
}

print_update_hints() {
  {
    printf '\nRoutes:\n'
    printf '  dotfiles update --discard\n'
    printf '    Review and discard local repo changes, then reset to upstream.\n'
    printf '  dotfiles update --discard --yes\n'
    printf '    Same, without prompting.\n'
    printf '  git -C "%s" stash push -u && dotfiles update && git -C "%s" stash pop\n' "$repo_dir" "$repo_dir"
    printf '    Preserve local edits around the update yourself.\n'
    printf '  dotfiles status\n'
    printf '    Inspect the current repo state.\n'
    printf '\n'
  } >&2
}

confirm_discard() {
  assume_yes=$1

  if [ "$assume_yes" = 1 ]; then
    return 0
  fi

  if [ ! -t 0 ]; then
    printf 'error: refusing to discard local work without --yes in non-interactive mode\n' >&2
    printf 'hint: rerun with: dotfiles update --discard --yes\n' >&2
    exit 1
  fi

  printf '\nThis will permanently discard local repo changes in:\n'
  printf '  %s\n' "$repo_dir"
  printf '\nType "discard" to continue: '

  IFS= read -r answer

  if [ "$answer" != discard ]; then
    printf 'aborted.\n'
    exit 1
  fi
}

discard_update() {
  upstream=$1
  assume_yes=$2

  git_status_summary
  git_log_summary "$upstream"
  confirm_discard "$assume_yes"

  printf '\ndiscarding local repo state and resetting to %s\n' "$upstream"
  git -C "$repo_dir" reset --hard "$upstream"
  git -C "$repo_dir" clean -fd

  reinstall_after_update
}

reinstall_after_update() {
  exec sh "$installer" install
}

fast_forward_update() {
  upstream=$1

  printf '\nupdating %s\n' "$repo_dir"
  printf 'fast-forwarding to %s\n' "$upstream"

  if ! git -C "$repo_dir" merge --ff-only "$upstream"; then
    printf '\nerror: fast-forward update failed.\n' >&2
    print_update_hints
    exit 1
  fi

  reinstall_after_update
}

update_help() {
  cat <<EOF
usage: dotfiles update [--discard] [--yes]

Safely update this dotfiles repository, then reinstall symlinks.

Default behavior:
  dotfiles update
    Fetches upstream and fast-forwards when the repo is clean.
    Refuses to touch local changes; explains the safe routes instead.

Options:
  dotfiles update --discard
    Show local changes, ask for confirmation, then discard local repo changes
    and reset to upstream.

  dotfiles update --discard --yes
    Discard local repo changes without prompting.
    Use this for the easiest seamless update when you do not care about local edits.

Manual escape hatches:
  dotfiles status
    Inspect repo status.

  git -C "$repo_dir" stash push -u
    Preserve local edits before updating; pop them after.

  git -C "$repo_dir" reset --hard @{upstream}
  git -C "$repo_dir" clean -fd
    Manually discard local changes and untracked files.
EOF
}

update_dotfiles() {
  update_mode=default
  assume_yes=0

  while [ "$#" -gt 0 ]; do
    case "$1" in
      --discard)
        update_mode=discard
        ;;
      -y|--yes)
        assume_yes=1
        ;;
      -h|--help)
        update_help
        return 0
        ;;
      *)
        printf 'error: unknown update option: %s\n\n' "$1" >&2
        update_help >&2
        exit 1
        ;;
    esac

    shift
  done

  git_require_repo

  branch=$(git -C "$repo_dir" symbolic-ref --quiet --short HEAD || true)

  if [ -z "$branch" ]; then
    printf 'error: dotfiles repo is in detached HEAD state\n' >&2
    printf 'hint: checkout a branch before updating.\n' >&2
    exit 1
  fi

  upstream=$(git -C "$repo_dir" rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' 2>/dev/null || true)

  if [ -z "$upstream" ]; then
    printf 'error: current branch has no upstream configured\n' >&2
    printf 'hint: set one with:\n' >&2
    printf '  git -C "%s" branch --set-upstream-to <remote>/<branch>\n' "$repo_dir" >&2
    exit 1
  fi

  remote=${upstream%%/*}

  printf 'fetching %s for %s\n' "$remote" "$upstream"
  git -C "$repo_dir" fetch --prune "$remote"

  local_rev=$(git -C "$repo_dir" rev-parse HEAD)
  upstream_rev=$(git -C "$repo_dir" rev-parse "$upstream")
  base_rev=$(git -C "$repo_dir" merge-base HEAD "$upstream")

  if [ "$update_mode" = discard ]; then
    discard_update "$upstream" "$assume_yes"
  fi

  if [ "$local_rev" = "$upstream_rev" ]; then
    # Up to date: nothing incoming; leave local work untouched
    printf 'ok: dotfiles repo already up to date\n'

    if git_is_dirty; then
      printf 'note: local changes exist and were left untouched\n'
      printf 'hint: inspect them with: dotfiles status\n'
    fi

    reinstall_after_update
  elif [ "$base_rev" = "$upstream_rev" ]; then
    # Ahead of upstream: nothing incoming; nothing to merge
    git_log_summary "$upstream"

    printf '\nlocal branch is ahead of upstream; no remote update is needed.\n'
    printf 'hint: publish local commits with: git -C "%s" push\n' "$repo_dir"
    printf 'hint: discard local commits with: dotfiles update --discard\n'

    reinstall_after_update
  elif [ "$base_rev" != "$local_rev" ]; then
    # Diverged: local and upstream both have exclusive commits
    git_status_summary
    git_log_summary "$upstream"

    {
      printf '\nLocal and upstream histories have diverged.\n'
      printf 'Automatic update is not safe. Preserve local commits with:\n'
      printf '  git -C "%s" rebase "%s"\n' "$repo_dir" "$upstream"
    } >&2
    print_update_hints
    exit 1
  else
    # Behind upstream only: fast-forwardable
    if git_is_dirty; then
      git_status_summary
      git_log_summary "$upstream"

      printf '\nerror: local changes exist; refusing to update over them.\n' >&2
      print_update_hints
      exit 1
    fi

    fast_forward_update "$upstream"
  fi
}

status_dotfiles() {
  printf 'dotfiles repo: %s\n' "$repo_dir"

  if [ ! -d "$repo_dir/.git" ]; then
    printf 'not a git repo\n'
    return 0
  fi

  if ! command -v git >/dev/null 2>&1; then
    printf 'git is not available\n'
    return 0
  fi

  printf '\n'
  git -C "$repo_dir" status --short --branch

  stashes=$(git -C "$repo_dir" stash list 2>/dev/null | sed -n '1,5p' || true)

  if [ -n "$stashes" ]; then
    printf '\nstashes:\n'
    printf '%s\n' "$stashes" | sed 's/^/  /'
  fi
}

uninstall_dotfiles() {
  managed_dirs | while IFS= read -r src; do
    name=${src##*/}
    remove_owned_link "$xdg_config_home/$name" "$src"
  done

  if [ -f "$repo_dir/zsh/.zshenv" ]; then
    remove_owned_link "$HOME/.zshenv" "$repo_dir/zsh/.zshenv"
  fi

  remove_owned_link "$user_bin_home/dotfiles" "$installer"

  printf '\ndone.\n'
}

workspace_help() {
  cat <<'EOF'
usage: dotfiles workspace [DIR]
       dotfiles code [DIR]

Launch a Ghostty coding workspace layout (macOS only).

Arguments:
  DIR   Workspace directory. Defaults to the current directory.

Layout:
  left           editor
  middle top     shell
  middle bottom  shell
  right          agent

Environment:
  DOTFILES_WORKSPACE=0
      Disable this launcher.

  DOTFILES_WORKSPACE_SCRIPT=/path/to/workspace.applescript
      Override the AppleScript implementation path.

  DOTFILES_WORKSPACE_EDITOR_CMD='nvim .'
      Command started in the left pane.

  DOTFILES_WORKSPACE_AGENT_CMD='ocode'
      Command started in the right pane.

  DOTFILES_WORKSPACE_MIDDLE_TOP_CMD=''
      Optional command started in the middle-top pane.

  DOTFILES_WORKSPACE_MIDDLE_BOTTOM_CMD=''
      Optional command started in the middle-bottom pane.
EOF
}

workspace_dotfiles() {
  if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
    workspace_help
    return 0
  fi

  case "${DOTFILES_WORKSPACE:-1}" in
    0|false|FALSE|off|OFF|no|NO)
      printf 'ghostty workspace: disabled by DOTFILES_WORKSPACE\n' >&2
      return 0
      ;;
  esac

  if [ "$(uname -s)" != Darwin ]; then
    printf 'ghostty workspace: Ghostty AppleScript automation requires macOS\n' >&2
    exit 1
  fi

  if [ ! -x /usr/bin/osascript ]; then
    printf 'ghostty workspace: /usr/bin/osascript not found\n' >&2
    exit 1
  fi

  workspace_dir=${1:-$PWD}

  if [ ! -d "$workspace_dir" ]; then
    printf 'ghostty workspace: not a directory: %s\n' "$workspace_dir" >&2
    exit 1
  fi

  workspace_dir=$(
    cd -P "$workspace_dir" 2>/dev/null && pwd
  ) || {
    printf 'ghostty workspace: could not resolve directory: %s\n' "$workspace_dir" >&2
    exit 1
  }

  workspace_script=${DOTFILES_WORKSPACE_SCRIPT:-"$xdg_config_home/ghostty/workspace.applescript"}

  if [ ! -r "$workspace_script" ]; then
    printf 'ghostty workspace: missing script: %s\n' "$workspace_script" >&2
    printf 'hint: run: dotfiles install\n' >&2
    exit 1
  fi

  output=$(
    /usr/bin/osascript \
      "$workspace_script" \
      "$workspace_dir" \
      "${DOTFILES_WORKSPACE_EDITOR_CMD:-nvim .}" \
      "${DOTFILES_WORKSPACE_AGENT_CMD:-ocode}" \
      "${DOTFILES_WORKSPACE_MIDDLE_TOP_CMD:-}" \
      "${DOTFILES_WORKSPACE_MIDDLE_BOTTOM_CMD:-}" \
      2>&1
  ) || {
    rc=$?
    output=$(printf '%s\n' "$output" | tr '\n' ' ')
    [ -n "$output" ] || output="osascript exited with status $rc"

    printf 'ghostty workspace: %s\n' "$output" >&2
    exit "$rc"
  }
}

usage() {
  cat <<EOF
usage: dotfiles [install|update|bootstrap|bundle|status|doctor|cleanup|uninstall|workspace|code|help]

commands:
  install     link repo config directories into XDG_CONFIG_HOME
  update      fetch upstream, fast-forward when clean, then install
  bootstrap   install links, ensure Homebrew, then run brew bundle
  bundle      run brew bundle for this dotfiles Brewfile
  status      show dotfiles repo status
  doctor      show environment status and next steps
  cleanup     remove only safe empty legacy home files
  uninstall   remove symlinks owned by this repo
  workspace   launch Ghostty coding workspace layout (macOS)
  code        alias for workspace
  help        show this usage help message

update examples:
  dotfiles update
    Safe default. Updates when clean; refuses to touch local changes.

  dotfiles update --discard
    Review and discard local edits/commits, then reset to upstream.

  dotfiles update --discard --yes
    Seamlessly discard local repo changes and update without prompting.

default:
  install     when executed directly as install.sh
  help        when called as dotfiles, dots, or another command name
EOF
}

default_command() {
  case "$invocation_name" in
    install.sh)
      printf 'install\n'
      ;;
    *)
      printf 'help\n'
      ;;
  esac
}

cmd=${1:-$(default_command)}

if [ "$#" -gt 0 ]; then
  shift
fi

case "$cmd" in
  install)
    install_dotfiles "$@"
    ;;
  update)
    update_dotfiles "$@"
    ;;
  bootstrap)
    bootstrap_dotfiles "$@"
    ;;
  bundle)
    bundle_dotfiles "$@"
    ;;
  status)
    status_dotfiles "$@"
    ;;
  doctor)
    doctor_dotfiles "$@"
    ;;
  cleanup)
    cleanup_dotfiles "$@"
    ;;
  uninstall)
    uninstall_dotfiles "$@"
    ;;
  workspace|code)
    workspace_dotfiles "$@"
    ;;
  -h|--help|help|--usage|usage)
    usage
    ;;
  *)
    printf 'error: unknown command: %s\n\n' "$cmd" >&2
    usage >&2
    exit 1
    ;;
esac

