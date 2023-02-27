#!/bin/bash

set -e

build_dir="${1:-build}"

cp "$build_dir"/xi.iso user.iso
rm -f user.qcow2
qemu-img create -f qcow2 user.qcow2 8G
qemu-system-x86_64 -bios OVMF.fd -enable-kvm -cpu host -hdb user.qcow2 -m 2048 -vga virtio user.iso
