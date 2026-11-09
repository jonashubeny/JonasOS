# JonasOS

Personalized Linux OS project focused on a clean XFCE desktop and useful defaults.
The current version (`v0.x`) is built on Debian; the long-term plan is to build JonasOS
from scratch on top of the Linux kernel (see [Future: from scratch](#future-from-scratch)).

Read more:
- https://blog.jonashubeny.dev/posts/jonasos-beginning/
- https://blog.jonashubeny.dev/posts/improving-defaults/

## What is currently included

- Debian live ISO build based on `live-build`
- XFCE desktop session with LightDM
- Basic desktop apps (for example Firefox ESR, Mousepad, Thunar, Xfce utilities)
- Networking and audio defaults (NetworkManager + PulseAudio packages)
- Shell defaults for new users via `/etc/skel` (`.bashrc`, `.profile`)

## Future: from scratch

JonasOS is moving away from Debian. The goal is to build the whole system from scratch on
top of the Linux kernel: own toolchain, userland, kernel config and build scripts, with no
`live-build`, `apt` or Debian packages. The approach follows
[Linux From Scratch](https://www.linuxfromscratch.org/).

- The Debian-based build in `build/live-build/` stays the working version until the
  from-scratch build boots to a desktop.
- The from-scratch build will live in its own directory (e.g. `scratch/`) next to it.
- First milestone: a self-built kernel + minimal userland booting to a shell in QEMU.

Plan, open decisions (libc, init, package management) and progress:
[#27](https://github.com/jonashubeny/JonasOS/issues/27) and [ROADMAP.md](ROADMAP.md#6-long-term-from-scratch-base).

## Project structure

```text
JonasOS/
  README.md
  build/
    live-build/
      auto/
        config
      config/
        includes.chroot/etc/skel/
          .bashrc
          .profile
        package-lists/
          system.list.chroot
          xorg.list.chroot
          xfce-core.list.chroot
          xfce-apps.list.chroot
          display-manager.list.chroot
          fonts.list.chroot
          themes.list.chroot
          extras.list.chroot
  scripts/
    build_iso.sh
    run_vm.sh
  packages/                        # legacy placeholders
  overlay/                         # optional custom files
  out/                             # generated ISOs
  .github/
    workflows/
      ci.yml
```

## Build ISO

`scripts/build_iso.sh` runs Debian `live-build` inside a Podman container and copies the resulting ISO to `out/`.

```bash
chmod +x scripts/build_iso.sh
./scripts/build_iso.sh
```

Host requirements:

- `podman`
- `sudo` access
- internet access (container installs required build tools with `apt`)

Result:

```bash
out/*.iso
```

## Run ISO in VM

`scripts/run_vm.sh` starts QEMU with the newest ISO from `out/` (or falls back to `build/live-build/live-image-amd64.hybrid.iso`).

```bash
chmod +x scripts/run_vm.sh
./scripts/run_vm.sh
```

Host requirements:

- `qemu-system-x86_64`
- KVM support (`/dev/kvm`)

## Open ISO in GNOME Boxes (Fedora/libvirt)

If GNOME Boxes shows a permission error when opening an ISO from `out/`, copy the ISO into libvirt storage and set the correct ownership/permissions:

```bash
sudo install -o qemu -g qemu -m 644 \
  /home/jonas/_JONASOS/JonasOS/out/live-image-amd64.hybrid.iso \
  /var/lib/libvirt/images/live-image-amd64.hybrid.iso
```

Allow Boxes to browse the libvirt images directory:

```bash
sudo chmod 755 /var/lib/libvirt/images
```

Optional (if SELinux still blocks access):

```bash
sudo restorecon -v /var/lib/libvirt/images/live-image-amd64.hybrid.iso
```

Then restart GNOME Boxes and select:

```text
/var/lib/libvirt/images/live-image-amd64.hybrid.iso
```

Tip: In the file picker, press `Ctrl+L` and paste the full path directly.
