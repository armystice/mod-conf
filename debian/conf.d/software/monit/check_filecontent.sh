#!/bin/bash
# File value check. Checks for a literal value in a file
FILE_TO_CHECK="$1"
VALUE="$2"

if [ ! -f "${FILE_TO_CHECK}" ]; then
   exit 1
fi

FILE_CONTENTS=$(/usr/bin/cat $VALUE $FILE_TO_CHECK)
echo "${FILE_CONTENTS}"
if [ "${FILE_CONTENTS}" == "${VALUE}" ]; then
    exit 0
else
    exit 1
fi