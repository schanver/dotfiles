#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/wallpapers"

if [[ ! -d "$WALLPAPER_DIR" ]]; then
  echo "No wallpaper directory found!"
  exit 1
fi

# Find all wallpapers (full paths)
mapfile -t wallpapers < <(find -L "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \))

if [[ ${#wallpapers[@]} -eq 0 ]]; then
  echo "No wallpapers found!"
  exit 1
fi

# Create an array of filenames for display in rofi
mapfile -t names < <(printf '%s\n' "${wallpapers[@]##*/}")

# Setup a FIFO for ueberzug to receive commands
fifo="/tmp/rofi_ueberzug_fifo"
rm -f "$fifo"
mkfifo "$fifo"

# Launch ueberzug in background to show preview images
ueberzug layer --silent < "$fifo" &
ueberzug_pid=$!

cleanup() {
  kill "$ueberzug_pid"
  rm -f "$fifo"
}
trap cleanup EXIT

# Function to send preview commands to ueberzug
preview() {
  local index=$1
  local image_path=$2

  # Clear previous images
  echo "remove preview" > "$fifo"
  # Add new image (position and size depends on your screen/rofi layout)
  echo "add preview image -x 500 -y 0 -w 400 -h 300 \"$image_path\"" > "$fifo"
}

# rofi with preview via ueberzug
selected=""
while true; do
  selected=$(printf '%s\n' "${names[@]}" | rofi -dmenu -i -p "Select wallpaper:" -no-custom -kb-custom-1 "")

  if [[ -z "$selected" ]]; then
    # no selection or ESC pressed, exit loop
    break
  fi

  # find index of selected wallpaper
  for i in "${!names[@]}"; do
    if [[ "${names[i]}" == "$selected" ]]; then
      preview "$i" "${wallpapers[i]}"
      break
    fi
  done

  # Confirm selection by pressing Enter (selected != "")
  # Here, we break and apply the wallpaper
  break
done

# Clean up ueberzug
cleanup

if [[ -n "$selected" ]]; then
  # Find full path of selected wallpaper
  for i in "${!names[@]}"; do
    if [[ "${names[i]}" == "$selected" ]]; then
      feh --bg-scale "${wallpapers[i]}"
      echo "Selected wallpaper: ${wallpapers[i]}"
      exit 0
    fi
  done
fi

echo "No wallpaper selected."
exit 1
