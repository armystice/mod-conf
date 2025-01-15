#!/bin/bash
rpm-ostree install -y zstd
modprobe -v zstd
echo "zstd
zswap
" > /etc/modules-load.d/23_armystice_zstd.conf

rpm-ostree kargs --append-if-missing=zswap.enabled=1
rpm-ostree kargs --append-if-missing=zswap.zpool=zsmalloc
rpm-ostree kargs --append-if-missing=zswap.compressor=zstd