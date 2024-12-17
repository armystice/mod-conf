#!/bin/bash
MESA_ARCH=$(uname -m)
MESA_DIR="/usr/lib/mesa-diverted/${MESA_ARCH}-linux-gnu/"

# Resolves libEGL.so.1 etc being missing
if [ -d "${MESA_DIR}" ]; then
    ln -s ${MESA_DIR}/lib* /usr/lib
fi
