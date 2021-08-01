#!/bin/bash
# Created by Nijesh
# Just to keep the correct hostname [Hostname changes on every reboot]

HOST="`cat /etc/hostname`"

if [ $HOST != "mars.happybeehost.com" ] ; then
/usr/bin/hostnamectl set-hostname mars.happybeehost.com
fi
