#!/usr/bin/env bash

set -u

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
service_pids=()

start_service() {
  local name="$1"
  local directory="$2"

  if [[ ! -f "$directory/mvnw" ]]; then
    printf 'Error: Maven wrapper not found for %s: %s/mvnw\n' "$name" "$directory" >&2
    exit 1
  fi

  printf 'Starting %s...\n' "$name"
  (
    cd "$directory"
    exec bash ./mvnw spring-boot:run
  ) &
  service_pids+=("$!")
}

stop_services() {
  printf '\nStopping services...\n'
  for pid in "${service_pids[@]}"; do
    kill "$pid" 2>/dev/null || true
  done
  for pid in "${service_pids[@]}"; do
    wait "$pid" 2>/dev/null || true
  done
}

trap stop_services EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

start_service "account-service" "$ROOT_DIR/RideLink/account-service/account-service"
start_service "driver-service" "$ROOT_DIR/RideLink/driver-service/driver-service"
start_service "ride-service" "$ROOT_DIR/RideLink/ride-service/ride-service"
start_service "fare-payment-service" "$ROOT_DIR/RideLink/fare-payment-service"

printf 'All services started. Press Ctrl+C to stop them.\n'

status=0
for pid in "${service_pids[@]}"; do
  wait "$pid" || status=$?
done

exit "$status"
