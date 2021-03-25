#!/usr/bin/env bash

shopt -s globstar

IMAGE_SIZE=4096
IMAGE_NAME="$(realpath takao.hdd)"
BUILD_DIR="$(realpath build)"
LIMINE="$(realpath limine)"

# Install limine
if ! [ -d limine ]; then
    git clone https://github.com/limine-bootloader/limine.git --depth=1 --branch=v2.0-branch-binary
fi

cat > config << EOF
TIMEOUT=5
:Takao
KERNEL_PATH=boot:///boot/takao
PROTOCOL=stivale2
EOF

dd if=/dev/zero bs=1M count=0 seek="$IMAGE_SIZE" of="$IMAGE_NAME"
parted -s "$IMAGE_NAME" mklabel msdos
parted -s "$IMAGE_NAME" mkpart primary 1 100%
echfs-utils -m -p0 "$IMAGE_NAME" quick-format 512
echfs-utils -m -p0 "$IMAGE_NAME" import config               boot/limine.cfg
echfs-utils -m -p0 "$IMAGE_NAME" import "$LIMINE"/limine.sys boot/limine.sys
rm config

cd "$BUILD_DIR"/system-root
ROOT_FILES="$(echo **)"
FILES_COUNTER=1
for i in $ROOT_FILES; do
    printf "\r\e[KFile $FILES_COUNTER ($i)"
    echo $((FILES_COUNTER++)) >/dev/null
    echfs-utils -m -p0 "$IMAGE_NAME" import "$i" "$i" &>/dev/null
done

"$LIMINE"/limine-install-linux-x86_64 "$IMAGE_NAME"
