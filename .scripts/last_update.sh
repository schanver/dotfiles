#!/usr/bin/env bash

toggle_file="/tmp/arch_update_toggle_mode"

# read current mode (default “normal”)
mode="normal"
[[ -f $toggle_file ]] && mode=$(<"$toggle_file")

# If left-click (BLOCK_BUTTON=1), toggle the mode
if [[ "$BLOCK_BUTTON" == "1" ]]; then
    echo "Toggling mode to $mode" >> /tmp/arch-update-toggle.log  # Debugging log
    if [[ $mode == "normal" ]]; then
        mode="last"
    else
        mode="normal"
    fi
    printf "%s" "$mode" > "$toggle_file"
    # Force i3blocks to update immediately after toggle
    pkill -RTMIN+10 i3blocks
fi

# helper to pretty-print “time ago”
time_ago() {
    local then sec diff d h m
    then=$(date -d "$1" +%s)  
    sec=$(( $(date +%s) - then ))
    d=$((sec/86400)); sec=$((sec%86400))
    h=$((sec/3600));    sec=$((sec%3600))
    [[ $d -gt 0 ]] && printf "%sd, " "$d"
    [[ $h -gt 0 ]] && printf "%sh" "$h"
    printf " ago"
}

# Check mode and output accordingly
if [[ $mode == "last" ]]; then
    # last pacman
    lp=$(grep -i '\[ALPM\] upgraded' /var/log/pacman.log \
         | tail -1 \
         | cut -d']' -f1 \
         | tr -d '[')
    pacman_ago="N/A"
    [[ -n $lp ]] && pacman_ago=$(time_ago "$lp")

    # last AUR
    if command -v yay &>/dev/null; then
        af=$(find ~/.cache/yay -name PKGBUILD -printf '%T@ %p\n' \
             2>/dev/null | sort -n | tail -1 | cut -d' ' -f2-)
    elif command -v paru &>/dev/null; then
        af=$(find ~/.cache/paru -name PKGBUILD -printf '%T@ %p\n' \
             2>/dev/null | sort -n | tail -1 | cut -d' ' -f2-)
    fi
    aur_ago="N/A"
    [[ -n $af ]] && aur_ago=$(time_ago "$(stat -c %y "$af")")

    echo "󰄬 $pacman_ago |  $aur_ago"
else
    # pending counts
    pcount=$(checkupdates 2>/dev/null | wc -l)
    if command -v yay &>/dev/null; then
        acount=$(yay -Qum 2>/dev/null | wc -l)
    elif command -v paru &>/dev/null; then
        acount=$(paru -Qum 2>/dev/null | wc -l)
    else
        acount=0
    fi
    echo "  $pcount |  $acount "
fi
