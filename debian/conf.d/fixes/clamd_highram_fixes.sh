#!/bin/bash
CLAMD_CONCDB_NO_SETTING="ConcurrentDatabaseReload no"
CLAMD_CONF_FILE=/etc/clamav/clamd.conf
CLAMD_CONCDB_NO=$(grep "${CLAMD_CONCDB_NO_SETTING}" ${CLAMD_CONF_FILE} | wc -l)
if [ "${CLAMD_CONCDB_NO}" -lt 1 ]; then
    echo "Adding RAM fix to ${CLAMD_CONF_FILE} (${CLAMD_CONCDB_NO_SETTING})"

    echo "${CLAMD_CONCDB_NO_SETTING}" >> ${CLAMD_CONF_FILE}
fi