# zsh vi-mode bridge into Ghostty.
#
# Native Ghostty key tables live in ghostty/*.ghostty. This file only maps zsh
# vicmd keys to Ghostty AppleScript commands while editing a shell prompt.
#
# Requires Ghostty's macOS AppleScript support.

# Use Space as a leader in vicmd.
bindkey -M vicmd -r ' ' 2>/dev/null

_ghostty_osascript() {
  emulate -L zsh

  local output rc message

  output="$(command /usr/bin/osascript 2>&1)"
  rc=$?

  if (( rc != 0 )); then
    message="${output//$'\n'/ }"
    [[ -n "$message" ]] || message="osascript exited with status $rc"

    zle -M "Ghostty: $message" 2>/dev/null
    return "$rc"
  fi
}

_ghostty_action() {
  emulate -L zsh

  local action="${1:?missing Ghostty action}"

  case "$action" in
    (*[!A-Za-z0-9_:,.-]*)
      zle -M "Ghostty: invalid action: $action" 2>/dev/null
      return 2
      ;;
  esac

  _ghostty_osascript <<EOF
tell application "Ghostty"
  perform action "$action" on focused terminal of selected tab of front window
end tell
EOF
}

_ghostty_split() {
  emulate -L zsh

  local direction="${1:?missing Ghostty split direction}"

  case "$direction" in
    (right|left|down|up)
      ;;
    (*)
      zle -M "Ghostty: invalid split direction: $direction" 2>/dev/null
      return 2
      ;;
  esac

  _ghostty_osascript <<EOF
tell application "Ghostty"
  set currentTerm to focused terminal of selected tab of front window
  set newTerm to split currentTerm direction $direction
  focus newTerm
end tell
EOF
}

_ghostty_action_widget() {
  emulate -L zsh

  local action rc
  action="${_ghostty_actions[$WIDGET]}"

  if [[ -z "$action" ]]; then
    zle -M "Ghostty: no action registered for $WIDGET" 2>/dev/null
    return 1
  fi

  zle -I
  _ghostty_action "$action"
  rc=$?
  zle reset-prompt
  return "$rc"
}

_ghostty_split_widget() {
  emulate -L zsh

  local direction rc
  direction="${_ghostty_splits[$WIDGET]}"

  if [[ -z "$direction" ]]; then
    zle -M "Ghostty: no split direction registered for $WIDGET" 2>/dev/null
    return 1
  fi

  zle -I
  _ghostty_split "$direction"
  rc=$?
  zle reset-prompt
  return "$rc"
}

typeset -gA _ghostty_splits=(
  _ghostty_split_down   down
  _ghostty_split_right  right
)

typeset -gA _ghostty_actions=(
  _ghostty_split_resize_up       'resize_split:up,10'
  _ghostty_split_resize_down     'resize_split:down,10'
  _ghostty_split_resize_left     'resize_split:left,10'
  _ghostty_split_resize_right    'resize_split:right,10'
  _ghostty_split_zoom            'toggle_split_zoom'
  _ghostty_split_equalize        'equalize_splits'

  _ghostty_goto_next             'goto_split:next'
  _ghostty_goto_previous         'goto_split:previous'
  _ghostty_goto_up               'goto_split:up'
  _ghostty_goto_down             'goto_split:down'
  _ghostty_goto_left             'goto_split:left'
  _ghostty_goto_right            'goto_split:right'

  _ghostty_surface_close         'close_surface'

  _ghostty_scroll_line_up        'scroll_page_lines:-1'
  _ghostty_scroll_line_down      'scroll_page_lines:1'
  _ghostty_scroll_half_up        'scroll_page_fractional:-0.5'
  _ghostty_scroll_half_down      'scroll_page_fractional:0.5'
  _ghostty_scroll_page_up        'scroll_page_up'
  _ghostty_scroll_page_down      'scroll_page_down'
  _ghostty_scroll_top            'scroll_to_top'
  _ghostty_scroll_bottom         'scroll_to_bottom'
)

for _ghostty_widget in ${(k)_ghostty_splits}; do
  zle -N "$_ghostty_widget" _ghostty_split_widget
done

for _ghostty_widget in ${(k)_ghostty_actions}; do
  zle -N "$_ghostty_widget" _ghostty_action_widget
done

unset _ghostty_widget

# Window navigation: splits
bindkey -M vicmd '^ws' _ghostty_split_down
bindkey -M vicmd ' ws' _ghostty_split_down

bindkey -M vicmd '^wv' _ghostty_split_right
bindkey -M vicmd ' wv' _ghostty_split_right

# Window navigation: resize
bindkey -M vicmd '^w+' _ghostty_split_resize_up
bindkey -M vicmd ' w+' _ghostty_split_resize_up

bindkey -M vicmd '^w-' _ghostty_split_resize_down
bindkey -M vicmd ' w-' _ghostty_split_resize_down

bindkey -M vicmd '^w<' _ghostty_split_resize_left
bindkey -M vicmd ' w<' _ghostty_split_resize_left

bindkey -M vicmd '^w>' _ghostty_split_resize_right
bindkey -M vicmd ' w>' _ghostty_split_resize_right

bindkey -M vicmd '^w_' _ghostty_split_zoom
bindkey -M vicmd ' w_' _ghostty_split_zoom
bindkey -M vicmd '^w|' _ghostty_split_zoom
bindkey -M vicmd ' w|' _ghostty_split_zoom

bindkey -M vicmd '^w=' _ghostty_split_equalize
bindkey -M vicmd ' w=' _ghostty_split_equalize

# Window navigation: focus
bindkey -M vicmd '^ww' _ghostty_goto_next
bindkey -M vicmd ' ww' _ghostty_goto_next

bindkey -M vicmd '^wW' _ghostty_goto_previous
bindkey -M vicmd ' wW' _ghostty_goto_previous

bindkey -M vicmd '^wk' _ghostty_goto_up
bindkey -M vicmd ' wk' _ghostty_goto_up

bindkey -M vicmd '^wj' _ghostty_goto_down
bindkey -M vicmd ' wj' _ghostty_goto_down

bindkey -M vicmd '^wh' _ghostty_goto_left
bindkey -M vicmd ' wh' _ghostty_goto_left

bindkey -M vicmd '^wl' _ghostty_goto_right
bindkey -M vicmd ' wl' _ghostty_goto_right

# Surface lifecycle
bindkey -M vicmd ' qq' _ghostty_surface_close

# Scrollback navigation
bindkey -M vicmd 'k' _ghostty_scroll_line_up
bindkey -M vicmd 'j' _ghostty_scroll_line_down

bindkey -M vicmd '^u' _ghostty_scroll_half_up
bindkey -M vicmd '^d' _ghostty_scroll_half_down

bindkey -M vicmd '^b' _ghostty_scroll_page_up
bindkey -M vicmd '^f' _ghostty_scroll_page_down

bindkey -M vicmd 'gg' _ghostty_scroll_top
bindkey -M vicmd 'G' _ghostty_scroll_bottom

