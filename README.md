# cyrus-docker

This image contains a cyrus imap service with support for the jmap protocol.
It should be used only for development and testing purpose.

to build it you can run the following command : 

`docker build . -t cyrus-jmap`

to run it : 

`docker run -p 1080:80 -p 1143:143  cyrus-jmap`


Three users belong to the virtual test domain :

 * cyrus with 'cyrus' as a password, admin account
 * bob with 'bob' as a password
 * alice with 'alice' as a password

They can authenticate in imap but they don't have any mailbox.

To be able to be authenticated with jmap they need to have a mailbox.


You can create some mailboxes with some imap commands :

`telnet localhost 1143`

`A1 LOGIN bob bob`

`A2 CREATE INBOX`


You can then execute JMAP requests, for example to list the mailbox of 'bob'

```
curl -X POST \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    --user bob:bob \
    -d '{
    "using": [ "urn:ietf:params:jmap:core", "urn:ietf:params:jmap:mail" ],
    "methodCalls": [[ "Mailbox/get", { }, "c1" ]]
    }' \
    http://localhost:1080/jmap/
```