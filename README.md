# JonasOS

My personalised OS based on Debian. Learn more at: https://blog.jonashubeny.dev/posts/jonasos-beginning/

## Project structure

```text
JonasOS/
  README.md
  docs/
  packages/
    core.list.chroot
    xfce.list.chroot
  overlay/
    etc/skel/
    usr/local/bin/
  build/
    live-build/
      auto/
        config
  scripts/
    build_iso.sh
    run_vm.sh
  .github/
    workflows/
      ci.yml
```

## Build ISO

The build script runs Debian `live-build` inside a Podman container and writes the resulting ISO to `out/`.

```bash
chmod +x scripts/build_iso.sh
./scripts/build_iso.sh
```

Requirements on host:

- `podman`
- `sudo` access

After success, the ISO is available in:

```bash
out/*.iso
```

## Run VM after ISO build

Requirements on host:

- `qemu-system-x86_64`
- KVM support (`/dev/kvm`)

Run VM using the helper script:

```bash
chmod +x scripts/run_vm.sh
./scripts/run_vm.sh
```
