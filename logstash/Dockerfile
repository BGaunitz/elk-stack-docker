FROM docker.elastic.co/logstash/logstash:5.5.1

USER root

# Install nc for healthchecking
RUN yum -y install nc

USER logstash

# Remove default config
RUN rm -f /usr/share/logstash/pipeline/logstash.conf

COPY conf/*.conf /usr/share/logstash/pipeline/
COPY conf/patterns/ /usr/share/logstash/patterns/

COPY certs/*.p8 /etc/pki/tls/private/
COPY certs/*.crt /etc/pki/tls/certs/
