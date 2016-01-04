FROM debian:jessie
MAINTAINER Justifiably <justifiably@ymail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN echo "deb http://www.deb-multimedia.org jessie main non-free" | tee -a /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y --force-yes \
    wget \
    perl5 supervisor \
    faad \
    faac \
    flac \
    lame \
    sox \
    wavpack && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ADD ./install.sh /install.sh
RUN sh /install.sh
    
RUN mkdir -p /var/log/supervisor

COPY ./etc/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

VOLUME ["/mnt/state","/mnt/music","/mnt/playlists"]

EXPOSE 3483 3483/udp 9000 9090 9005

CMD ["/usr/bin/supervisord"]

