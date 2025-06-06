#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/wallpapers"

if [[ ! -d "$WALLPAPER_DIR" ]]; then
  echo "No wallpaper directory found!"
  exit 1
fi

# Use relative paths so subfolders are included
random_wallpaper_rel=$(find -L "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) -printf "%P\n" | rofi -dmenu -p "Choose wallpaper" -config ~/dotfiles/rofi/rofidmenu.rasi)

if [[ -z "$random_wallpaper_rel" ]]; then
  echo "No image selected."
  exit 1
fi

random_wallpaper="$WALLPAPER_DIR/$random_wallpaper_rel"

echo "Selected wallpaper: $random_wallpaper"

# Set wallpaper with feh
feh --bg-scale "$random_wallpaper"
