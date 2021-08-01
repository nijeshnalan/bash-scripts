#/bin/bash
#for i in `postqueue -p | grep MAILER-DAEMON | awk {'print $1'}` ; do postsuper -d $i ; done
NUM=`find /var/spool/postfix/deferred -type f | wc -l`
if [ $NUM -gt 25 ]
then echo "Current Email Queue size is $NUM" | /bin/mail -s "Email Queue Critical on $HOSTNAME nijesh@grepitout.com
/usr/sbin/postsuper -d ALL
fi
