#!/bin/sh
/etc/init.d/rsyslog restart
/etc/init.d/saslauthd start 
if grep MY_DOCKER_HOSTNAME /etc/mail/sendmail.mc ; then
  sed -i "s/MY_DOCKER_HOSTNAME/$HOSTNAME/" /etc/mail/sendmail.mc
  sendmailconfig
fi
if ! grep "\`$HOSTNAME'" /etc/mail/sendmail.mc ; then
  echo "WARNING: you probably have changed the HOSTNAME since the first start of this image, try to exec the following commands:"
  echo '      sed -i "s/MY_DOCKER_HOSTNAME/$HOSTNAME/" /etc/mail/sendmail.mc'
  echo '      sendmailconfig'
fi
/etc/init.d/sendmail start 

# create some default user, cyrus is configured as admin in imapd.conf
echo 'cyrus' | saslpasswd2 -p -c cyrus && testsaslauthd -u cyrus -p cyrus 
echo 'bob' | saslpasswd2 -p -c bob && testsaslauthd -u bob -p bob 
echo 'alice' | saslpasswd2 -p -c alice && testsaslauthd -u alice -p alice 

./master/master
