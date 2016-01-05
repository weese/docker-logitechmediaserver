#!/bin/sh
if [ ! -d /mnt/state/etc ]; then
   mkdir -p /mnt/state/etc
   cp -pr /etc/squeezeboxserver.orig/* /mnt/state/etc
   chown -R squeezeboxserver.nogroup /mnt/state/etc
fi
chown squeezeboxserver.nogroup /mnt/state /mnt/playlists
/usr/bin/supervisord -c /etc/supervisord.conf
