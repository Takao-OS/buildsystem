#!/usr/bin/env bash

IMAGE_SIZE=4096
IMAGE_NAME="$(realpath takao.hdd)"
BUILD_DIR="$(realpath build)"
LIMINE_DIR="$(realpath limine)"
LIMINE=https://github.com/limine-bootloader/limine.git

# Install limine
if ! [ -d "$LIMINE_DIR" ]; then
    git clone "$LIMINE" "$LIMINE_DIR" --depth=1 --branch=v2.0-branch-binary
fi

dd if=/dev/zero bs=1M count=0 seek="$IMAGE_SIZE" of="$IMAGE_NAME"
parted -s "$IMAGE_NAME" mklabel msdos
parted -s "$IMAGE_NAME" mkpart primary 1 100%
echfs-utils -m -p0 "$IMAGE_NAME" quick-format 512
echfs-utils -m -p0 "$IMAGE_NAME" import config                   boot/limine.cfg
echfs-utils -m -p0 "$IMAGE_NAME" import "$LIMINE_DIR"/limine.sys boot/limine.sys
./copyfiles.sh root                     "$IMAGE_NAME" 0
./copyfiles.sh "$BUILD_DIR"/system-root "$IMAGE_NAME" 0
"$LIMINE_DIR"/limine-install-linux-x86_64 "$IMAGE_NAME"
