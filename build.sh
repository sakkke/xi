#!/bin/sh

set -e

if [ "$(id -u)" -ne 0 ]; then
  exec sudo "$0"
fi

setup_build() {
  mkdir -p build
  cd build
}

setup_rootfs() {
  rm -rf rootfs
  mkdir -p archives
  debootstrap --cache-dir="$PWD"/archives bullseye rootfs
  xargs -a ../packages chroot rootfs /usr/bin/env DEBIAN_FRONTEND=noninteractive /usr/bin/apt-get -qqy install
  chroot rootfs /usr/bin/apt-get clean
  rm -rf rootfs/var/lib/apt/lists/*
  cp -RT ../override/rootfs rootfs
  chroot rootfs /usr/sbin/useradd -mG sudo -s /bin/bash xi
  echo xi:xi | chroot rootfs /usr/sbin/chpasswd
  chroot rootfs /usr/bin/systemctl enable systemd-networkd.service
  chroot rootfs /usr/lib/systemd/systemd-sysv-install enable sddm
}

setup_filesystem_squashfs() {
  rm -f filesystem.squashfs
  mksquashfs rootfs filesystem.squashfs -comp zstd
}

setup_efi_img() {
  rm -f efi.img
  truncate -s 300M efi.img
  mkfs.fat -F 32 efi.img
}

setup_efi() {
  rm -rf efi
  mkdir efi
  mount efi.img efi
  cp -RT ../override/efi efi
  mkdir -p efi/EFI/BOOT efi/EFI/systemd
  cp rootfs/initrd.img rootfs/vmlinuz efi
  cp rootfs/usr/lib/systemd/boot/efi/systemd-bootx64.efi efi/EFI/BOOT/BOOTX64.EFI
  cp rootfs/usr/lib/systemd/boot/efi/systemd-bootx64.efi efi/EFI/systemd
  umount efi
}

setup_live() {
  rm -rf live
  mkdir live
  cp filesystem.squashfs live
}

setup_iso() {
  rm -rf iso
  mkdir iso
  cp -R live iso
  xorriso -as mkisofs -append_partition 2 0xef efi.img -o xi.iso iso
}

setup_build
setup_rootfs
setup_filesystem_squashfs
setup_efi_img
setup_efi
setup_live
setup_iso
