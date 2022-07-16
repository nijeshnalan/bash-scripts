#!/bin/bash

# Author: Nijesh V N
# version 1.0

# Script for checking stopped VM count in OpenVZ node

STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3

exitcode=$STATE_UNKNOWN

while getopts w:c:dv options; do
  case $options in
       w) warningCount=$OPTARG;;
       c) criticalCount=$OPTARG;;
       d) echo `/usr/bin/sudo /usr/sbin/vzlist -S | awk {'print $4'}`;;
       v) echo "Stopped VM Count v1.0.0"
                exit $STATE_OK;;
       *) echo "Invalid Option $OPTARG"
                exit $STATE_UNKNOWN;;
  esac

done

# Defining variables (Stopped VM Count and regex for integer checking)

ACTUAL_NUM=$(($(/usr/bin/sudo /usr/sbin/vzlist -S | wc -l)-1))
re='^[0-9]+$'

# Validating the inputs are integer or not

if ! [[ $warningCount =~ $re && $criticalCount =~ $re ]]

  then
    echo "[UNKNOWN] Not a valid input!"
    exitcode=$STATE_UNKNOWN

else

# Comparing the Value given for critical and warning

  if [ $warningCount -gt $criticalCount ]

    then
      echo "[UNKNOWN] critical value should be greater than warning value!"
      exitcode=$STATE_UNKNOWN

  else

# Comparing the stopped VM count with warning and critical values

    if [ $ACTUAL_NUM -gt $warningCount ] && [ $ACTUAL_NUM -le $criticalCount ]
      then
        echo "[WARNING] Stopped VM COUNT: $ACTUAL_NUM"
	exitcode=$STATE_WARNING

    elif [ $ACTUAL_NUM -gt $criticalCount ] 
      then
	echo "[CRITICAL] Stopped VM COUNT: $ACTUAL_NUM"
	exitcode=$STATE_CRITICAL

    else
	echo "[OK] Stopped VM COUNT: $ACTUAL_NUM"
	exitcode=$STATE_OK

    fi

  fi      

fi

exit $exitcode
