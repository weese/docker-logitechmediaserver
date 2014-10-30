FROM ubuntu:precise
MAINTAINER Koert Zeilstra <koert.zeilstra@zencode.nl>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y wget perl supervisor
RUN wget http://downloads.slimdevices.com/LogitechMediaServer_v7.7.3/logitechmediaserver_7.7.3_all.deb --output-document=server.deb && \
    dpkg -i server.deb && \
    rm server.deb
RUN apt-get remove -y wget
RUN apt-get autoremove -y
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN echo "Europe/Amsterdam" > /etc/timezone
RUN dpkg-reconfigure tzdata

RUN mkdir -p /var/log/supervisor

COPY ./etc/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

VOLUME ["/mnt/state"]
EXPOSE 3483 9000 9090

CMD ["/usr/bin/supervisord"]

