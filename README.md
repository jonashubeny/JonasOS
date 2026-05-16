# JonasOS

Personalized Debian-based OS project focused on a clean XFCE desktop and useful defaults.

Read more:
- https://blog.jonashubeny.dev/posts/jonasos-beginning/
- https://blog.jonashubeny.dev/posts/improving-defaults/

## What is currently included

- Debian live ISO build based on `live-build`
- XFCE desktop session with LightDM
- Basic desktop apps (for example Firefox ESR, Mousepad, Thunar, Xfce utilities)
- Networking and audio defaults (NetworkManager + PulseAudio packages)
- Shell defaults for new users via `/etc/skel` (`.bashrc`, `.profile`)

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
