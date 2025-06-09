#!/bin/bash

apply_colors() {
colors_file="$HOME/.cache/wal/colors"
input_file="$HOME/.cache/wal/templates/template.ron"
output_file="$HOME/.cache/wal/templates/pywall16.ron"

# Read all 16 lines (assumes color0 to color15 are in order, one per line)
mapfile -t colors < "$colors_file"

# Copy input to output first
cp "$input_file" "$output_file"

# Replace {color0} to {color15}
for i in {0..15}; do
    hex="${colors[$i]}"
    sed -i "s/{color$i}/$hex/g" "$output_file"
done

echo "Applied wal colors to $output_file"
}

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
      wal -e -s -i "${wallpapers[i]}" 
      #feh --bg-scale "${wallpapers[i]}"
      echo "Selected wallpaper: ${wallpapers[i]}"
      apply_colors
      exit 0
    fi
  done
fi

echo "No wallpaper selected."
exit 1
