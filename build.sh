#!/bin/bash

if [ ! -f /.dockerenv ]; then
    echo "Running outside docker!"
    exit 1
fi

set -eaux
cd /work
makepkg -src --noconfirm
echo "Installing the package"
sudo pacman -U --noconfirm lms-*.pkg.tar.zst
cat /etc/passwd
ls -ld /var/lib/lms
