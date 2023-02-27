#/bin/sh

set -e

qemu-system-x86_64 -bios OVMF.fd -enable-kvm -cpu host -m 2048 -vga virtio user.qcow2
