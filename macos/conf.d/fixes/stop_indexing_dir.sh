#!/bin/bash
DIR_PATH=$1
if [ -z "${DIR_PATH}" ] || [ ! -d "${DIR_PATH}" ]; then
    echo "Directory not specified or does not exist (${DISK_PATH})"
    exit 1
fi

touch ${DIR_PATH}/.metadata_never_index