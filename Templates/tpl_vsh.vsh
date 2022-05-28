#!/usr/bin/env bash
set -u

# Set environment --------------------------------------------------------------

# Define user variables -----

script_title="Bash"


# Aesthetic Functions -----
aes_draw="\e[1;5;38;5;212;48;5;60m"
aes_title="\e[1;25;38;5;183;48;5;60m"
aes_text="\e[22;25;38;5;120;48;5;59m"
aes_reset="\e[0m"
clear_screen="\e[J"
clear_line="\e[K"
cat_section() {
  input=${@}
  input_length=${#input}
  let "sep_n=76-${input_length}"
  let "lsep_n=$sep_n/2"
  let "rsep_n=$sep_n/2+$sep_n%2"
  sep=$(eval printf -- '-%.0s' {1..78})
  lsep=$(eval printf -- '-%.0s' {1..${lsep_n}})
  rsep=$(eval printf -- '-%.0s' {1..${rsep_n}})
  echo -e "${aes_draw}#${sep}#${clear_line}"
  echo -en "${aes_draw}#${lsep} ${aes_title}"
  echo -n "$@"
  echo -e " ${aes_draw}${rsep}#${clear_line}"
  echo -e "${aes_draw}#${sep}#${clear_line}"
}
cat_text() {
  echo -e "${aes_text}$1${clear_line}${aes_reset}"
}
color_line() {
  echo -en "${aes_text}${clear_line}"
}
screen_paint() {
  echo -en "${aes_text}${clear_screen}"
}
screen_reset() {
  echo -en "${aes_reset}${clear_line}"
}

# Start ------------------------------------------------------------------------
screen_paint 
cat_section "Starting ${script_title} Script"
color_line

# Code -----
whoami
echo aaa
echo aaa
echo aaa
echo aaa
echo aaa
echo aaa
echo aaa
echo aaa
echo aaa
echo aaa
echo aaa
echo aaa
echo aaa
echo aaa
echo aaa
echo aaa
echo aaa
echo aaa
echo aaa
echo aaa

# End --------------------------------------------------------------------------
cat_section "/Finished ${script_title} Script"
screen_reset
echo -e "\e[50B"
echo
