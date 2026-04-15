#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
MARKER="h2snotifier-random-cron"

CURRENT_CRONTAB="$(crontab -l 2>/dev/null || true)"
FILTERED_CRONTAB="$(printf '%s\n' "$CURRENT_CRONTAB" | grep -v "$MARKER" || true)"

if [[ -n "$FILTERED_CRONTAB" ]]; then
  printf '%s\n' "$FILTERED_CRONTAB" | crontab -
else
  crontab -r 2>/dev/null || true
fi

pkill -f "$SCRIPT_DIR/cron_run.sh" >/dev/null 2>&1 || true
pkill -f "$SCRIPT_DIR/main.py" >/dev/null 2>&1 || true
rm -f /tmp/h2snotifier.lock

printf 'Stopped h2snotifier cron job and running processes.\n'
