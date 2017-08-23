FROM nginx:1.13.3

RUN apt-get update && apt-get install curl -y

RUN rm /etc/nginx/conf.d/*.*

COPY conf/nginx.conf /etc/nginx/
COPY conf/sites/ /etc/nginx/sites-enabled/
COPY conf/streams/ /etc/nginx/streams-enabled/
COPY conf/passwords/ /etc/nginx/conf.d/
