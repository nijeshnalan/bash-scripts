#!/bin/bash

# Author: Nijesh V N
# version 1.0

# Script for checking partition errors

STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3

exitcode=$STATE_UNKNOWN

if [[ $# -ne 1 || $1 == "-h" ]]; then
    echo "Usage: ${0##*/} <partition list in quotes with "," as delimiter 'partition1,partition2'>" >&2
    exit $STATE_UNKNOWN
fi

OIFS=$IFS
IFS=','

partition_lists=$1

for partition in $partition_lists; do
  re="$partition$"
  realPartition=`df -h  | grep $re | awk {'print $1'}`

  status=$(tune2fs -l $realPartition | grep state | awk {'print $3'})
  exitStatus=$?

  if [[ "$status" == "clean" ]]; then
      result="[OK] Partition $partition is $status \n$result"
      exitcode=$STATE_OK

  elif [ $exitStatus -ne 0 ]; then
      result="[UNKNOWN] Failed to get filesystem state \n$result"
      exitcode=$STATE_UNKNOWN

  else
      result="[CRITICAL] Partition $partition is $status \n$result"
      exitcode=$STATE_CRITICAL

  fi

done

IFS=$OFS

echo -e $result
exit $exitcode
