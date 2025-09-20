#!/usr/bin/env bash
    xrandr --output eDP --off
    xrandr --output HDMI-A-0 --mode 3840x2160
    echo "Xft.dpi: 144" | xrdb -merge
