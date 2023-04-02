#!/bin/bash

# Nagios exit codes
STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3

# Get list of RAID device names
RAID_DEVICES=$(cat /etc/mdadm.conf  | grep ARRAY | awk '{print $2}')

# Defining Variables
DEGRADED_COUNTER=0
FAILED_COUNTER=0
MISSING_COUNTER=0
SYNCING_COUNTER=0
CLEAN_COUNTER=0
ACTIVE_COUNTER=0

for RAID_DEVICE in $RAID_DEVICES; do

    # Check if the RAID array is running in degraded mode
    DEGRADED=$(sudo mdadm --detail $RAID_DEVICE | grep "State :" | grep -c "degraded")

        if [ $DEGRADED -ne 0 ]; then
            RAID_DATA="[CRITICAL] RAID array $RAID_DEVICE is degraded\n$RAID_DATA"
            let DEGRADED_COUNTER++
        fi

    # Check if any disks have failed
    FAILED=$(sudo mdadm --detail $RAID_DEVICE | grep "State :" | grep -c "failed")

        if [ $FAILED -ne 0 ]; then
            RAID_DATA="[CRITICAL] $RAID_DEVICE has failed disks\n$RAID_DATA"
            let FAILED_COUNTER++
        fi

    # Check if any disks are missing
    MISSING=$(sudo mdadm --detail $RAID_DEVICE | grep "State :" | grep -c "missing")

        if [ $MISSING -ne 0 ]; then
            RAID_DATA="[CRITICAL] $RAID_DEVICE has missing disks\n$RAID_DATA"
            let MISSING_COUNTER++
        fi

    # Check if any disks are syncing
    SYNCING=$(sudo mdadm --detail $RAID_DEVICE | grep "State :" | grep -c "resync")

        if [ $SYNCING -ne 0 ]; then
            RAID_DATA="[WARNING] $RAID_DEVICE is syncing\n$RAID_DATA"
            let SYNCING_COUNTER++
        fi

    # Check if the RAID array is clean
    CLEAN=$(sudo mdadm --detail $RAID_DEVICE | grep "State :" | grep -c "clean")

        if [ $CLEAN -ne 0 ] ; then
            RAID_DATA="[OK] $RAID_DEVICE is clean and active\n$RAID_DATA"
            let CLEAN_COUNTER++
        fi

    # Check if the RAID array is active
    ACTIVE=$(sudo mdadm --detail $RAID_DEVICE | grep "State :" | grep -c "active")

        if [ $ACTIVE -ne 0 ]; then
            RAID_DATA="[OK] $RAID_DEVICE is clean and active\n$RAID_DATA"
            let ACTIVE_COUNTER++
        fi

done

# Check the status of the RAID array
if [ $DEGRADED_COUNTER -ne 0 ]; then
  echo $RAID_DATA
  exit $STATE_CRITICAL

elif [ $FAILED_COUNTER -ne 0 ]; then
  echo $RAID_DATA
  exit $STATE_CRITICAL

elif [ $MISSING_COUNTER -ne 0 ]; then
  echo $RAID_DATA
  exit $STATE_CRITICAL

elif [ $SYNCING_COUNTER -ne 0 ]; then
  echo $RAID_DATA
  exit $STATE_WARNING

elif [ $CLEAN_COUNTER -ne 0 ] || [ $ACTIVE_COUNTER -ne 0 ]; then
  echo $RAID_DATA
  exit $STATE_OK

else
  echo "[UNKNOWN] Unknown status for RAID array"
  exit $STATE_UNKNOWN
fi