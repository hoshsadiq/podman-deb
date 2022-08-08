#!/bin/sh

set -eux

. /etc/os-release

PKG_ROOT="$PWD/aardvark-dns_${APP_VERSION}-1_${ID}_${VERSION_ID}"
mkdir -p "$PKG_ROOT/usr/local/libexec/podman"

git clone --branch="v${APP_VERSION}" https://github.com/containers/aardvark-dns
cd aardvark-dns

make DESTDIR="$PKG_ROOT"
make DESTDIR="$PKG_ROOT" install

cd ..
mkdir -p "${PKG_ROOT}/DEBIAN"
envsubst < /repo/aardvark-dns/debian/control > "${PKG_ROOT}/DEBIAN/control"
(
  cd "$PKG_ROOT"
  find . -type d -name DEBIAN -prune -o -type d -name etc -prune -o -type f -printf '%P\n' | xargs md5sum > "${PKG_ROOT}/DEBIAN/md5sums"
)

dpkg-deb --build "${PKG_ROOT}"
cp -f *.deb /repo/packages
