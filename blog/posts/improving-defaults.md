---
title: Improving JonasOS
date: 2026-05-16
draft: false
---
# Improving JonasOS defaults

repository: https://github.com/jonashubeny/JonasOS

## My distro is booting!! (for now)
My first big progress was that I've written my own bash script for building ISOs using podman container and then I've created one more script for running this ISO in virtual machine. I've never written a single bash script so I used AI to learn this skill. I think I know basics of bash scripting so that's another win for me.

## Xfce desktop is working
My first ISO could only boot into a black terminal. Now after some days of trying, I finally installed **Xfce** and made the system boot into a real desktop!

This wasn't hard: I added `xfce4`, `lightdm`, and a few basic network packages to the package list, rebuilt the ISO (with my script ;)), and started it in QEMU. Now I see a panel, menu, window buttons... it feels much more like a "real system".

No custom theme yet, and it looks very default, but seeing Xfce start up was a great moment for me.

### What I changed

- **.profile**  
  I made a `.profile` file that sets some important variables:  
  - `EDITOR` is `nvim` (not nano!),  
  - `PAGER` for man pages,  
  - and it adds `~/.local/bin` to PATH for user scripts.
- **.bashrc**  
  I added useful aliases:  
  - `ll` for `ls -lah`,  
  - easy moving between directories with `..` and `...`,  
  - colored `grep`,  
  - some quick git commands (`gs`, `gd`, `gl`).  
  Also, I set a two-line prompt like Kali Linux:  
  ```
  (jonas@jonasos)-[~]
  └─$
  ```
  Plus, the shell history is longer and smarter, so commands are shared between open terminals.
- **/etc/skel**  
  All these configs go into the `overlay` folder in `/etc/skel`. This means every new user gets the configs right away—no copying needed.

## Why do this
JonasOS is my personal distro so I think it would be nice if the terminal would work the way I like, out of the box, so I don't need to manually set my favourite tools and shortcuts every time.

It feels more like JonasOS, and not just like another Debian spin.

## What's next?
- Make a `jonasos` command to show system info and some more fun stuff.
- Add my own wallpaper and maybe start work on icon theme.
- Maybe a welcome message for first boot?

Thanks for reading! If you want to follow JonasOS (or laugh at my struggle), check the repo: [JonasOS](https://github.com/jonashubeny/JonasOS)
