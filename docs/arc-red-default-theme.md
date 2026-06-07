# Setting Arc-Red as the Default Theme in the ISO

This guide explains how to make the JonasOS image boot with **Arc-Red** as the default XFCE theme.

## What Arc-Red is

`Arc-Red` is a **GTK and window manager theme**. It affects:

- application widget styling
- window borders and title bars
- general XFCE appearance

It is **not** the same as an icon theme. XFCE uses a separate setting for icons.

## What is already included

The theme files are already present in the image source under:

```text
build/live-build/config/includes.chroot/usr/share/Arc-Red-theme/
```

That means the theme is already copied into the ISO build. You only need to set the default XFCE configuration.

## Step 1: Set the default GTK theme

Edit or create this file:

```text
build/live-build/config/includes.chroot/etc/xdg/xfce4/xconf/xfce-perchannel-xml/xsettings.xml
```

Use this content:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xsettings" version="1.0">
  <property name="Net" type="empty">
    <property name="ThemeName" type="string" value="Arc-Red"/>
    <property name="IconThemeName" type="string" value="gnome"/>
  </property>
  <property name="Gtk" type="empty">
    <property name="CursorThemeName" type="string" value="DMZ-Black"/>
  </property>
</channel>
```

### What this does

- `ThemeName` sets the default GTK theme to `Arc-Red`
- `IconThemeName` sets the icon theme
- `CursorThemeName` sets the mouse cursor theme

## Step 2: Set the XFWM4 window theme

If you want the window borders and title bar style to match, add:

```text
build/live-build/config/includes.chroot/etc/xdg/xfce4/xconf/xfce-perchannel-xml/xfwm4.xml
```

with this content:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfwm4" version="1.0">
  <property name="general" type="empty">
    <property name="theme" type="string" value="Arc-Red"/>
  </property>
</channel>
```

### What this does

- `theme` sets the default XFWM4 window decoration theme

## Step 3: Make sure the icon theme exists

`Arc-Red` is not an icon theme. If you keep:

```xml
<property name="IconThemeName" type="string" value="gnome"/>
```

XFCE will use the GNOME/Adwaita-style icons instead.

If you want a different icon set, it must be:

1. installed in the image
2. referenced by its exact icon theme name

Examples:

- `gnome`
- `Adwaita`
- `Papirus-Dark`

## Step 4: Rebuild the ISO

Use the existing build script:

```bash
./scripts/build_iso.sh
```

This script runs `lb clean`, `lb config`, and `lb build`, then copies the resulting ISO into `out/`.

## Summary

- `Arc-Red` controls GTK and window styling
- `xsettings.xml` controls the default XFCE GTK theme, icons, and cursors
- `xfwm4.xml` controls the default window decoration theme
- icon themes are separate from GTK themes
