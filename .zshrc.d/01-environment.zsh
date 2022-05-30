# PATH ----------------------------------------
path+=('/$HOME/.local/bin')
path+=('/$HOME/bin')
export PATH

# ZSH Paths ----------------------------------------
export ZSH=$HOME/.ohmyzsh.d                # Path to oh-my-zsh installation
export ZSH_CUSTOM=$HOME/.ohmyzsh_custom.d  # Path to oh-my-zsh user mods

# XDG Base User Dirs ----------------------------------------
export XDG_DATA_HOME=${XDG_CACHE_HOME:-$HOME/.local/share}
export XDG_CONFIG_HOME=${XDG_CACHE_HOME:-$HOME/.config}
export XDG_STATE_HOME=${XDG_CACHE_HOME:-$HOME/.local/state}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
# as per https://wiki.archlinux.org/title/XDG_Base_Directory#User_directories

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
