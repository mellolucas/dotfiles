# PATH ----------------------------------------
path=('/$HOME/.local/bin')
path+=('/usr/lib64/ccache')
path+=('/usr/local/bin')
path+=('/usr/local/sbin')
path+=('/usr/bin:/usr/sbin')
path+=('/var/lib/snapd/snap/bin')
export PATH

# XDG base Dirs ----------------------------------------
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}

# ZSH paths ----------------------------------------
export ZSH="$HOME/.ohmyzsh.d"                # Path to oh-my-zsh installation
export ZSH_CUSTOM="$HOME/.ohmyzsh_custom.d"  # Path to oh-my-zsh user mods

# Default Apps ----------------------------------------
export EDITOR=$(which nvim || which vim || which vi || which nano) 2>/dev/null
export VISUAL=$EDITOR

# Locale ----------------------------------------
export LC_COLLATE=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_MESSAGES=en_US.UTF-8
export LC_MONETARY=en_US.UTF-8
export LC_NUMERIC=en_US.UTF-8
export LC_TIME=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LESSCHARSET=utf-8
