#!/system/bin/sh
# UPGRADED-BOX64 wrapper: strips invalid rootfs library paths
# before launching box64.real, preventing GNU ld script libc.so
# from being picked up by Android's Bionic linker.
MYDIR="$(cd "$(dirname "$0")" && pwd)"
export LD_LIBRARY_PATH="/system/lib64:/system/lib:/vendor/lib64:/vendor/lib"
exec "$MYDIR/box64.real" "$@"
