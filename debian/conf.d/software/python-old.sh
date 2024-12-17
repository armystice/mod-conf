#!/bin/bash
# Run as root!
VERSION=$1
if [ -z "${VERSION}" ]; then
    echo "0/ VERSION not set"
    exit 1
fi

PYTHON_DIR=Python-${VERSION}
PYTHON_TAR=${PYTHON_DIR}.tgz

cd ~/Downloads
wget https://www.python.org/ftp/python/${VERSION}/${PYTHON_TAR}

tar -xvf ${PYTHON_TAR}
cd ${PYTHON_DIR}
./configure --enable-optimizations
make -j 2
make altinstall
