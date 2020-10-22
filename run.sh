#!/bin/sh
/etc/init.d/rsyslog restart
/etc/init.d/saslauthd start 
/etc/init.d/sendmail start 

# create some default user, cyrus is configured as admin in imapd.conf
echo 'cyrus' | saslpasswd2 -p -c cyrus && testsaslauthd -u cyrus -p cyrus 
echo 'bob' | saslpasswd2 -p -c bob && testsaslauthd -u bob -p bob 
echo 'alice' | saslpasswd2 -p -c alice && testsaslauthd -u alice -p alice 

./master/master
