#!/usr/bin/env bash
set -euo pipefail

ISO="build/live-build/live-image-amd64.hybrid.iso"

if [[ ! -f "$ISO" ]]; then
  echo "ISO not found: $ISO"
  echo "Build it first: ./scripts/build_iso.sh"
  exit 1
fi

qemu-system-x86_64 \
  -m 4096 \
  -enable-kvm \
  -cdrom "$ISO"
