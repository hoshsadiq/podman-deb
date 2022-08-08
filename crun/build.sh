#!/bin/sh

set -eux

. /etc/os-release

PKG_ROOT="$PWD/crun_${APP_VERSION}-1_${ID}_${VERSION_ID}"

mkdir -p "${PKG_ROOT}/usr/local/bin"

git clone --branch="${APP_VERSION}" https://github.com/containers/crun.git
cd crun

./autogen.sh
./configure --prefix="$PKG_ROOT/usr/local"
make
make install
cd ..

mkdir -p "${PKG_ROOT}/DEBIAN"
envsubst < "/repo/crun/debian/control" > "${PKG_ROOT}/DEBIAN/control"
(
  cd "$PKG_ROOT"
  find . -type d -name DEBIAN -prune -o -type d -name etc -prune -o -type f -printf '%P\n' | xargs md5sum > "${PKG_ROOT}/DEBIAN/md5sums"
)

dpkg-deb --build "${PKG_ROOT}"
cp *.deb /repo/packages
