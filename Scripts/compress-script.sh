#!/bin/bash

# -----------------------
# CONFIGURATION
# -----------------------

# Maximum allowed file size in bytes (10 MB)
MAX_SIZE=$((10 * 1024 * 1024))

# Starting and maximum CRF values
START_CRF=23
MAX_CRF=35

# Number of parallel jobs (number of concurrent encodes)
JOBS=4

# Output folder for compressed files
COMPRESSED_DIR="./compressed"
mkdir -p "$COMPRESSED_DIR"

# -----------------------
# FUNCTION
# -----------------------
process_file() {
  f="$1"
  [ -f "$f" ] || return
  base="$(basename "${f%.*}")"
  output="$COMPRESSED_DIR/${base}_compressed.mp4"

  # Skip if compressed version already exists
  if [ -f "$output" ]; then
    echo "⏩ Skipping '$f' — already compressed."
    return
  fi

  crf=$START_CRF
  echo "▶ Processing '$f'..."

  while :; do
    echo "  → Encoding with CRF $crf..."
    ffmpeg -y -i "$f" -c:v libx264 -preset fast -crf "$crf" -threads 2 "$output" -loglevel error

    size=$(stat -c%s "$output" 2>/dev/null || echo 0)

    if [ "$size" -le "$MAX_SIZE" ] && [ "$size" -gt 0 ]; then
      echo "  ✓ Done! Final size: $((size / 1024 / 1024)) MB (CRF $crf)"
      break
    else
      echo "  ✗ File is $((size / 1024 / 1024)) MB, increasing CRF..."
      ((crf++))
      rm -f "$output"
      if [ "$crf" -gt "$MAX_CRF" ]; then
        echo "  ⚠️ Stopping at CRF $MAX_CRF — still too large."
        break
      fi
    fi
  done
}

# Export function and variables for xargs subprocesses
export -f process_file
export MAX_SIZE START_CRF MAX_CRF COMPRESSED_DIR

# -----------------------
# PARALLEL EXECUTION
# -----------------------
find . -maxdepth 1 -type f \( -iname '*.mp4' -o -iname '*.mkv' \) -print0 | \
  xargs -0 -n1 -P"$JOBS" bash -c 'process_file "$@"' _
