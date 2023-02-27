#/bin/sh

set -e

qemu-system-x86_64 \
  -bios OVMF.fd \
  -cpu host \
  -drive file=user.qcow2 \
  -enable-kvm \
  -m 2048 \
  -vga virtio
