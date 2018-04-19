# Docker Container for Logitech Media Server

Docker image for Logitech Media Server (SqueezeCenter, SqueezeboxServer, SlimServer).

Runs as non-root user, installs useful dependencies, sets a locale,
exposes ports needed for various plugins and server discovery and
allows editing of config files like `convert.conf`.

Build:

```
docker build -t davomat/logitechmediaserver-shairport .
```

You have to disable the avahi daemon on the host system, as it might interfere with the one running in the Docker container. On Debian this can be done with:
```
chmod a-x /etc/init.d/avahi-daemon
```

Run:

```
sudo docker run -v /home/public:/home/public -v /var/lib/squeezeboxserver:/var/lib/squeezeboxserver -v /etc/avahi:/etc/avahi -p 9000:9000 -p 9090:9090 -p 3483:3483 -p 3483:3483/udp -p 9005:9005 -p 5353:5353/udp --net="host" --name logitechmediaserver davomat/logitechmediaserver-shairport
```

or

```
docker-compose up -d
```

(see `docker-compose.yml` to add volumes)

Install the ShairPort plugin:

- login to your Logitech Server
- go to Settings -> Plugins
- add plugin repository: http://raw.githubusercontent.com/StuartUSA/shairport_plugin/master/public.xml
- confirm restart of LMS
- activate installed plugin and wait for restart

See Github network for other authors (JingleManSweep, map7, joev000, justifiably).
