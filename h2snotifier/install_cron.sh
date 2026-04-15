#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
MARKER="h2snotifier-random-cron"
SCHEDULE="${1:-*/10 * * * *}"
JITTER_MAX_SECONDS="${JITTER_MAX_SECONDS:-180}"
CRON_CMD="JITTER_MAX_SECONDS=${JITTER_MAX_SECONDS} ${SCRIPT_DIR}/cron_run.sh"

CURRENT_CRONTAB="$(crontab -l 2>/dev/null || true)"
FILTERED_CRONTAB="$(printf '%s\n' "$CURRENT_CRONTAB" | grep -v "$MARKER" || true)"

{
  if [[ -n "$FILTERED_CRONTAB" ]]; then
    printf '%s\n' "$FILTERED_CRONTAB"
  fi
  printf '%s %s # %s\n' "$SCHEDULE" "$CRON_CMD" "$MARKER"
} | crontab -

printf 'Installed cron job:\n%s %s\n' "$SCHEDULE" "$CRON_CMD"
