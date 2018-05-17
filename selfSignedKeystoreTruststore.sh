#!/bin/bash
cd /tmp
keytool -genkey -keystore server.keystore -dname "cn=localhost, ou=example, o=example, c=US" -storepass yourPassword -keypass yourPassword
keytool -export -file client.cer -keystore server.keystore -storepass yourPassword
keytool -import -trustcacerts -file client.cer -keystore server.truststore -storepass server.truststore -noprompt

## Move certs to proper dir
mv server* /path/
