#!/bin/sh

# This script should be passed to gpu-screen-recorder with the -sc option

# Try kdotool first (Native Wayland & Xwayland on KDE)
if command -v kdotool >/dev/null 2>&1; then
    window=$(kdotool getactivewindow)
    window_name=$(kdotool getwindowname "$window" || kdotool getwindowclassname "$window" || echo "Game")
else
    # Fallback to xdotool (Xwayland / X11)
    window=$(xdotool getwindowfocus)
    window_name=$(xdotool getwindowname "$window" || xdotool getwindowclassname "$window" || echo "Game")
fi

# Clean up the string to prevent file path errors
window_name="$(echo "$window_name" | tr '/\\' '_')"

video_dir="$HOME/Videos/Replays/$window_name"
mkdir -p "$video_dir"
video="$video_dir/$(date +"${window_name}_%Y-%m-%d_%H-%M-%S.mp4")"

mv "$1" "$video"
sleep 0.5 && notify-send -t 2000 -u low "GPU Screen Recorder" "Replay saved to $video"
