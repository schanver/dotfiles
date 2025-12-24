#!/bin/bash

# Check if both arguments are provided
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 input.wav output.mp3"
  exit 1
fi

input="$1"
output="$2"

# Check if ffmpeg is installed
if ! command -v ffmpeg &> /dev/null; then
  echo "Error: ffmpeg is not installed."
  exit 1
fi

# Convert the WAV file to MP3
ffmpeg -i "$input" -codec:a libmp3lame -qscale:a 2 "$output"
