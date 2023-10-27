FROM archlinux:latest
RUN pacman-key --init && pacman-key --populate archlinux
RUN pacman -Syyu --noconfirm && pacman -S --noconfirm base-devel pacman-contrib && rm -f /var/cache/pacman/pkg/*
RUN useradd -m build && echo "build ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/build
RUN echo 'MAKEFLAGS="-j$(nproc)"' >> /etc/makepkg.conf
ADD build.sh /build.sh
ADD update_version.sh /update_version.sh
