#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/wallpapers"

if [[ ! -d "$WALLPAPER_DIR" ]]; then
  echo "No wallpaper directory found!"
  exit 1
fi

random_wallpaper=$(find -L "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) | shuf -n 1)

if [[ -z "$random_wallpaper" ]]; then
  echo "No images found in $WALLPAPER_DIR"
  exit 1
fi

echo "Selected wallpaper: $random_wallpaper"
feh --bg-scale $random_wallpaper
wal -i $random_wallpaper -n

fastfetch
