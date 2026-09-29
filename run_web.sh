#!/usr/bin/env bash
#
# Run the America 2.0 web app locally.
#
# Flutter's "chrome" device needs a Chromium-based browser and refuses to
# start without one, which is why `flutter run -d chrome` fails on a machine
# that only has Firefox. This script uses Chromium when it is available and
# otherwise falls back to Flutter's browser-less "web-server" device, which
# serves the app over plain HTTP for any browser to open.
#
# Usage:
#   ./run_web.sh                 # debug build, auto-opens your browser
#   ./run_web.sh --release       # release build (what gets deployed)
#   PORT=9000 ./run_web.sh       # serve on a different port
#   NO_OPEN=1 ./run_web.sh       # don't launch a browser, just print the URL
#
set -euo pipefail

PORT="${PORT:-8080}"
URL="http://localhost:${PORT}"
APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/flutter_app_wrapper"

cd "$APP_DIR"

# Echo the first Chromium-based browser on PATH, if any. Firefox is not a
# candidate: Flutter drives the browser over the Chrome DevTools Protocol.
find_chromium() {
  local candidate
  if [[ -n "${CHROME_EXECUTABLE:-}" ]] && command -v "$CHROME_EXECUTABLE" >/dev/null 2>&1; then
    command -v "$CHROME_EXECUTABLE"
    return 0
  fi
  for candidate in google-chrome google-chrome-stable chromium chromium-browser \
                   brave-browser microsoft-edge microsoft-edge-stable; do
    if command -v "$candidate" >/dev/null 2>&1; then
      command -v "$candidate"
      return 0
    fi
  done
  return 1
}

if chromium_path="$(find_chromium)"; then
  echo "==> Using ${chromium_path}"
  echo "    Hot reload (r), hot restart (R) and Flutter DevTools all work."
  echo
  CHROME_EXECUTABLE="$chromium_path" exec flutter run -d chrome --web-port "$PORT" "$@"
fi

cat <<EOF
==> No Chromium-based browser found, so Flutter's "chrome" device is
    unavailable. Falling back to the web-server device.

    Serving at: ${URL}

    Press 'R' in this terminal to hot restart, 'q' to quit.
    Hot reload and Flutter DevTools need a Chromium-based browser:
        sudo snap install chromium

EOF

# Wait for the port to accept connections, then open the default browser.
# The first debug compile takes a while, so poll rather than guess.
if [[ -z "${NO_OPEN:-}" ]] && command -v xdg-open >/dev/null 2>&1; then
  (
    for _ in $(seq 1 180); do
      if (exec 3<>/dev/tcp/127.0.0.1/"$PORT") 2>/dev/null; then
        exec 3>&- 2>/dev/null || true
        xdg-open "$URL" >/dev/null 2>&1 || true
        exit 0
      fi
      sleep 1
    done
  ) &
fi

exec flutter run -d web-server --web-port "$PORT" "$@"
