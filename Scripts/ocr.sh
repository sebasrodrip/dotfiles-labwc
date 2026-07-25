#!/bin/bash

# Default to horizontal if no argument is provided
MODE="${1:-horiz}"
IMG_PATH="/tmp/ocr_image.png"

# Take a screenshot of a selected area and save it temporarily
grim -g "$(slurp)" "$IMG_PATH"

# Check if the user canceled slurp (pressed Esc)
if [ ! -f "$IMG_PATH" ]; then
    exit 1
fi

if [ "$MODE" = "vert" ]; then
    # For vertical text, use jpn_vert and --psm 5
    tesseract "$IMG_PATH" stdout -l jpn_vert+eng --psm 5 | wl-copy
    notify-send "OCR" "Vertical Japanese copied to clipboard!"
else
    # For horizontal text, use jpn and the default PSM
    tesseract "$IMG_PATH" stdout -l jpn+eng | wl-copy
    notify-send "OCR" "Horizontal text copied to clipboard!"
fi

# Clean up
rm "$IMG_PATH"
