#!/bin/sh

set -eux

. /etc/os-release

PKG_ROOT="$PWD/conmon_${APP_VERSION}-1_${ID}_${VERSION_ID}"

mkdir -p "$PKG_ROOT/usr/local/libexec/podman"

git clone --branch="v${APP_VERSION}" https://github.com/containers/conmon.git
cd conmon

GO_VERSION="$(awk '$0 ~ /^go/ && $1 == "go" && $2 ~ /[0-9]+.[0-9]+/{print $2}' go.mod)"
curl -sL https://raw.githubusercontent.com/maxatome/install-go/v3.3/install-go.pl | perl - "$GO_VERSION" "/usr/local"
export GOPATH=/root/go
export GOROOT=/usr/local/go
export PATH="$PATH:/usr/local/go/bin"

make DESTDIR="$PKG_ROOT" podman

cd ..
mkdir -p "${PKG_ROOT}/DEBIAN"
envsubst < /repo/conmon/debian/control > "${PKG_ROOT}/DEBIAN/control"
(
  cd "$PKG_ROOT"
  find . -type d -name DEBIAN -prune -o -type d -name etc -prune -o -type f -printf '%P\n' | xargs md5sum > "${PKG_ROOT}/DEBIAN/md5sums"
)

dpkg-deb --build "${PKG_ROOT}"
cp -f *.deb /repo/packages
