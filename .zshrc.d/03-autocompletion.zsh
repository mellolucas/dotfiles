# Load autocompletion ----------------------------------------
#autoload -Uz compinit # Already called by ohmyzsh
#compinit # Already called by ohmyzsh

# Main ----------------------------------------
#zstyle ':completion:*' completer _expand _complete _correct _approximate        # Completers
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate  # Completers
zstyle ':completion:*' use-cache on                                             # Caching
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"             # Caching dir
zstyle ':completion:*' menu select=3 # Completion menu

# Display Formatting ----------------------------------------
zstyle ':completion:*' auto-description '(%d)'                                  # Description 
zstyle ':completion:*' format '%d'                                              # Decoration
zstyle ':completion:*' group-name ''                                            # Grouped results
zstyle ':completion:*' verbose true                                             # Display descriptions
zstyle ':completion:*' list-colors ''                                           # Colored completion list
#zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}                 # Colored completion list (ls default colors)
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more%s'                # List-prompt decoration
zstyle ':completion:*' select-prompt '%S%l%s'                                   # Display in menu when list don't fit screen

# Smart Completion System ----------------------------------------
zstyle ':completion:*' file-sort name                                           # Files sorting parameter
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=** r:|=** l:|=*'  # Completion matching control
zstyle ':completion:*' ignore-parents parent pwd ..                             # Ignore wd when ../
zstyle ':completion:*' insert-unambiguous true                                  # Insert suggestion when unambiguous
zstyle ':completion:*' expand prefix suffix                                     # Write path when unambiguous
zstyle ':completion:*' list-suffixes true                                       # Show all ambiguous components
zstyle ':completion:*' original true                                            # Add original string as suggestion
zstyle ':completion:*' preserve-prefix '//[^/]##/'                              # Always preserve this pattern
zstyle ':completion:*' insert-tab pending                                       # pasting with tabs doesn't perform completion
_comp_options+=(globdots)                                                       # include hidden files

# Specific Completions ----------------------------------------
for completion ($ZSH/completions/*.zsh(N)) source $completions


# List and examples: https://thevaluable.dev/zsh-completion-guide-examples/ 
