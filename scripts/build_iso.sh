#!/usr/bin/env bash
set -euo pipefail

mkdir -p out

# Hold sleep/idle/lid inhibitor for the entire build, then release on exit
systemd-inhibit \
  --what=sleep:idle:handle-lid-switch \
  --why="JonasOS ISO build in progress" \
  --who="build_iso.sh" \
  --mode=block \
  sleep infinity &
INHIBIT_PID=$!
trap "kill $INHIBIT_PID 2>/dev/null || true" EXIT

sudo podman run --rm -it --privileged \
  -v "$PWD:/work:Z" \
  -v "$PWD/out:/out:Z" \
  debian:bookworm \
  bash -lc '
    set -e
    apt update
    apt install -y live-build debootstrap squashfs-tools xorriso grub-pc-bin grub-efi-amd64-bin mtools rsync

    # copy repo into container FS (not a bind mount)
    rm -rf /tmp/JonasOS
    rsync -a --exclude out/ /work/ /tmp/JonasOS/

    cd /tmp/JonasOS/build/live-build
    lb clean
    lb config
    lb build

    # copy ISO back to host
    cp -v ./*.iso /out/
  '
