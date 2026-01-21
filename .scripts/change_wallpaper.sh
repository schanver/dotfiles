#!/bin/bash

# -------------------------------
# CONFIG
# -------------------------------
WALLPAPER_DIR="$HOME/Pictures/wallpapers"
WAL_COLORS_FILE="$HOME/.cache/wal/colors"
TEMPLATE_FILE="$HOME/.cache/wal/templates/template.ron"
OUTPUT_FILE="$HOME/.cache/wal/templates/pywall16.ron"

# -------------------------------
# FUNCTIONS
# -------------------------------

apply_colors() {
    if [[ ! -f "$WAL_COLORS_FILE" ]]; then
        echo "Wal colors file not found: $WAL_COLORS_FILE"
        return
    fi

    mapfile -t colors < "$WAL_COLORS_FILE"

    if [[ ! -f "$TEMPLATE_FILE" ]]; then
        echo "Template file not found: $TEMPLATE_FILE"
        return
    fi

    cp "$TEMPLATE_FILE" "$OUTPUT_FILE"

    for i in {0..15}; do
        hex="${colors[$i]}"
        sed -i "s|{color$i}|$hex|g" "$OUTPUT_FILE"
    done

    echo "Applied wal colors to $OUTPUT_FILE"
}

preview() {
    # Optional: implement ueberzug preview here if desired
    # preview "$index" "$wallpaper_path"
    :
}

cleanup() {
    # Optional: remove ueberzug overlay
    :
}

# -------------------------------
# CHECK WALLPAPER DIR
# -------------------------------
if [[ ! -d "$WALLPAPER_DIR" ]]; then
    echo "Wallpaper directory not found: $WALLPAPER_DIR"
    exit 1
fi

# -------------------------------
# RANDOM WALLPAPER
# -------------------------------
if [[ $1 == "random" ]]; then
    random_wall=$(find -L "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | shuf -n1)
    if [[ -z "$random_wall" ]]; then
        echo "No wallpapers found in $WALLPAPER_DIR"
        exit 1
    fi

    wal -e -s -i "$random_wall"
    apply_colors
    echo "Random wallpaper set: $random_wall"
    exit 0
fi

# -------------------------------
# LOAD WALLPAPERS FOR ROFI
# -------------------------------
mapfile -t wallpapers < <(find -L "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \))
if [[ ${#wallpapers[@]} -eq 0 ]]; then
    echo "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

# Display names for rofi
mapfile -t names < <(printf '%s\n' "${wallpapers[@]##*/}")

# -------------------------------
# ROFI SELECTION
# -------------------------------
selected=""
while true; do
    selected=$(printf '%s\n' "${names[@]}" | rofi -dmenu -i -p "Select wallpaper:" -config ~/dotfiles/rofi/rofidmenu.rasi)

    [[ -z "$selected" ]] && break

    for i in "${!names[@]}"; do
        if [[ "${names[i]}" == "$selected" ]]; then
            preview "$i" "${wallpapers[i]}"
            break
        fi
    done

    break
done

cleanup

# -------------------------------
# APPLY SELECTED WALLPAPER
# -------------------------------
if [[ -n "$selected" ]]; then
    for i in "${!names[@]}"; do
        if [[ "${names[i]}" == "$selected" ]]; then
            wal -e -s -i "${wallpapers[i]}"
            # feh --bg-scale "${wallpapers[i]}"  # optional fallback
            apply_colors
            echo "Selected wallpaper: ${wallpapers[i]}"
            exit 0
        fi
    done
fi

echo "No wallpaper selected."
exit 1
