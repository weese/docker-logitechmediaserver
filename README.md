# Docker Container for Logitech Media Server

Docker image for Logitech Media Server (SqueezeCenter, SqueezeboxServer, SlimServer).

Runs as non-root user, installs useful dependencies, sets a locale,
exposes ports needed for various plugins and server discovery and
allows editing of config files like `convert.conf`.

Build:

```
docker build -t michaelatdocker/docker-logitechmediaserver .
```

Run:

```
docker run -d \
           --net="host" \
           --restart="always" \
           -p 9000:9000 \
           -p 9090:9090 \
           -p 3483:3483 \
           -v <local-state-dir>:/mnt/state \
           -v <audio-dir>:/mnt/music \
           -v <playlists-dir>:/mnt/playlists
           --name logitechmediaserver justifiably/logitechmediaserver
```

or:

```
docker-compose up -d
```

(see `docker-compose.yml` to add volumes)

See Github network for other authors (JingleManSweep, map7, joev000, justifiably).
