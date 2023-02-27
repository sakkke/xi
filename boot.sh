#/bin/sh

set -e

qemu-system-x86_64 -bios OVMF.fd -enable-kvm -drive file=user.qcow2 -cpu host -m 2048 -vga virtio
