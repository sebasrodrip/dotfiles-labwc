#!/bin/bash
case "$1" in
  select) grim -g "$(slurp)" -t ppm - | satty --filename - --output-filename ~/Pictures/Screenshots/$(date +%Y%m%d_%H%M%S).png ;;
  output) grim -t ppm - | satty --filename - --output-filename ~/Pictures/Screenshots/$(date +%Y%m%d_%H%M%S).png ;;
esac
