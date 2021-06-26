#!/bin/bash

NUM=`df -h / | tail -1 | awk {'print $5'} | cut -d% -f1`

if [ $NUM -gt 80 ]

then

  for i in `ls -lt /home/thefunstations.com/backup | tail -2`; do rm -rf /home/thefunstations.com/backup/$i ; done
  echo "Current Disk Usage on $HOSTNAME is $NUM. Needs manual Intervention" | /bin/mail -s "Backups Removed" info@grepitout.com

fi

