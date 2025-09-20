#!/bin/bash 

CATEGORIES=(
  "PROGRAMMING"
  "GAMING"
  "STUDYING"
  "STOP"
)

selected=$(printf "%s\n" "${CATEGORIES[@]}" | fzf --height=10 --reverse --border --color="bw")
[[ -z "$selected" ]] && exit 0

if [[ "$selected" == "STOP" ]]; then
  timew stop
  tmux set -g status-right ""
else 
  timew start "$selected"
  tmux set -g status-right "$selected | %H:%M "
fi
