FROM nginx:alpine

ENV FCGI_SOCKET=/var/run/fcgiwrap.sock
ENV FCGI_PROGRAM=/usr/sbin/fcgiwrap
ENV FCGI_USER=nginx
ENV FCGI_GROUP=www-data
ENV FCGI_EXTRA_OPTIONS="-M 0700"
ENV ALLOWED_ENV="PATH"

RUN apk add git-daemon fcgiwrap spawn-fcgi

RUN mkdir -p /var/www/htdocs/git \
    && chmod 700 /var/www/htdocs/git \
    && chown nginx:www-data /var/www/htdocs/git

WORKDIR /var/www/htdocs/git

COPY spawn-fcgi.sh /docker-entrypoint.d/
RUN chmod 770 /docker-entrypoint.d/spawn-fcgi.sh

COPY git-init.sh /usr/local/bin/git-init
RUN chmod 755 /usr/local/bin/git-init

COPY nginx.conf /etc/nginx/conf.d/default.conf
