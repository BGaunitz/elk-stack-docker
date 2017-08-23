FROM nginx:1.13.3

HEALTHCHECK --interval=10s --timeout=3s CMD /tmp/healthcheck.sh

RUN apt-get update && apt-get install curl -y

RUN rm /etc/nginx/conf.d/*.*

COPY conf/nginx.conf /etc/nginx/
COPY conf/sites/ /etc/nginx/sites-enabled/
COPY conf/streams/ /etc/nginx/streams-enabled/
COPY conf/passwords/ /etc/nginx/conf.d/

COPY healthcheck.sh /tmp/
