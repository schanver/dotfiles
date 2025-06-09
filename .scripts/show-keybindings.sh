#!/usr/bin/env bash

cat ~/dotfiles/.scripts/keybindings.txt | rofi -dmenu -i -p "Keybindings" -config ~/dotfiles/rofi/rofidmenu.rasi
