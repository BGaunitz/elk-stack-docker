# ELK Stack Docker

This project bundles Kibana, ElasticSearch and Logstash using Docker. Nginx is used as a gateway to the network. Kibana and ElasticSearch are secured by HTTP Basic Auth. Logstash is secured using client and server certificates.

## Project structure


## Getting started

1. Generate certificates
   * Run `generate-certs.sh`
2. Change HTTP Basic Authentication for Kibana and ElasticSearch
   * `nginx/conf/passwords/`
   * Default values are `kibana:kibana` and `elastic:elastic`

## Customization

- Rename `.env.sample` to `.env` to change public ports

   See https://docs.docker.com/compose/environment-variables/

## Resources
https://jamielinux.com/docs/openssl-certificate-authority/create-the-root-pair.html
https://www.digitalocean.com/community/tutorials/how-to-install-elasticsearch-logstash-and-kibana-elk-stack-on-ubuntu-14-04
