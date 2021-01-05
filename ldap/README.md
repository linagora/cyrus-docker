# cyrus-docker with ldap authentication

This image contains a cyrus imap service with support for the jmap protocol and with LDAP authentication.
It should be used only for development and testing purpose.

to build it you can run the following command : 

`docker build . -t cyrus-jmap`

to run it : 

`docker run -p 1080:80 -p 1143:143 -p 1025:25 --hostname cyrus.domain --name cyrus cyrus-jmap`

The hostname is important in particular for sendmail and must contain a dot, else sendmail will be very slow.

The default `saslauthd.conf` provide the authentication configuration to connect to the ldap within the
development docker-compose of open-paas.

To configure how to access your LDAP repository you should mount your `saslauthd.conf` file by adding
the following argument to the `docker run` command :

`-v myLocalDirectory/saslauthd.conf:/etc/saslauthd.conf`

The users found in the LDAP repository can authenticate in imap but they don't have any mailbox.

To be able to be authenticated with jmap they need to have a mailbox.


You can create some mailboxes with some imap commands :

`telnet localhost 1143`

`A1 LOGIN myUser myUserPassword`

`A2 CREATE INBOX`


You can then execute JMAP requests, for example to list the mailbox of 'myUser'

```
curl -X POST \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    --user myUser:myUserPassword \
    -d '{
    "using": [ "urn:ietf:params:jmap:core", "urn:ietf:params:jmap:mail" ],
    "methodCalls": [[ "Mailbox/get", { }, "c1" ]]
    }' \
    http://localhost:1080/jmap/
```

And to get the JMAP session

```
curl -X GET \
    -H "Content-Type: application/json" \
    --user myUser:myUserPassword \
    http://localhost:1080/jmap/
```