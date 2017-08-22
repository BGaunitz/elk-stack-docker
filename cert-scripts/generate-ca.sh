#! /bin/bash -e

# CA Key and Cert

## Get current directory
DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

## Create Key
openssl genrsa -out $DIR/private/ca.key 4096

## Create Certificate with key
openssl req \
  -config $DIR/openssl.cnf \
  -key $DIR/private/ca.key \
  -new -x509 -days 3650 -sha256 \
  -extensions v3_ca \
  -out $DIR/certs/ca.crt \
  -subj "$CA_SUBJECT"
