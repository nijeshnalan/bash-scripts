#!/bin/bash

# Nagios exit codes
STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3

# Get Disk names
DISK_NAMES=$(sudo lshw -class disk | grep "logical name:" | awk {'print $3'})

# Defining Variables
ERROR_COUNT=0

# Check the status of each disk
for DISK_NAME in $DISK_NAMES; do 

    # Get the value of Reallocated_Sector_Ct
    reallocated_sector_ct=$(sudo smartctl -A $DISK_NAME | grep -i 'reallocated_sector_ct' | awk '{print $10}')

    # Get the value of Media_Wearout_Indicator
    media_wearout_indicator=$(sudo smartctl -A $DISK_NAME | grep -i 'media_wearout_indicator' | awk '{print $4}')

    # Check if Reallocated_Sector_Ct is greater than or equal to 10
    if [ $reallocated_sector_ct -ge 10 ] ; then
        RESULT="[CRITICAL] $DISK_NAME - Reallocated_Sector_Ct is greater than 10\n$RESULT"
        let ERROR_COUNT++
    fi

    # Check if Media_Wearout_Indicator is less than or equal to 10
    if [ $media_wearout_indicator -le 10 ]; then
        RESULT="[CRITICAL] $DISK_NAME - Media_Wearout_Indicator is less than 10\n$RESULT"
        let ERROR_COUNT++
    fi

    # Get the OK output
    if [ $reallocated_sector_ct -lt 10 ] ; then
        RESULT="[OK] - $DISK_NAME - Reallocated_Sector_Ct is $reallocated_sector_ct\n$RESULT"
    fi

    if [ $media_wearout_indicator -gt 10 ] ; then
        RESULT="[OK] - $DISK_NAME - media_wearout_indicator is $media_wearout_indicator\n$RESULT"
    fi

done

# Setting Exit status and printing output
if [ $ERROR_COUNT -ne 0 ] ; then
    echo $RESULT
    exit $STATE_CRITICAL

else
    echo $RESULT
    exit $STATE_OK
fi

