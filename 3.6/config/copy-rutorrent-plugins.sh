#!/usr/bin/env bash

PLUGIN_DIR=/tmp/ruTorrent-plugins
RUTORRENT_VERSION=3.6
COPY_TO=/var/www/rutorrent/plugins

mkdir -p $COPY_TO

for PLUGIN_NAME in $(ls $PLUGIN_DIR); do
  if [ -d $PLUGIN_DIR/$PLUGIN_NAME/$RUTORRENT_VERSION ]; then
    mv $PLUGIN_DIR/$PLUGIN_NAME/$RUTORRENT_VERSION $COPY_TO/$PLUGIN_NAME
  fi
done

