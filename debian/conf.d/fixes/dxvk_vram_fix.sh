#!/bin/bash
VRAM_SIZE=$1
GAMEDIR=$2

echo "dxgi.maxDeviceMemory=${VRAM_SIZE}
dxgi.maxSharedMemory=${VRAM_SIZE}" > "${GAMEDIR}/dxvk.conf"