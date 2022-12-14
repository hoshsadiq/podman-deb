# podman-deb

Debian packages for up-to-date Podman releases. View the [releases](https://github.com/hoshsadiq/podman-deb/releases) to download the packages.

> **Warning**
> 
> This has been archived because I had a fundamental misunderstanding of the unstable repos provided @lsm5.
> Please use the [Kubic unstable repo for Podman and friends](https://software.opensuse.org//download.html?project=devel:kubic:libcontainers:unstable&package=podman), combined with the [Kubic repos for criu](https://software.opensuse.org//download.html?project=devel:tools:criu&package=criu).

## Usage
Install the .deb files found in the package registry. The easiest way:
```bash
wget https://github.com/hoshsadiq/podman-deb/releases/download/podman-4.1.1/podman_4.1.1-1_ubuntu_22.04.deb
wget https://github.com/hoshsadiq/podman-deb/releases/download/netavark-1.1.0/netavark_1.1.0-1_ubuntu_22.04.deb
wget https://github.com/hoshsadiq/podman-deb/releases/download/crun-1.5/crun_1.5-1_ubuntu_22.04.deb
wget https://github.com/hoshsadiq/podman-deb/releases/download/conmon-2.1.3/conmon_2.1.3-1_ubuntu_22.04.deb
wget https://github.com/hoshsadiq/podman-deb/releases/download/cni-plugins-1.1.1/cni-plugins_1.1.1-1_ubuntu_22.04.deb
wget https://github.com/hoshsadiq/podman-deb/releases/download/aardvark-dns-1.1.0/aardvark-dns_1.1.0-1_ubuntu_22.04.deb

sudo apt install ./*.deb
sudo apt install -f
```
