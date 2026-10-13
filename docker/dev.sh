#!/usr/bin/env bash
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
