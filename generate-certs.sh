#! /bin/bash -e
DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
CERT_DIR="cert-scripts"
LOGSTASH_DIR="logstash"
MODE=-1

usage() { printf  "Usage: $0\n -a Generate CA, server and client certificates\n -s Generate server certificate only\n -c Generate client certificates only\n" 1>&2; exit 1; }

getopts asc option
case $option in
  a) MODE=0
    echo "Generating CA, server and client certificates"
    ;;
  s) MODE=1
    echo "Generating server certificate..."
    ;;
  c) MODE=2
    echo "Generating client certificates"
    ;;
  *) usage
    ;;
esac

mkdir -p $CERT_DIR/private
mkdir -p $CERT_DIR/newcerts
mkdir -p $CERT_DIR/certs
mkdir -p $CERT_DIR/csr

cp $CERT_DIR/openssl.cnf.template $CERT_DIR/openssl.cnf
find $CERT_DIR/openssl.cnf -type f -exec sed -i 's|REPLACE_DIRECTORY|'"${DIR}"'\/'"${CERT_DIR}"'|g' {} \;

if [ $MODE -eq 0 ]
then
  echo "Generating CA"
  mkdir -p certs/ca

  cat ca.csr.conf | \
  while read CA; do
    export CA_SUBJECT="$CA"
    $CERT_DIR/generate-ca.sh
    echo "Copy CA key and certificate to certs/ca"

    cp $CERT_DIR/private/ca.key certs/ca/
    cp $CERT_DIR/certs/ca.crt certs/ca/

    mkdir -p $LOGSTASH_DIR/certs/
    cp certs/ca/ca.crt $LOGSTASH_DIR/certs/
  done
fi

if [ $MODE -eq 0 ] || [ $MODE -eq 1 ]
then
  echo "Generating Server Certificate"
  mkdir -p certs/server

  cat server.csr.conf | \
  while read SERVER; do
    export SERVER_SUBJECT="$SERVER"

    $CERT_DIR/generate-server.sh
    echo "Copy server key and certificate to certs/server"

    cp $CERT_DIR/private/server.* certs/server/
    cp $CERT_DIR/certs/server.crt certs/server/

    mkdir -p $LOGSTASH_DIR/certs/
    cp certs/server/* $LOGSTASH_DIR/certs/
  done
fi

if [ $MODE -eq 0 ] || [ $MODE -eq 2 ]
then
  echo "Generating Client Certificate"
  mkdir -p certs/clients

  cat clients.csr.conf | \
  while read CLIENT; do
    export CLIENT_SUBJECT="$CLIENT"

    $CERT_DIR/generate-client.sh
    CERT_FILE_NAME=$(echo $CLIENT | grep '\/CN=[^\/]*' -o | sed -e 's/\/CN=//g') #_$(date +"%Y-%m-%d_%H-%M-%S")


    cp $CERT_DIR/certs/client.crt certs/clients/$CERT_FILE_NAME.crt
    cp $CERT_DIR/private/client.key certs/clients/$CERT_FILE_NAME.key
  done
fi
