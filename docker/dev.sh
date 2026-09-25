#!/usr/bin/env bash
# Thin wrapper around `docker compose` that passes your current host UID/GID
# through as HOST_UID/HOST_GID, so the container runs as you rather than a
# stale baked-in UID. Bash's own $UID is read-only and not exported, so it
# can't be picked up by compose directly - hence this wrapper instead of a
# plain .env file.
#
# Usage:
#   ./docker/dev.sh up -d --build
#   ./docker/dev.sh run --rm isaac bash
#   ./docker/dev.sh down
set -euo pipefail

export HOST_UID
export HOST_GID
HOST_UID="$(id -u)"
HOST_GID="$(id -g)"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec docker compose -f "$SCRIPT_DIR/docker-compose.yml" "$@"
