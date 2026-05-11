#!/usr/bin/env bash
set -euo pipefail

if compgen -G "out/*.iso" > /dev/null; then
  ISO="$(ls -t out/*.iso | head -n1)"
elif [[ -f "build/live-build/live-image-amd64.hybrid.iso" ]]; then
  ISO="build/live-build/live-image-amd64.hybrid.iso"
else
  echo "ISO not found in out/*.iso"
  echo "Build it first: ./scripts/build_iso.sh"
  exit 1
fi

qemu-system-x86_64 \
  -m 4096 \
  -enable-kvm \
  -cdrom "$ISO"
