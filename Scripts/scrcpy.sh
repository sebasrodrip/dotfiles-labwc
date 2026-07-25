#!/bin/bash
# --- Scrcpy Desktop Mode ---

# Configuration
RESOLUTION="1080x1920"
DENSITY=220
DEVICE=""

# --- Cleanup (runs on exit, even if force-closed) ---
cleanup() {
    echo -e "\nCleaning up device display settings..."
    if [ -n "$DEVICE" ]; then
        timeout 10 adb -s "$DEVICE" wait-for-device 2>/dev/null
        timeout 3 adb -s "$DEVICE" shell wm size reset
        timeout 3 adb -s "$DEVICE" shell wm density reset
        timeout 3 adb -s "$DEVICE" shell settings put system user_rotation 0
        timeout 3 adb -s "$DEVICE" shell input keyevent 224
        timeout 3 adb -s "$DEVICE" shell wm dismiss-keyguard
    fi
    echo "Done."
}

trap cleanup EXIT

# --- Clear stale wireless connections ---
adb disconnect > /dev/null 2>&1

# --- Device detection ---
mapfile -t DEVICE_LIST < <(adb devices | awk '/\tdevice$/{print $1}')

if [ "${#DEVICE_LIST[@]}" -eq 0 ]; then
    echo "No ADB device found. Aborting."
    exit 1
elif [ "${#DEVICE_LIST[@]}" -gt 1 ]; then
    echo "Multiple devices found:"
    for i in "${!DEVICE_LIST[@]}"; do
        echo "  [$i] ${DEVICE_LIST[$i]}"
    done
    read -p "Enter device number: " choice
    DEVICE="${DEVICE_LIST[$choice]}"
else
    DEVICE="${DEVICE_LIST[0]}"
fi

echo "Using device: $DEVICE"

# 1. Disable auto-rotate
adb -s "$DEVICE" shell settings put system accelerometer_rotation 0
adb -s "$DEVICE" shell settings put system user_rotation 1

# 2. Set resolution and density
adb -s "$DEVICE" shell wm size "$RESOLUTION"
adb -s "$DEVICE" shell wm density "$DENSITY"

# 3. Launch scrcpy (script pauses here until window closes)
scrcpy -s "$DEVICE" -SwK
