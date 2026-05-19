#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

mkdir -p out

podman run --rm --privileged --platform linux/arm64 \
  -v "$PWD:/work" \
  -v "$PWD/out:/out" \
  debian:bookworm \
  bash -lc '
    set -euo pipefail
    export DEBIAN_FRONTEND=noninteractive

    apt update
apt install -y live-build debootstrap squashfs-tools xorriso grub-efi-arm64-bin mtools rsync

    rm -rf /tmp/JonasOS
    rsync -a --exclude out/ /work/ /tmp/JonasOS/

    cd /tmp/JonasOS/build/live-build
    lb clean
    lb config
    lb build

    cp -v ./*.iso /out/
  '
