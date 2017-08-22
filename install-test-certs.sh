#! /bin/bash -e
CERT_DIR="cert-scripts"

mkdir -p /example/filebeat/certs
cp /certs/ca/ca.crt /example/filebeat/certs/
cp /certs/clients/filebeat1.* /example/filebeat/certs/