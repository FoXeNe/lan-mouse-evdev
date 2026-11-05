#!/bin/sh
# Install the latest lan-mouse-evdev package from GitHub Releases
# and switch lan-mouse to the evdev emulation backend.
set -eu

repo=FoXeNe/lan-mouse-evdev
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

url=$(curl -fsSL "https://api.github.com/repos/$repo/releases/latest" \
  | grep -o '"browser_download_url": *"[^"]*\.pkg\.tar\.zst"' \
  | head -n1 | sed 's/.*"\(https[^"]*\)"/\1/')
[ -n "$url" ] || { echo "no package found in latest release of $repo" >&2; exit 1; }

echo "Downloading $url"
curl -fL -o "$tmp/${url##*/}" "$url"
sudo pacman -U "$tmp/${url##*/}" </dev/tty

# Load uinput and apply the udev rule right away (no reboot needed)
sudo modprobe uinput
sudo udevadm control --reload
sudo udevadm trigger --name-match=uinput || true

# Set emulation_backend = "evdev" (top-level key must come before any [table])
cfg="${XDG_CONFIG_HOME:-$HOME/.config}/lan-mouse/config.toml"
mkdir -p "$(dirname "$cfg")"
touch "$cfg"
if grep -q '^[[:space:]]*emulation_backend' "$cfg"; then
  sed -i 's/^[[:space:]]*emulation_backend.*/emulation_backend = "evdev"/' "$cfg"
else
  { echo 'emulation_backend = "evdev"'; cat "$cfg"; } > "$cfg.new" && mv "$cfg.new" "$cfg"
fi
echo "Config: $cfg -> emulation_backend = \"evdev\""
echo "Done. Restart lan-mouse."
