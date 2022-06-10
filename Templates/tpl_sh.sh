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
  let "tput_cols=$(tput cols)-2"
  let "sep_n=${tput_cols}-2-${input_length}"
  let "lsep_n=$sep_n/2"
  let "rsep_n=$sep_n/2+$sep_n%2"
  sep=$(eval printf -- '-%.0s' {1..${tput_cols}})
  lsep=$(eval printf -- '-%.0s' {1..${lsep_n}})
  rsep=$(eval printf -- '-%.0s' {1..${rsep_n}})
  echo -e "${aes_draw}#${sep}#${clear_line}"
  echo -en "${aes_draw}#${lsep} ${aes_title}"
  echo -n "$@"
  echo -e " ${aes_draw}${rsep}#${clear_line}"
  echo -e "${aes_draw}#${sep}#${clear_line}"
}
cat_text() {
  echo -e "${aes_text}$1${clear_line}"
  sleep 1
}
cat_draw() {
  echo -e "\e[5m$1${aes_text}${clear_line}"
}
cat_step() {
  echo -e "${aes_text}$1\e[5m ... ${aes_text}${clear_line}"
  sleep 1
}
cat_link() {
  echo -e "  \e[4;38;5;159m$1\e[24m${aes_text}${clear_line}"
  sleep 1
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
echo
echo
echo
echo
screen_paint 
cat_section "Starting ${script_title} Script"
color_line
echo

# Code -----
cat_text "This script requires super user privileges (sudo)!"
cat_text "You will soon be asked to enter the password for $USER ."
echo
tput bel
read -p "Press [Enter] to continue..."
echo
cat_step "Starting script"
echo

# End --------------------------------------------------------------------------
echo
cat_section "/Finished ${script_title} Script"
screen_reset
echo -e "\e[50B"
echo
echo
