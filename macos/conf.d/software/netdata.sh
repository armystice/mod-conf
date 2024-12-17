#!/bin/bash
SCRIPT_FILE=$(readlink -f ${BASH_SOURCE[0]})
SCRIPT_DIR=$(dirname ${SCRIPT_FILE})
CONF_MACHINE_ROOT=$(echo "${SCRIPT_DIR}" | egrep -o ".*/configure-machine/")

${CONF_MACHINE_ROOT}/bash/conf.d/software/netdata/install.sh