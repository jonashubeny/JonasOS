#!/usr/bin/env bash

set -euo pipefial

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LB_DIR="$ROOT_DIR/build/live-build"

if [[ ! -d "$LB_DIR" ]]; then
  echo "Error: live-build directory not found: $LB_DIR" >&2
  exit 1
fi

# This image is only used as a clean build enviroment
IMAGE="debian:bookworm"

podman run --rm -it \
  -v "$ROOT_DIR:/work:Z" \
  -w /work/build/live-build \
  "$IMAGE" \
  bash -lc "
    set -e
    apt update
    apt install -y live-build debootstrap squashfs-tools xorriso grub-pc-bin grub-efi-amd64-bin mtools
    lb clean
    lb config
    lb build
  "

echo
echo "Done. Check build output in: $LB_DIR"
ls -la "$LB_DIR" | sed -n "1,120p"
