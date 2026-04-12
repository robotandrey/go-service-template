#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

fail() {
  echo "Error: $*" >&2
  exit 1
}

is_bool() {
  case "$1" in
    true|false) return 0 ;;
    *) return 1 ;;
  esac
}

ensure_copier() {
  if command -v copier >/dev/null 2>&1; then
    return 0
  fi

  echo "copier not found, trying auto-install..."

  if command -v uv >/dev/null 2>&1; then
    uv tool install copier || true
  fi

  if ! command -v copier >/dev/null 2>&1 && command -v pipx >/dev/null 2>&1; then
    pipx install copier || true
  fi

  command -v copier >/dev/null 2>&1 || fail "copier is required. Install with 'uv tool install copier' or 'pipx install copier'."
}

TARGET_DIR="${TARGET_DIR:-}"
SERVICE_NAME="${SERVICE_NAME:-}"
MODULE_PATH="${MODULE_PATH:-}"

HTTP_ENABLED="${HTTP_ENABLED:-}"
GRPC_ENABLED="${GRPC_ENABLED:-}"
PG_ENABLED="${PG_ENABLED:-}"
KAFKA_ENABLED="${KAFKA_ENABLED:-}"
KAFKA_PRODUCER_ENABLED="${KAFKA_PRODUCER_ENABLED:-}"
KAFKA_CONSUMER_ENABLED="${KAFKA_CONSUMER_ENABLED:-}"
DOCKER_ENABLED="${DOCKER_ENABLED:-}"

[[ -n "$TARGET_DIR" ]] || fail "TARGET_DIR is required. Example: make service TARGET_DIR=./services/users-api"

for value in "$HTTP_ENABLED" "$GRPC_ENABLED" "$PG_ENABLED" "$KAFKA_ENABLED" "$KAFKA_PRODUCER_ENABLED" "$KAFKA_CONSUMER_ENABLED" "$DOCKER_ENABLED"; do
  if [[ -n "$value" ]] && ! is_bool "$value"; then
    fail "boolean flags must be 'true' or 'false'"
  fi
done

if [[ -n "$SERVICE_NAME" || -n "$MODULE_PATH" || -n "$HTTP_ENABLED" || -n "$GRPC_ENABLED" || -n "$PG_ENABLED" || -n "$KAFKA_ENABLED" || -n "$KAFKA_PRODUCER_ENABLED" || -n "$KAFKA_CONSUMER_ENABLED" || -n "$DOCKER_ENABLED" ]]; then
  [[ -n "$SERVICE_NAME" ]] || fail "SERVICE_NAME is required in non-interactive mode"

  HTTP_ENABLED="${HTTP_ENABLED:-false}"
  GRPC_ENABLED="${GRPC_ENABLED:-true}"
  PG_ENABLED="${PG_ENABLED:-false}"
  KAFKA_ENABLED="${KAFKA_ENABLED:-false}"
  KAFKA_PRODUCER_ENABLED="${KAFKA_PRODUCER_ENABLED:-false}"
  KAFKA_CONSUMER_ENABLED="${KAFKA_CONSUMER_ENABLED:-false}"
  DOCKER_ENABLED="${DOCKER_ENABLED:-false}"

  if [[ "$HTTP_ENABLED" != "true" && "$GRPC_ENABLED" != "true" ]]; then
    fail "at least one transport must be enabled: HTTP_ENABLED or GRPC_ENABLED"
  fi

  if [[ "$KAFKA_ENABLED" == "true" && "$KAFKA_PRODUCER_ENABLED" != "true" && "$KAFKA_CONSUMER_ENABLED" != "true" ]]; then
    fail "when KAFKA_ENABLED=true, set KAFKA_PRODUCER_ENABLED=true or KAFKA_CONSUMER_ENABLED=true"
  fi

  ensure_copier

  echo "Generating service into: $TARGET_DIR"

  copier_args=(
    copy
    -w "$ROOT_DIR"
    "$TARGET_DIR"
    --defaults
    -d "service_name=$SERVICE_NAME"
    -d "http_enabled=$HTTP_ENABLED"
    -d "grpc_enabled=$GRPC_ENABLED"
    -d "pg_enabled=$PG_ENABLED"
    -d "kafka_enabled=$KAFKA_ENABLED"
    -d "kafka_producer_enabled=$KAFKA_PRODUCER_ENABLED"
    -d "kafka_consumer_enabled=$KAFKA_CONSUMER_ENABLED"
    -d "docker_enabled=$DOCKER_ENABLED"
  )

  if [[ -n "$MODULE_PATH" ]]; then
    copier_args+=(-d "module_path=$MODULE_PATH")
  fi

  copier "${copier_args[@]}"
else
  ensure_copier

  echo "Generating service into: $TARGET_DIR"
  # Interactive mode: Copier asks questions in its native UI.
  copier copy -w "$ROOT_DIR" "$TARGET_DIR"
fi

echo
echo "Done. Next steps:"
echo "  cd $TARGET_DIR"
echo "  make generate"
echo "  make run"
