#! /bin/bash -e

DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

COMMON_NAME=$(echo $SERVER_SUBJECT | grep '\/CN=[^\/]*' -o | sed -e 's/\/CN=//g')
REQUEST_SAN=$(echo $SERVER_SUBJECT | grep '\/subjectAltName=[^\/]*' -o | sed -e 's/\/subjectAltName=//g')

INDEX=0
IFS=';' read -ra ADDR <<< "$REQUEST_SAN"
for SAN_ENTRY in "${ADDR[@]}"; do
    SAN="$SAN$SAN_ENTRY\n"
    ((INDEX+=1))
done

SAN=$SAN$(printf "DNS.%s=%s\\\nDNS.%s=%s" $(($INDEX + 1)) "$COMMON_NAME" $(($INDEX + 2)) "www.$COMMON_NAME")
cp $DIR/openssl.cnf $DIR/openssl.current.cnf
find $DIR/openssl.current.cnf -type f -exec sed -i 's|#REPLACE_SAN|'"${SAN}"'|g' {} \;

#Server Cert
## Create Key
openssl genrsa -out $DIR/private/server.key 2048

## Create CSR with key
openssl req -config $DIR/openssl.current.cnf -key $DIR/private/server.key -new -sha256 -out $DIR/csr/server.csr -subj "$SERVER_SUBJECT"

## Create signed certificate
openssl ca -batch -config $DIR/openssl.current.cnf -extensions server_cert -days 3650 -notext -md sha256 -in $DIR/csr/server.csr -out $DIR/certs/server.crt -notext

## Logstash can only handle PKCS #8 format
## -> https://github.com/spujadas/elk-docker/issues/112
openssl pkcs8 -in $DIR/private/server.key -topk8 -nocrypt -out $DIR/private/server.p8

rm $DIR/openssl.current.cnf
