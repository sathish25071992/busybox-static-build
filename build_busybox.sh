#!/bin/bash

# Default BusyBox version
DEFAULT_VERSION=
VERSION="1.35.0"
DISTCLEAN=0
DEFCONFIG=0
MENUCONFIG=0

# Exit on errors
set -e

# Process options
while getopts ":cdv:m" opt; do
  case ${opt} in
    c )
      DISTCLEAN=1
      ;;
    d )
      DEFCONFIG=1
      ;;
    v )
      VERSION=$OPTARG
      ;;
    m )
      MENUCONFIG=1
      ;;
    \? )
      echo "Usage: cmd [-c] [-d] [-v version] [-m]"
      exit 1
      ;;
  esac
done

echo "Building BusyBox version $VERSION"

# Download BusyBox source code
cd /busybox/
if [ ! -d /busybox/busybox-${VERSION} ]; then
    wget -O busybox.tar.bz2 https://busybox.net/downloads/busybox-${VERSION}.tar.bz2
    tar -xjf busybox.tar.bz2
    rm busybox.tar.bz2
fi

cd busybox-${VERSION}

# Optionally clean previous builds
if [ "$DISTCLEAN" -eq 1 ]; then
    make distclean
fi

# Optionally create default configuration
if [ "$DEFCONFIG" -eq 1 ]; then
    make defconfig
    sed -i 's/# CONFIG_STATIC is not set/CONFIG_STATIC=y/' .config
fi

if [ "$MENUCONFIG" -eq 1 ]; then
    make menuconfig
    exit
fi

# Compile BusyBox
make CROSS_COMPILE=aarch64-linux-gnu-
make install CROSS_COMPILE=aarch64-linux-gnu-

# Assume /output directory is mounted and copy the _install content
cp -r _install/* /output/

/list_busybox_applets.sh > /output/command-list.txt

echo "BusyBox $VERSION build complete. Artifacts copied to /output/"
