#!/bin/bash
ZSWAP_DEFAULT_GRUB_LINES=$(grep zswap /etc/default/grub | wc -l)
if [ "${ZSWAP_DEFAULT_GRUB_LINES}" -gt 0 ]; then
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    echo "!                                                                               !"
    echo "!  zswap install failed! PLEASE REMOVE zswap PARAMETERS FROM /etc/default/grub  !"
    echo "!                                                                               !"
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    exit 1
fi

apt install -y zstd
modprobe -v zstd
echo "zstd
zswap enabled=1 zpool=zsmalloc compressor=zstd
" > /usr/share/initramfs-tools/modules.d/23_armystice_zstd
update-grub