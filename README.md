# cyrus-docker

This image contains a cyrus imap service.

Three users belong to the virtual test domain :

 * cyrus with 'cyrus' as a password, admin account
 * bob with 'bob' as a password
 * alice with 'alice' as a password

They can authenticate but they don't have any mailbox.

You can create some mailboxes with some imap commands :

```
* OK [CAPABILITY IMAP4rev1 LITERAL+ ID ENABLE AUTH=PLAIN SASL-IR] test Cyrus IMAP v2.4.17-caldav-beta10-Debian-2.4.17+caldav~beta10-18 server ready
. LOGIN cyrus cyrus
. OK [CAPABILITY IMAP4rev1 LITERAL+ ID ENABLE ACL RIGHTS=kxte QUOTA MAILBOX-REFERRALS NAMESPACE UIDPLUS NO_ATOMIC_RENAME UNSELECT CHILDREN MULTIAPPEND BINARY CATENATE CONDSTORE ESEARCH SORT SORT=MODSEQ SORT=DISPLAY THREAD=ORDEREDSUBJECT THREAD=REFERENCES ANNOTATEMORE LIST-EXTENDED WITHIN QRESYNC SCAN XLIST X-REPLICATION URLAUTH URLAUTH=BINARY LOGINDISABLED COMPRESS=DEFLATE IDLE] User logged in SESSIONID=<cyrus-18-1432282885-1>
A CREATE user.cyrus
A OK Completed
B CREATE user.bob
B OK Completed
C CREATE user.alice
C OK Completed
D LIST "" "*" 
* LIST (\HasNoChildren) "." INBOX
* LIST (\HasNoChildren) "." user.alice
* LIST (\HasNoChildren) "." user.bob
D OK Completed (0.000 secs 4 calls)
```

And then with alice :

```
* OK [CAPABILITY IMAP4rev1 LITERAL+ ID ENABLE AUTH=PLAIN SASL-IR] test Cyrus IMAP v2.4.17-caldav-beta10-Debian-2.4.17+caldav~beta10-18 server ready
. LOGIN alice alice
. OK [CAPABILITY IMAP4rev1 LITERAL+ ID ENABLE ACL RIGHTS=kxte QUOTA MAILBOX-REFERRALS NAMESPACE UIDPLUS NO_ATOMIC_RENAME UNSELECT CHILDREN MULTIAPPEND BINARY CATENATE CONDSTORE ESEARCH SORT SORT=MODSEQ SORT=DISPLAY THREAD=ORDEREDSUBJECT THREAD=REFERENCES ANNOTATEMORE LIST-EXTENDED WITHIN QRESYNC SCAN XLIST X-REPLICATION URLAUTH URLAUTH=BINARY LOGINDISABLED COMPRESS=DEFLATE IDLE] User logged in SESSIONID=<cyrus-18-1432282929-1>
A LIST "" "*"
* LIST (\HasNoChildren) "." INBOX
A OK Completed (0.000 secs 2 calls)
```
