#!/usr/bin/env bash
# sync-yt-subs.sh
#
# Pulls your real YouTube subscriptions (via yt-dlp + browser cookies) into
# ytfzf's subscriptions file, so `ytfzf -cS` reflects your actual account
# instead of a hand-maintained list.
#
# Usage:
#   ./sync-yt-subs.sh                                   # uses default below
#   ./sync-yt-subs.sh brave                              # a different browser
#   ./sync-yt-subs.sh "firefox:default::YourContainer"   # pin a specific
#                                                          Firefox container
#                                                          (Multi-Account
#                                                          Containers users:
#                                                          use this so it
#                                                          reads the right
#                                                          cookie jar).
#
# Setup once:
#   - Log into YouTube in the browser/container you point this at.
#   - If you hit "database is locked" errors, either close the browser before
#     running this, or export a cookies.txt with a browser extension once and
#     switch COOKIE_SOURCE below to "--cookies $HOME/.config/ytfzf/cookies.txt".

set -euo pipefail

BROWSER_SPEC="${1:-firefox}"
COOKIE_SOURCE="--cookies-from-browser $BROWSER_SPEC"

CONFIG_DIR="$HOME/.config/ytfzf"
AUTO_FILE="$CONFIG_DIR/subscriptions.auto"     # overwritten every sync
MANUAL_FILE="$CONFIG_DIR/subscriptions.manual" # channels you add by hand, never touched
OUT_FILE="$CONFIG_DIR/subscriptions"           # what ytfzf actually reads

mkdir -p "$CONFIG_DIR"
touch "$MANUAL_FILE"

TMP="$(mktemp)"
TMP_RAW="$(mktemp)"
TMP_ERR="$(mktemp)"
trap 'rm -f "$TMP" "$TMP_RAW" "$TMP_ERR"' EXIT

echo "Fetching subscriptions feed via yt-dlp ($BROWSER_SPEC cookies)..."

# :ytsubs pulls recent videos from subscribed channels; we only want the
# channel URL from each entry, deduplicated. --playlist-end caps how many
# recent videos we scan (raise it if you have channels that post rarely).
# Disable pipefail/errexit around this call so a yt-dlp failure is reported
# with its real error instead of silently killing the whole script.
set +e
yt-dlp \
  $COOKIE_SOURCE \
  --flat-playlist \
  --skip-download \
  --playlist-end 300 \
  --print "%(channel_url)s" \
  ":ytsubs" > "$TMP_RAW" 2> "$TMP_ERR"
YTDLP_STATUS=$?
set -e

if [ "$YTDLP_STATUS" -ne 0 ]; then
  echo "yt-dlp failed (exit $YTDLP_STATUS). Its error output was:" >&2
  cat "$TMP_ERR" >&2
  exit 1
fi

grep -E '^https://www\.youtube\.com/(channel/|@)' "$TMP_RAW" | sort -u > "$TMP"

if [ ! -s "$TMP" ]; then
  echo "yt-dlp ran but returned no channel URLs. This usually means:" >&2
  echo "  - the container/profile spec matched the wrong (empty) cookie jar" >&2
  echo "  - yt-dlp's flat-playlist channel metadata is temporarily broken upstream" >&2
  echo "Raw yt-dlp stderr was:" >&2
  cat "$TMP_ERR" >&2
  exit 1
fi

mv "$TMP" "$AUTO_FILE"
cat "$AUTO_FILE" "$MANUAL_FILE" | sort -u > "$OUT_FILE"

echo "Synced $(wc -l < "$AUTO_FILE") channels from your account."
echo "Added $(wc -l < "$MANUAL_FILE") manual channels from $MANUAL_FILE."
echo "Wrote $(wc -l < "$OUT_FILE") total to $OUT_FILE"
