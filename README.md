# Docker Container for Logitech Media Server

Docker image for Logitech Media Server (SqueezeCenter, SqueezeboxServer, SlimServer).

Runs as non-root user, installs useful dependencies, sets a locale,
exposes ports needed for various plugins and server discovery and
allows editing of config files like `convert.conf`.

Build:

```
docker build -t davomat/logitechmediaserver-shairport .
```

Run:

```
docker-compose up -d
```

(see `docker-compose.yml` to add volumes)

See Github network for other authors (JingleManSweep, map7, joev000, justifiably).
