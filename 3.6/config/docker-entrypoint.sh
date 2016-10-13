#!/usr/bin/env bash
set -e

if [ "$1" = 'initdir' ]; then
  mkdir -p /data/rtorrent/download
  mkdir -p /data/rtorrent/leeching
  mkdir -p /data/rtorrent/share
  mkdir -p /data/rtorrent/share/torrents
  chown -R nginx:nginx /data/rtorrent/download
  chown -R nginx:nginx /data/rtorrent/leeching
  chown -R nginx:nginx /data/rtorrent/share
  chown -R nginx:nginx /data/rtorrent/share/torrents
  exit 0
fi

if [ "$1" = 'rtorrent' -a "$(id -u)" = '0' ]; then
  /etc/init.d/nginx start
  /etc/init.d/php5-fpm start
  set -- gosu nginx "$@"
fi

exec "$@"
