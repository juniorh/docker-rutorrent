FROM debian:8.4

# install gosu
ENV GOSU_VERSION 1.9
RUN set -x \
  && apt-get update && apt-get install -y --no-install-recommends ca-certificates wget && rm -rf /var/lib/apt/lists/* \
  && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
  && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
  && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" \
  && export GNUPGHOME="$(mktemp -d)" \
  && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
  && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
  && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
  && chmod +x /usr/local/bin/gosu \
  && gosu nobody true \
  && apt-get purge -y --auto-remove ca-certificates wget

RUN useradd nginx -ms /bin/bash -d /home/nginx -c nginx

# nginx repo
RUN set -x \
  && apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62 \
  && echo "deb http://nginx.org/packages/debian/ jessie nginx" >> /etc/apt/sources.list


RUN set -x \
  && apt-get update \
  && apt-get install -y wget nginx php5-fpm php5-geoip openssl rtorrent wget curl unzip unrar-free mediainfo libav-tools screen

# prepare rutorrent
RUN wget -O /tmp/rutorrent.tar.gz https://github.com/Novik/ruTorrent/archive/rutorrent.tar.gz
RUN wget -O /tmp/plugins.tar.gz https://github.com/Novik/ruTorrent/archive/plugins.tar.gz
RUN tar -xf /tmp/rutorrent.tar.gz -C /tmp
RUN tar -xf /tmp/plugins.tar.gz -C /tmp
RUN rm -r /tmp/rutorrent.tar.gz /tmp/plugins.tar.gz 
RUN mkdir -p /var/www
RUN mv /tmp/ruTorrent-rutorrent/3.6 /var/www/rutorrent

COPY nginx/ /etc/nginx/
RUN mkdir -p /etc/nginx/ssl 
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/server.key -out /etc/nginx/ssl/server.crt -subj "/C=ID/ST=Jakarta/O=Web Master" 

COPY config /config
RUN bash /config/copy-rutorrent-plugins.sh
RUN rm -r /tmp/ruTorrent-plugins /tmp/ruTorrent-rutorrent

COPY rutorrent/ /var/www/rutorrent/
COPY init.d/ /etc/init.d/
COPY rtorrent.rc /home/nginx/.rtorrent.rc
RUN chown -R nginx:nginx /home/nginx

RUN sed -i "s/www-data/nginx/g" /etc/php5/fpm/pool.d/www.conf

RUN mkdir -p /data/rtorrent/download/ /data/rtorrent/leeching /data/rtorrent/share /data/rtorrent/share/torrents
RUN chown -R nginx:nginx /data/rtorrent

EXPOSE 443 80 33101-33199
ENTRYPOINT ["/config/docker-entrypoint.sh"]
CMD ["rtorrent"]
