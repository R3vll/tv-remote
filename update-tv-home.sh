#!/bin/sh
# Updates TV Home on your TV over adb with the latest build. Needs adb (Termux: pkg install android-tools) and curl.
# Usage: sh update-tv-home.sh TV_IP [PORT]      (PORT defaults to 5555; turn on Network debugging on the TV first)
# If the TV has TV Home from a build signed with another key, install is refused: run once with  --reset  to uninstall first.
set -e
IP=${1:?usage: sh update-tv-home.sh TV_IP [PORT] [--reset]}
PORT=5555; RESET=0
for a in "$@"; do case "$a" in --reset) RESET=1;; [0-9]*) [ "$a" != "$IP" ] && PORT=$a;; esac; done
URL=https://github.com/R3vll/tv-remote/releases/download/tvhome-latest/tv-home.apk
curl -fL -o /tmp/tv-home.apk "$URL" 2>/dev/null || curl -fL -o tv-home.apk "$URL"
APK=/tmp/tv-home.apk; [ -f "$APK" ] || APK=tv-home.apk
adb connect "$IP:$PORT"
[ "$RESET" = 1 ] && adb -s "$IP:$PORT" uninstall dev.tvremote.home || true
adb -s "$IP:$PORT" install -r "$APK"
echo "done: TV Home updated"
