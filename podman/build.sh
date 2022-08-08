#!/bin/sh

set -eux

. /etc/os-release

PKG_ROOT="$PWD/podman_${APP_VERSION}-1_${ID}_${VERSION_ID}"

mkdir -p "${PKG_ROOT}/usr/local/bin"

git clone --branch="v${APP_VERSION}" https://github.com/containers/podman/
cd podman

GO_VERSION="$(awk '$0 ~ /^go/ && $1 == "go" && $2 ~ /[0-9]+.[0-9]+/{print $2}' go.mod)"
curl -sL https://raw.githubusercontent.com/maxatome/install-go/v3.3/install-go.pl | perl - "$GO_VERSION" "/usr/local"
export GOPATH=/root/go
export GOROOT=/usr/local/go
export PATH="$PATH:/usr/local/go/bin"

make BUILDTAGS="seccomp apparmor systemd"
make DESTDIR="$PKG_ROOT" install
cd ..

mkdir -p "${PKG_ROOT}/etc/containers"
curl --silent --show-error --location --fail --output "${PKG_ROOT}/etc/containers/registries.conf" https://src.fedoraproject.org/rpms/containers-common/raw/main/f/registries.conf
curl --silent --show-error --location --fail --output "${PKG_ROOT}/etc/containers/policy.json" https://src.fedoraproject.org/rpms/containers-common/raw/main/f/default-policy.json

mkdir -p "${PKG_ROOT}/DEBIAN"
envsubst < /repo/podman/debian/control > "${PKG_ROOT}/DEBIAN/control"
cp /repo/podman/debian/conffiles "${PKG_ROOT}/DEBIAN/conffiles"
(
  cd "$PKG_ROOT"
  find . -type d -name DEBIAN -prune -o -type d -name etc -prune -o -type f -printf '%P\n' | xargs md5sum > "${PKG_ROOT}/DEBIAN/md5sums"
)

dpkg-deb --build "${PKG_ROOT}"
cp -f *.deb /repo/packages
