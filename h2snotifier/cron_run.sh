#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

LOCK_FILE="/tmp/h2snotifier.lock"
LOG_FILE="$SCRIPT_DIR/cron.log"
JITTER_MAX_SECONDS="${JITTER_MAX_SECONDS:-180}"

log() {
  printf '%s %s\n' "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" "$1" >> "$LOG_FILE"
}

if ! [[ "$JITTER_MAX_SECONDS" =~ ^[0-9]+$ ]]; then
  JITTER_MAX_SECONDS=0
fi

exec 9>"$LOCK_FILE"
if ! flock -n 9; then
  log "skipped: previous run is still active"
  exit 0
fi

if (( JITTER_MAX_SECONDS > 0 )); then
  delay=$(( RANDOM % (JITTER_MAX_SECONDS + 1) ))
  log "sleeping ${delay}s before start"
  sleep "$delay"
fi

log "starting notifier"
if "$SCRIPT_DIR/run.sh" >> "$LOG_FILE" 2>&1; then
  log "notifier finished successfully"
else
  status=$?
  log "notifier failed with exit code ${status}"
  exit "$status"
fi
