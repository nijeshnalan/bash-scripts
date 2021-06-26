#!/bin/bash

NUM=`df -h /vz | tail -1 | awk {'print $5'} | cut -d% -f1`

if [ $NUM -gt 95 ]

then

  /root/bin/compress >/dev/null 2>&1
  echo "Current Disk Usage on $HOSTNAME is $NUM. Needs manual Intervention" | /bin/mail -s "Backups Removed" info@grepitout.com
  
fi
