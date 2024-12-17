#!/bin/bash
PROTON_GE_VER=9-9
TMP_DIR=/tmp/proton-ge-custom
STEAM_COMPAT_TOOLS_DIR=~/.var/app/com.valvesoftware.Steam/data/Steam/compatibilitytools.d/

if [ -d "${STEAM_COMPAT_TOOLS_DIR}/GE-Proton${PROTON_GE_VER}" ]; then
    echo "Proton GE ${PROTON_GE_VER} already installed at ${STEAM_COMPAT_TOOLS_DIR}"
    exit 0
fi

rm -rf "${TMP_DIR}"; mkdir -p "${TMP_DIR}"
cd "${TMP_DIR}"
if [ $? -ne 0 ]; then
    echo "Failed: Unable to create or access temporary directory ${TMP_DIR}"
    exit 1
fi

wget "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton${PROTON_GE_VER}/GE-Proton${PROTON_GE_VER}.tar.gz"

mkdir -p "${STEAM_COMPAT_TOOLS_DIR}"
cd "${STEAM_COMPAT_TOOLS_DIR}"
if [ $? -ne 0 ]; then
    echo "Failed: Unable to create or access Steam Compat Tools directory ${STEAM_COMPAT_TOOLS_DIR}"
    exit 1
fi

tar -xf "${TMP_DIR}/GE-Proton${PROTON_GE_VER}.tar.gz" -C "${STEAM_COMPAT_TOOLS_DIR}"
if [ $? -ne 0 ]; then
    echo "Failed: Could not extract Proton GE"
    exit 1
fi

echo "Success: Please restart Steam"