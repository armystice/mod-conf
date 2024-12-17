#!/bin/bash
SCRIPT_FILE=$(readlink -f ${BASH_SOURCE[0]})
SCRIPT_DIR=$(dirname ${SCRIPT_FILE})

# Constants
export CYCLERMAGIC_CONF_ROOT="${HOME}/.cyclermagic/settings"
export OS_NAME=$(uname -o | egrep -io "darwin|linux" | tr "[:upper:]" "[:lower:]")
export DIST_NAME=$(uname -v | egrep -io "darwin|debian" | tr "[:upper:]" "[:lower:]")

# Setup settings
mkdir -p "${CYCLERMAGIC_CONF_ROOT}/netdata"
touch "${CYCLERMAGIC_CONF_ROOT}/netdata/.help.parent.enabled"
touch "${CYCLERMAGIC_CONF_ROOT}/netdata/.help.child.enabled"

# Install
if [ "${OS_NAME}" == "darwin" ]; then
    brew install netdata
    NETDATA_CONF_DIR="/opt/homebrew/etc/netdata/"
elif [ "${OS_NAME}" == "linux" ]; then
    wget -O /tmp/netdata-kickstart.sh https://get.netdata.cloud/kickstart.sh && sh /tmp/netdata-kickstart.sh --stable-channel --disable-telemetry
    NETDATA_CONF_DIR="/etc/netdata/"
fi

touch "${NETDATA_CONF_DIR}/.opt-out-from-anonymous-statistics"

ND_PARENT=$(test -e "${CYCLERMAGIC_CONF_ROOT}/netdata/parent.enabled" && echo y)
ND_CHILD=$(test -e "${CYCLERMAGIC_CONF_ROOT}/netdata/child.enabled" && echo y)

if [ "${ND_PARENT}" == "y" ] && [ "${ND_CHILD}" == "y" ]; then
    echo "        ! Choose must be either a parent or child, not both!"
fi
if [ "${ND_PARENT}" == "y" ]; then
    cp ${SCRIPT_DIR}/netdata.conf.parent ${NETDATA_CONF_DIR}/netdata.conf
    cp ${SCRIPT_DIR}/stream.conf.parent ${NETDATA_CONF_DIR}/stream.conf
fi
if [ "${ND_CHILD}" == "y" ]; then
    cp ${SCRIPT_DIR}/netdata.conf.child ${NETDATA_CONF_DIR}/netdata.conf
    cp ${SCRIPT_DIR}/stream.conf.child ${NETDATA_CONF_DIR}/stream.conf
fi

[ "${OS_NAME}" == "darwin" ] && brew services restart netdata
[ "${OS_NAME}" == "linux" ] && systemctl restart netdata
