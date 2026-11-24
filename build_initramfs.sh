#!/bin/bash
set -e

WORK_DIR=$(pwd)
ROOTFS_DIR="$WORK_DIR/out_rootfs"

rm -rf "$ROOTFS_DIR"
mkdir -p "$ROOTFS_DIR"/{bin,sbin,etc,proc,sys,dev,tmp,mnt/root}

# Unduh prebuilt static BusyBox untuk aarch64 (cepat & bersih)
wget -q "https://busybox.net/downloads/binaries/1.35.0-x86_64-linux-musl/busybox" -O /tmp/bb_check || true
curl -L "https://raw.githubusercontent.com/EXALAB/Busybox-static/main/busybox_arm64" -o "$ROOTFS_DIR/bin/busybox"
chmod +x "$ROOTFS_DIR/bin/busybox"

# Salin skrip /init buatan kita dan beri izin eksekusi
cp "$WORK_DIR/rootfs/init" "$ROOTFS_DIR/init"
chmod +x "$ROOTFS_DIR/init"

# Bungkus menjadi arsip initramfs.cpio.gz
cd "$ROOTFS_DIR"
find . -print0 | cpio --null -ov --format=newc | gzip -9 > "$WORK_DIR/initramfs.cpio.gz"

echo "Initramfs berhasil dibuat: $(du -h $WORK_DIR/initramfs.cpio.gz)"
