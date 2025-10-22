#!/usr/bin/env bash

# Standalone package smoke test.
# Usage: ./reductrai-packages/standalone/smoke-test.sh [path/to/reductrai-standalone.tar.gz]

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
DEFAULT_GLOB="${REPO_ROOT}/reductrai-docker/dist/reductrai-standalone-*.tar.gz"

if [[ $# -gt 0 ]]; then
  TARBALL="$1"
else
  shopt -s nullglob
  matches=($DEFAULT_GLOB)
  shopt -u nullglob
  if [[ ${#matches[@]} -eq 0 ]]; then
    echo "Usage: $0 <path-to-reductrai-standalone.tar.gz>" >&2
    echo "No tarball found in ${DEFAULT_GLOB} and no argument supplied." >&2
    exit 1
  fi
  TARBALL="${matches[-1]}"
fi

if [[ ! -f "$TARBALL" ]]; then
  echo "Tarball not found: $TARBALL" >&2
  exit 1
fi

for cmd in curl; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Required command '$cmd' not found on PATH." >&2
    exit 1
  fi
done

TMPDIR="$(mktemp -d)"
STARTED=0

cleanup() {
  set +e
  if (( STARTED )); then
    ./bin/stop.sh >/dev/null 2>&1 || true
  fi
  popd >/dev/null 2>&1 || true
  rm -rf "$TMPDIR"
}
trap cleanup EXIT

cp "$TARBALL" "$TMPDIR/"
pushd "$TMPDIR" >/dev/null

tar -xzf "$(basename "$TARBALL")"
pkg_dir="$(find . -maxdepth 1 -type d -name 'reductrai-standalone*' | head -n 1)"
if [[ -z "$pkg_dir" ]]; then
  echo "Failed to locate extracted package directory." >&2
  exit 1
fi

pushd "$pkg_dir" >/dev/null

cat > .env <<EOF
REDUCTRAI_LICENSE_KEY=${REDUCTRAI_LICENSE_KEY:-RF-DEMO-2025}
DATADOG_API_KEY=${DATADOG_API_KEY:-demo-key}
LOCAL_LLM_ENDPOINT=http://localhost:11434
EOF

./bin/start.sh >/dev/null 2>&1 &
STARTED=1

wait_for() {
  local name="$1" url="$2" timeout="${3:-90}"
  local start elapsed
  start=$(date +%s)
  until curl -fsS "$url" >/dev/null 2>&1; do
    sleep 3
    elapsed=$(( $(date +%s) - start ))
    if (( elapsed > timeout )); then
      echo "❌ $name did not respond at $url within ${timeout}s" >&2
      return 1
    fi
  done
  echo "✅ $name reachable at $url"
}

wait_for "Proxy" "http://localhost:8080/health"

if [[ -d dashboard ]]; then
  wait_for "Dashboard" "http://localhost:5173" 60
else
  echo "ℹ️ Dashboard artifacts not present; skipping port 5173 check"
fi

if [[ -d ai-query ]]; then
  wait_for "AI Query" "http://localhost:8081/health"
else
  echo "ℹ️ AI Query artifacts not present; skipping port 8081 check"
fi

echo "🎉 Standalone smoke test passed"
