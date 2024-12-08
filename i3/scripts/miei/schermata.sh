#!/usr/bin/bash
a=$(date +"%Y-%m-%d-%T")-schermata.png
assets=~/Pictures/$a
maim --select $assets
notify-send "Screenshot saved as $assets"
#kdialog --yesno "Screenshot salvato, vuoi aprirlo?"
#if [ $? == 0 ]; then
  #eog $assets/$a
#fi

