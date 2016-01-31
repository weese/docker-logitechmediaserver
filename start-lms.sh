#!/bin/sh

GID=100
UID=819

# try to reuse existing host user and group id
if [ -d /var/lib/squeezeboxserver/prefs ]; then
   UID=$(stat -c %u /var/lib/squeezeboxserver/prefs)
   GID=$(stat -c %g /var/lib/squeezeboxserver/prefs)
fi

groupadd --gid $GID squeezeboxgroup
useradd --system --uid $UID --gid $GID -M -s /bin/false -d /usr/share/squeezeboxserver -G nogroup -c "Logitech Media Server user" squeezeboxserver
usermod -u $UID squeezeboxserver

if [ ! -d /mnt/state/etc ]; then
   mkdir -p /mnt/state/etc
   cp -pr /etc/squeezeboxserver.orig/* /mnt/state/etc
fi

chown -R $UID:$GID /mnt/state
#chown $UID:$GID /mnt/playlists

/usr/bin/supervisord -c /etc/supervisord.conf
