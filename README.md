# lan-mouse-evdev

Arch package of [lan-mouse](https://github.com/feschber/lan-mouse) built from
upstream PR #465 (raw evdev / uinput input emulation backend).

Why: niri ≤ 26.04 ignores keybindings from Wayland virtual keyboards
(niri #403), so `Mod+…` shortcuts don't work on the receiving machine.
With the evdev backend, lan-mouse injects input through `/dev/uinput`,
which niri treats like a real keyboard.

Source: <https://github.com/FoXeNe/lan-mouse> branch `evdev-emulation`.

## Install / update (each machine)

```sh
curl -fsSL https://raw.githubusercontent.com/FoXeNe/lan-mouse-evdev/main/install.sh | sh
```

It installs the latest release (replacing `lan-mouse` from extra), enables
`/dev/uinput` access and sets `emulation_backend = "evdev"` in
`~/.config/lan-mouse/config.toml`. Then just restart lan-mouse.

Install it on **both** machines: the branch is newer than 0.11.0 and
changes the network protocol slightly.

## New release

Bump `pkgver`/`_commit` in `PKGBUILD`, then:

```sh
git tag v<version> && git push --tags
```

GitHub Actions builds the package and attaches it to the release.

## Going back

When a niri release includes PR #4548: `sudo pacman -S lan-mouse`.
