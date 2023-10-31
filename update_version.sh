#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <version>"
    exit 1
fi

if [ ! -f /.dockerenv ]; then
    echo "Running outside docker!"
    exit 1
fi

set -eaux
cd /work
sed -i "s|^pkgver=.*|pkgver=$1|" PKGBUILD
sed -i "s|^pkgrel=.*|pkgrel=1|" PKGBUILD
updpkgsums
makepkg --printsrcinfo > .SRCINFO
