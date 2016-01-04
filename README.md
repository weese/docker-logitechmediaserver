# Docker Container for Logitech Media Server

Docker image for Logitech Media Server (SqueezeCenter, SqueezeboxServer, SlimServer)

Build
```
docker build -t justifiably/logitechmediaserver .
```


Run Directly:

```
docker run -d -p 9000:9000 -p 3483:3483 -v <local-state-dir>:/mnt/state -v <audio-dir>:/mnt/music --name logitechmediaserver justifiably/logitechmediaserver
```


See Github network for other authors.

