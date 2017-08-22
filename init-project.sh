#! /bin/bash -e
CERT_DIR="cert-scripts"

mv ca.csr.conf.sample ca.csr.conf
mv server.csr.conf.sample server.csr.conf
mv clients.csr.conf.sample clients.csr.conf
mkdir -p $CERT_DIR/private
mkdir -p $CERT_DIR/newcerts
mkdir -p $CERT_DIR/certs
mkdir -p $CERT_DIR/csr
touch $CERT_DIR/index.txt