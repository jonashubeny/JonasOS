# JonasOS — plán dalších kroků

Stav k 3. 9. 2026. Funguje: live-build pipeline, Calamares instalátor,
Arc-Red téma, `jonasos` CLI. Chybí to hlavní — po bootu se systém pořád
hlásí a vypadá jako Debian.

---

## 0. Bugy k opravě hned

- [ ] **`build/live-build/auto/config:6` má `--architectures arm64`**, ale
      `out/live-image-amd64.hybrid.iso` je amd64 a volume label hlásí
      `Debian bullseye`. Buď ISO neodpovídá configu, nebo `lb config`
      v kontejneru auto/config ignoruje. Rozseknout dřív, než se na to
      začne cokoliv vrstvit — jinak není jasné, co se vlastně staví.
- [ ] **Chybí `non-free-firmware`** v archive-areas → na většině notebooků
      nepojede Wi-Fi ani grafika AMD/NVIDIA. Pro reálné použití zásadní.
- [ ] `config/includes.chroot/etc/skel/.bashrc:11` má dvakrát `HISTSIZE`,
      druhý má být `HISTFILESIZE`.

---

## 1. Identita systému

Tohle je to, co dělá OS "můj". Doporučený start.

- [ ] `/etc/os-release` → `NAME="JonasOS"`, `PRETTY_NAME`, `HOME_URL`,
      vlastní `VERSION` — nový `config/hooks/normal/9010-branding.hook.chroot`
- [ ] `/etc/issue` a `/etc/motd` — stejný hook, branding v TTY
- [ ] `--iso-volume "JonasOS"`, `--iso-application`, `--iso-publisher`
      v `auto/config`, aby se ISO nejmenovalo "Debian bullseye"
- [ ] `lb config --hostname jonasos --username jonas`
- [ ] **GRUB téma** (barvy + logo v boot menu) — `includes.binary/boot/grub/`.
      První věc, kterou uživatel vidí.
- [ ] **Plymouth splash** — balíček + hook, boot bez textové stěny

## 2. Desktop, aby nevypadal jako holý XFCE

Aktuálně existuje jen `xsettings.xml` a `xfwm4.xml`. Chybí:

- [ ] **`xfce4-panel.xml`** — bez něj XFCE při prvním startu vyhodí dialog
      "Default / One empty panel". Vlastní layout panelu = okamžitě jiný OS.
- [ ] **`xfce4-desktop.xml` + vlastní tapeta** v `usr/share/backgrounds/jonasos/`
- [ ] **LightDM greeter** — `lightdm-gtk-greeter.conf` s pozadím, tématem, logem
- [ ] **`xfce4-terminal.xml`** — barevné schéma ladící s Arc-Red
- [ ] **Ikony** — teď je `IconThemeName=gnome`, což je fallback.
      Papirus-Red nebo vlastní sada.
- [ ] **`xfce4-keyboard-shortcuts.xml`** — klávesové zkratky napevno

## 3. `jonasos` CLI jako skutečná featura

Teď umí `help / info / update / doctor / version`. Aby to nebylo jen demo:

- [ ] `jonasos version` číst z `/etc/os-release` místo hardcoded `VERSION="0.1.0"`
- [ ] `jonasos setup` — post-install průvodce (jazyk, sady aplikací, dotfiles)
- [ ] `jonasos install <bundle>` — předdefinované sady (`dev`, `media`, `office`)
- [ ] `jonasos theme <light|dark>` — přepínač přes `xfconf-query`
- [ ] `jonasos backup` — tarball `~/.config` + seznam balíčků
- [ ] bash completion do `/usr/share/bash-completion/completions/jonasos`

## 4. Uvítací aplikace

- [ ] První spuštění → GTK/YAD okno: "Vítej v JonasOS", výběr témat,
      tlačítko instalace, odkaz na blog. Tohle dělá Mint i Zorin a je to
      přesně to, co odlišuje "distro" od "Debianu s tématem".
      Napojit na `jonasos setup`.

## 5. Infrastruktura

- [ ] **CI** — současný workflow jen testuje existenci dvou souborů.
      Přidat `shellcheck` na skripty + validaci, že každý balíček
      v package-lists reálně existuje v Debianu.
- [ ] **Build ISO v GitHub Actions** + automatický release s checksumem
      při tagu → skutečné vydávané verze
- [ ] **`VERSION` soubor + CHANGELOG**, ze kterého se plní branding
      i Calamares
- [ ] **Calamares dodělat**: chybí modul `packages` (odstranit instalátor
      z nainstalovaného systému), `displaymanager`, `removeuser`.
      Navíc `settings.conf:9` deklaruje instanci `sources-final`, která
      není v sequence a config k ní neexistuje — mrtvý kód po commitu `fd7cddf`.
- [ ] **Debian 13 Trixie** místo bookworm — novější XFCE 4.20, delší podpora

---

## Doporučené pořadí

Začít **Fází 1**, konkrétně trojicí `os-release` + `iso-volume` + arch bug.
Je to málo práce, ale poprvé po tom nabootuje něco, co se samo prohlásí
za JonasOS.
