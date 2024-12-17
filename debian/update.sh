#!/bin/bash
SCRIPT_FILE=$(readlink -f ${BASH_SOURCE[0]})
SCRIPT_DIR=$(dirname ${SCRIPT_FILE})

# Constants
export CYCLERMAGIC_CONF_ROOT="${HOME}/.cyclermagic/settings"
export OS_NAME=$(uname -o | egrep -io "darwin|linux" | tr "[:upper:]" "[:lower:]")
export DIST_NAME=$(uname -v | egrep -io "darwin|debian" | tr "[:upper:]" "[:lower:]")
export ARCH_NAME=$(uname -m)

export SETTING_PREFIX_HELP=".help."
export SETTING_IS_VM="is_vm"

function add_setting() {
    setting_path=$1
    example_value=$2

    setting_file="${CYCLERMAGIC_CONF_ROOT}/${SETTING_PREFIX_HELP}$setting_path"
    if [ ! -f "$setting_file" ]; then
        echo "${example_value}" > "${CYCLERMAGIC_CONF_ROOT}/${SETTING_PREFIX_HELP}$setting_path"
    fi
}
function read_setting() {
    setting_path=$1
    example_value=$2
    value=$(cat "${CYCLERMAGIC_CONF_ROOT}/$setting_path")
    echo "$value"
}
function read_flag() {
    setting_path=$1
    example_value=$2
    value=$(cat "${CYCLERMAGIC_CONF_ROOT}/$setting_path")
    echo "$value"
}

# Setup settings
mkdir -p "${CYCLERMAGIC_CONF_ROOT}"
add_setting ${SETTING_IS_VM} "0"

# Script
IS_VM=$(read_setting ${SETTING_IS_VM})
if [ "${IS_VM}" -eq 1 ]; then
    ${SCRIPT_DIR}/${ARCH_NAME}-virtual.sh
else
    ${SCRIPT_DIR}/${ARCH_NAME}-physical.sh
fi

# Example flag:
#ND_PARENT=$(test -e "${CYCLERMAGIC_CONF_ROOT}/netdata/parent.enabled" && echo y)
#if [ "${ND_PARENT}" == "y" ] && [ "${ND_CHILD}" == "y" ]; then