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
zswap
" > /usr/share/initramfs-tools/modules.d/23_armystice_zstd
echo 'GRUB_CMDLINE_LINUX_DEFAULT="${GRUB_CMDLINE_LINUX_DEFAULT} zswap.enabled=1 zswap.zpool=zsmalloc zswap.compressor=zstd"
' > /etc/default/grub.d/armystice_zswap.cfg
update-grub