#!/bin/bash

set -e

build_dir="${1:-build}"

cp "$build_dir"/xi.iso user.iso
rm -f user.qcow2
qemu-img create -f qcow2 user.qcow2 8G

qemu-system-x86_64 \
  -bios OVMF.fd \
  -cpu host \
  -drive file=user.iso,format=raw \
  -drive file=user.qcow2 \
  -enable-kvm \
  -m 2048 \
  -vga virtio
