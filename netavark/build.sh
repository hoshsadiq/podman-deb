#!/bin/sh

set -eux

. /etc/os-release
. "$HOME/.cargo/env"

PKG_ROOT="$PWD/netavark_${APP_VERSION}-1_${ID}_${VERSION_ID}"

mkdir -p "$PKG_ROOT/usr/local/libexec/podman"

git clone --branch="v${APP_VERSION}" https://github.com/containers/netavark

make -C netavark "DESTDIR=$PKG_ROOT"
make -C netavark "DESTDIR=$PKG_ROOT" docs
make -C netavark "DESTDIR=$PKG_ROOT" install

mkdir -p "${PKG_ROOT}/DEBIAN"
envsubst < /repo/netavark/debian/control > "${PKG_ROOT}/DEBIAN/control"

(
  cd "$PKG_ROOT"
  find . -type d -name DEBIAN -prune -o -type d -name etc -prune -o -type f -printf '%P\n' | xargs md5sum > "${PKG_ROOT}/DEBIAN/md5sums"
)

dpkg-deb --build "${PKG_ROOT}"
cp -f *.deb /repo/packages
