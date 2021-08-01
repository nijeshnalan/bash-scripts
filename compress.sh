#!/bin/bash

export PATH=/usr/lib64/qt-3.3/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin

NUM=`df -h /vz | tail -1 | awk {'print $5'} | cut -d% -f1`

if [ $NUM -gt 95 ]
then

  /usr/sbin/vzlist -a | awk '{print $1}' | sed '/CTID/d' > /usr/local/hbh_linux/tmp/ctid.txt
  echo "Compact started on $(date)" >> /var/log/compact.log
  for i in `cat /usr/local/hbh_linux/tmp/ctid.txt`
  do
  /usr/sbin/prl_disk_tool compact --hdd /vz/private/$i/root.hdd
  done
  echo "Compact finished on $(date)" >> /var/log/compact.log

fi
