#!/usr/bin/env bash
# ==============================================================================
# UPGRADED-BOX64: VSCodium ARM64 Production Launcher
# Optimized for Snapdragon 662 (4x A73 + 4x A53) & 39-bit Virtual Address Space
# Compatible with VSCodium 1.72.2 (Electron 19, pre-V8 Memory Cage)
# ==============================================================================

set -eo pipefail

# --- Pre-flight Configuration & Paths ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

export WINEPREFIX="${WINEPREFIX:-/root/.wine}"
VSCODIUM_BIN="${VSCODIUM_BIN:-/opt/vscodium-test/vscodium/VSCodium.exe}"
BOX64_BIN="${BOX64_BIN:-/usr/local/bin/box64}"
WINE_BIN="${WINE_BIN:-/opt/wine/bin/wine64}"

# --- Box64 Dynarec Performance Tuning for Electron / V8 JIT ---
export BOX64_LOG=0
export BOX64_DYNAREC_BIGBLOCK=0        # V8 JIT requires fine-grained blocks
export BOX64_DYNAREC_STRONGMEM=1       # Essential for big.LITTLE memory ordering
export BOX64_DYNAREC_WEAKBARRIER=1     # Relaxed memory barriers for execution speed
export BOX64_DYNAREC_SAFEFLAGS=1       # Safe flag emulation for complex math
export BOX64_DYNAREC_FASTNAN=1         # Skip IEEE-754 NaN edge cases
export BOX64_DYNAREC_FASTROUND=1       # Accelerate floating-point rounding
export BOX64_DYNAREC_CALLRET=1         # Optimize function call/return branch target cache
export BOX64_DYNAREC_ALIGNED_ATOMICS=1 # Fast hardware atomic instructions on aarch64
export BOX64_PAGESIZE=4096             # Native Android 4KB page size
export BOX64_MMAP32=1                  # Enforce 32-bit mmap allocation boundary for Wine

# --- Wine Subsystem Performance Tuning ---
export WINEDEBUG=-all
export WINEDLLOVERRIDES="mscoree,mshtml,winemenubuilder.exe=d"
export WINEESYNC=0
export STAGING_SHARED_MEMORY=1
export __GL_THREADED_OPTIMIZATIONS=0

# --- Pre-flight Checks ---
echo "==> Running VSCodium ARM64 pre-flight checks..."

if [ ! -x "$BOX64_BIN" ]; then
  if command -v box64 >/dev/null 2>&1; then
    BOX64_BIN="$(command -v box64)"
  else
    echo "ERROR: Box64 binary not found at $BOX64_BIN" >&2
    exit 1
  fi
fi

if [ ! -f "$WINE_BIN" ] && ! command -v wine64 >/dev/null 2>&1; then
  echo "ERROR: Wine binary not found at $WINE_BIN" >&2
  exit 1
fi

if [ ! -d "$WINEPREFIX" ]; then
  echo "ERROR: Wine prefix not found at $WINEPREFIX" >&2
  exit 1
fi

if [ ! -f "$VSCODIUM_BIN" ]; then
  echo "ERROR: VSCodium.exe not found at $VSCODIUM_BIN" >&2
  exit 1
fi

# --- Display & Headless Server Management ---
XVFB_STARTED=0
if [ -z "${DISPLAY:-}" ]; then
  echo "==> No DISPLAY detected. Initializing headless Xvfb on :0..."
  export DISPLAY=:0
  Xvfb :0 -screen 0 1024x768x24 -ac &
  XVFB_PID=$!
  XVFB_STARTED=1
  sleep 1
else
  echo "==> Using active DISPLAY=$DISPLAY"
fi

# --- Graceful Shutdown Handler ---
cleanup() {
  echo ""
  echo "==> Terminating VSCodium and Wine processes gracefully..."
  if [ -n "${APP_PID:-}" ] && kill -0 "$APP_PID" 2>/dev/null; then
    kill -TERM "$APP_PID" 2>/dev/null || true
    wait "$APP_PID" 2>/dev/null || true
  fi
  if [ "$XVFB_STARTED" -eq 1 ] && [ -n "${XVFB_PID:-}" ]; then
    kill "$XVFB_PID" 2>/dev/null || true
  fi
  echo "==> Clean shutdown complete."
}
trap cleanup SIGINT SIGTERM SIGHUP EXIT

# --- Electron Optimized Arguments ---
ELECTRON_ARGS=(
  "--no-sandbox"
  "--disable-gpu"
  "--disable-dev-shm-usage"
  "--disable-software-rasterizer"
  "--disable-features=CalculateNativeWinOcclusion,SpareRendererForSitePerProcess"
  "--js-flags=--max-old-space-size=512 --no-opt"
)

echo "==> Launching VSCodium 1.72.2 under Wine + Box64..."
if [ -x "$BOX64_BIN" ] && [ -f "$WINE_BIN" ]; then
  "$BOX64_BIN" "$WINE_BIN" "$VSCODIUM_BIN" "${ELECTRON_ARGS[@]}" "$@" &
else
  wine64 "$VSCODIUM_BIN" "${ELECTRON_ARGS[@]}" "$@" &
fi

APP_PID=$!
echo "==> VSCodium running with PID $APP_PID"

wait "$APP_PID"
