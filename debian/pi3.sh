#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
set -x

SCRIPT_FILE=$(readlink -f ${BASH_SOURCE[0]})
SCRIPT_DIR=$(dirname ${SCRIPT_FILE})

CONF_D_ROOT="${SCRIPT_DIR}/conf.d"

source "${CONF_D_ROOT}/_default.sh"
source "${CONF_D_ROOT}/security/low-spec.sh"
echo "=== DONE ==="