#! /bin/bash -e
#https://security.stackexchange.com/questions/74345/provide-subjectaltname-to-openssl-directly-on-command-line
#subjectAltName=DNS.1=localhost

DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
COMMON_NAME=$(echo $CLIENT_SUBJECT | grep '\/CN=[^\/]*' -o | sed -e 's/\/CN=//g')

REQUEST_SAN=$(echo $CLIENT_SUBJECT | grep '\/subjectAltName=[^\/]*' -o | sed -e 's/\/subjectAltName=//g')

INDEX=0
IFS=';' read -ra ADDR <<< "$REQUEST_SAN"
for SAN_ENTRY in "${ADDR[@]}"; do
    SAN="$SAN$SAN_ENTRY\n"
    ((INDEX+=1))
done

SAN=$SAN$(printf "DNS.%s=%s\\\nDNS.%s=%s" $(($INDEX + 1)) "$COMMON_NAME" $(($INDEX + 2)) "www.$COMMON_NAME")
echo $SAN
cp $DIR/openssl.cnf $DIR/openssl.current.cnf
find $DIR/openssl.current.cnf -type f -exec sed -i 's|#REPLACE_SAN|'"${SAN}"'|g' {} \;

#Client Cert
##Create Key
openssl genrsa -out $DIR/private/client.key 2048
## Create CSR with key
openssl req -config $DIR/openssl.current.cnf -key $DIR/private/client.key -new -sha256 -out $DIR/csr/client.csr -subj "$CLIENT_SUBJECT"
## Create signed certificate
openssl ca -batch -config $DIR/openssl.current.cnf -extensions usr_cert -days 3650 -notext -md sha256 -in $DIR/csr/client.csr -out $DIR/certs/client.crt -notext

rm $DIR/openssl.current.cnf
