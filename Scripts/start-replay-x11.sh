#!/bin/sh

pidof -q gpu-screen-recorder && exit 0
video_path="$HOME/Videos"
mkdir -p "$video_path"
gpu-screen-recorder -sc /home/sebastian/Scripts/replay-application-name.sh -w portal -fm content -f 60 -a "$(pactl get-default-sink).monitor|$(pactl get-default-source)" -c mkv -bm cbr -q 40000 -r 30 -o "$video_path" &

REC_PID=$!

"$@" &
GAME_PID=$!

wait $GAME_PID

kill $REC_PID
