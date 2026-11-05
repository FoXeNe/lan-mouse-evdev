# Maintainer: FoXeNe <ffoxene@gmail.com>
# Based on the Arch [extra] lan-mouse PKGBUILD by Orhun Parmaksız.
# Builds lan-mouse with the raw evdev (uinput) emulation backend (upstream PR #465),
# so compositors that ignore virtual keyboards (niri #403) still see real key events.

pkgname=lan-mouse-evdev
_pkgname=lan-mouse
pkgver=0.11.0.r50.gf4a483d
_commit=f4a483d0fb7f4f5d820575008b2fafd6fd07f8b2
pkgrel=1
pkgdesc="Software KVM switch (lan-mouse) with evdev/uinput input emulation backend"
arch=('x86_64')
url="https://github.com/FoXeNe/lan-mouse"
license=("GPL-3.0-only")
depends=(
  'libadwaita'
  'gtk4'
  'libx11'
  'libxtst'
  'glib2'
  'libgcc'
  'hicolor-icon-theme'
)
optdepends=('firewalld: for the provided firewalld service definition')
makedepends=('cargo' 'desktop-file-utils' 'git')
provides=("$_pkgname=$pkgver")
conflicts=("$_pkgname")
source=("$_pkgname::git+$url.git#commit=$_commit"
        "70-lan-mouse-uinput.rules"
        "lan-mouse-uinput.conf")
sha256sums=('SKIP'
            'SKIP'
            'SKIP')
options=('!lto')

prepare() {
  cd "$_pkgname"
  cargo fetch --locked --target "$(rustc --print host-tuple)"
}

build() {
  cd "$_pkgname"
  cargo build --frozen --release --all-features
}

check() {
  cd "$_pkgname"
  cargo test --frozen --all-features
}

package() {
  cd "$_pkgname"

  desktop-file-install -m 644 --dir "$pkgdir/usr/share/applications/" "de.feschber.LanMouse.desktop"

  install -Dm0644 -t "$pkgdir/usr/share/icons/hicolor/scalable/apps" "$_pkgname-gtk/resources/de.feschber.LanMouse.svg"
  install -Dm0755 -t "$pkgdir/usr/bin/" "target/release/$_pkgname"
  install -Dm0644 -t "$pkgdir/usr/lib/systemd/user/" "service/$_pkgname.service"
  install -Dm0644 -t "$pkgdir/usr/lib/firewalld/services/" "firewall/$_pkgname.xml"

  # give the logged-in user access to /dev/uinput, load the module at boot
  install -Dm0644 "$srcdir/70-lan-mouse-uinput.rules" "$pkgdir/usr/lib/udev/rules.d/70-lan-mouse-uinput.rules"
  install -Dm0644 "$srcdir/lan-mouse-uinput.conf" "$pkgdir/usr/lib/modules-load.d/lan-mouse-uinput.conf"
}

# vim: ts=2 sw=2 et:
