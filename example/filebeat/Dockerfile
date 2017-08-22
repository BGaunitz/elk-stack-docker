FROM docker.elastic.co/beats/filebeat:5.5.1

USER root

RUN yum install openssl -y

COPY filebeat.yml /usr/share/filebeat/

COPY certs/*.key /etc/pki/tls/private/
COPY certs/*.crt /etc/pki/tls/certs/

RUN chmod go-w /usr/share/filebeat/filebeat.yml
RUN chown root /usr/share/filebeat/filebeat.yml
RUN usermod -aG adm filebeat
