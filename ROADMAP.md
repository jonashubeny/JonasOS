# JonasOS — Roadmap

Status as of 2026-09-03. Working: live-build pipeline, Calamares installer,
Arc-Red theme, `jonasos` CLI. What's missing is the main thing — after boot
the system still identifies and looks like plain Debian.

Long term, JonasOS drops Debian entirely and is built from scratch on the
Linux kernel; see [§6](#6-long-term-from-scratch-base) and #27. Phases 0–5
apply to the current Debian-based `v0.x`.

---

## 0. Bugs to fix first

- [x] **`build/live-build/auto/config:6` sets `--architectures arm64`**, yet
      `out/live-image-amd64.hybrid.iso` is amd64 and its volume label reads
      `Debian bullseye`. Either the ISO doesn't match the config, or
      `lb config` inside the container ignores auto/config. Resolve this
      before layering anything else on top — otherwise it's unclear what is
      actually being built.
- [x] **`non-free-firmware` is missing** from archive-areas → Wi-Fi and
      AMD/NVIDIA graphics won't work on most laptops. Critical for real use.
- [ ] `config/includes.chroot/etc/skel/.bashrc:11` declares `HISTSIZE` twice;
      the second one should be `HISTFILESIZE`.

---

## 1. System identity

This is what makes the OS "mine". Recommended starting point.

- [ ] `/etc/os-release` → `NAME="JonasOS"`, `PRETTY_NAME`, `HOME_URL`,
      custom `VERSION` — new `config/hooks/normal/9010-branding.hook.chroot`
- [ ] `/etc/issue` and `/etc/motd` — same hook, branding on TTY
- [ ] `--iso-volume "JonasOS"`, `--iso-application`, `--iso-publisher`
      in `auto/config` so the ISO isn't labelled "Debian bullseye"
- [ ] `lb config --hostname jonasos --username jonas`
- [ ] **GRUB theme** (colors + logo in the boot menu) —
      `includes.binary/boot/grub/`. The very first thing a user sees.
- [ ] **Plymouth splash** — package + hook, boot without the wall of text

## 2. Desktop that doesn't look like bare XFCE

Right now only `xsettings.xml` and `xfwm4.xml` exist. Missing:

- [ ] **`xfce4-panel.xml`** — without it XFCE shows the
      "Default / One empty panel" dialog on first start. A custom panel
      layout instantly reads as a different OS.
- [ ] **`xfce4-desktop.xml` + custom wallpaper** in
      `usr/share/backgrounds/jonasos/`
- [ ] **LightDM greeter** — `lightdm-gtk-greeter.conf` with background,
      theme, logo
- [ ] **`xfce4-terminal.xml`** — color scheme matching Arc-Red
- [ ] **Icons** — currently `IconThemeName=gnome`, which is a fallback.
      Papirus-Red or a custom set.
- [ ] **`xfce4-keyboard-shortcuts.xml`** — shipped keyboard shortcuts

## 3. `jonasos` CLI as a real feature

Currently does `help / info / update / doctor / version`. To make it more
than a demo:

- [ ] `jonasos version` should read `/etc/os-release` instead of the
      hardcoded `VERSION="0.1.0"`
- [ ] `jonasos setup` — post-install wizard (language, app bundles, dotfiles)
- [ ] `jonasos install <bundle>` — predefined sets (`dev`, `media`, `office`)
- [ ] `jonasos theme <light|dark>` — switcher via `xfconf-query`
- [ ] `jonasos backup` — tarball of `~/.config` + package list
- [ ] bash completion in `/usr/share/bash-completion/completions/jonasos`

## 4. Welcome application

- [ ] First launch → GTK/YAD window: "Welcome to JonasOS", theme picker,
      install button, link to the blog. Mint and Zorin both do this, and
      it's exactly what separates "a distro" from "Debian with a theme".
      Wire it up to `jonasos setup`.

## 5. Infrastructure

- [ ] **CI** — the current workflow only checks that two files exist.
      Add `shellcheck` on the scripts plus validation that every package
      in package-lists actually exists in Debian.
- [ ] **Build the ISO in GitHub Actions** + automatic release with a
      checksum on tag → real, published versions
- [ ] **`VERSION` file + CHANGELOG** feeding both the branding and Calamares
- [ ] **Finish Calamares**: missing the `packages` module (remove the
      installer from the installed system), `displaymanager`, `removeuser`.
      Also `settings.conf:9` declares a `sources-final` instance that is
      not in the sequence and has no config file — dead code left over
      from commit `fd7cddf`.
- [ ] **Debian 13 Trixie** instead of bookworm — newer XFCE 4.20, longer
      support window

## 6. Long term: from-scratch base

Tracked in [#27](https://github.com/jonashubeny/JonasOS/issues/27). Replace
Debian with a system built from source on top of the Linux kernel, following
[LFS](https://www.linuxfromscratch.org/lfs/) /
[BLFS](https://www.linuxfromscratch.org/blfs/). Lives in a new `scratch/`
directory and runs in parallel with the Debian build until it reaches a desktop.

**Decisions first**
- [ ] libc: glibc vs. musl
- [ ] init: systemd vs. runit / s6 / OpenRC
- [ ] package management: none (immutable image), own minimal tool, or
      an existing one (`pacman`, `xbps`)
- [ ] build tooling: shell scripts vs. per-package Makefiles

**Milestone 1: boot to a shell in QEMU**
- [ ] Containerized build environment (Podman, like `scripts/build_iso.sh`)
- [ ] Cross toolchain script (binutils, GCC, libc)
- [ ] Kernel `.config` in the repo + build script
- [ ] Minimal rootfs (busybox is fine at first) + initramfs
- [ ] `scripts/run_scratch_vm.sh`

**Later**
- [ ] Full base system (coreutils, bash, util-linux, …) instead of busybox
- [ ] Bootloader + bootable ISO / disk image
- [ ] Xorg/Wayland + XFCE built from source
- [ ] Installer replacing Calamares
- [ ] Update mechanism

Carries over from the Debian version: branding, skel dotfiles, the `jonasos`
CLI, docs. Dropped: `build/live-build/`, Debian package lists, Calamares config.

---

## Suggested order

Start with **Phase 1**, specifically the trio of `os-release` + `iso-volume`
+ the arch bug. It's little work, but afterwards the system boots and
announces itself as JonasOS for the first time.
