#!/bin/sh
/etc/init.d/rsyslog restart
/etc/init.d/saslauthd start

/etc/init.d/sendmail start
./master/master