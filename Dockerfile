FROM debian:jessie
MAINTAINER Davomat <tre@gmx.de>

ENV DEBIAN_FRONTEND noninteractive

RUN echo "Europe/Berlin" > /etc/timezone && dpkg-reconfigure tzdata
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y curl

# Fetch latest 7.9 release
RUN curl -s "http://www.mysqueezebox.com/update/?version=7.9.0&revision=1&geturl=1&os=deb" | xargs curl -o /tmp/lms.deb 
#COPY ./logitechmediaserver_7.9.0~1447333834_all.deb /tmp/lms.deb

# Dependencies first
RUN echo "deb http://www.deb-multimedia.org jessie main non-free" | tee -a /etc/apt/sources.list && \
    curl -s -o /tmp/key.deb https://www.deb-multimedia.org/pool/main/d/deb-multimedia-keyring/deb-multimedia-keyring_2016.8.1_all.deb && \
    dpkg -i /tmp/key.deb && \
    rm -f /tmp/key.deb

RUN apt-get update && \
    apt-get install -y --force-yes \
    supervisor \
    perl5 \
    locales \
    faad \
    faac \
    flac \
    lame \
    sox \
    wavpack

# dependencies for shairtunes2 plugin
RUN apt-get install -y --force-yes \
    libcrypt-openssl-rsa-perl \
    libio-socket-inet6-perl \
    libwww-perl \
    avahi-daemon \
    avahi-utils \
    libio-socket-ssl-perl
ADD libnet-sdp-perl_0.07-1_all.deb /tmp/
RUN dpkg -i /tmp/libnet-sdp-perl_0.07-1_all.deb

RUN ln -s /var/lib/squeezeboxserver/cache/InstalledPlugins/Plugins/ShairTunes/shairport_helper/pre-compiled/shairport_helper-x64-static /usr/bin/shairport_helper

RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    echo "de_DE.UTF-8 UTF-8" >> /etc/locale.gen && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

RUN dpkg -i /tmp/lms.deb && \
    rm -f  /tmp/lms.deb

# Cleanup
RUN apt-get -y remove curl && \
    apt-get -y autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
        
# Move config dir to allow editing convert.conf
RUN mv /etc/squeezeboxserver /etc/squeezeboxserver.orig && \
    ln -s /var/lib/squeezeboxserver/etc /etc/squeezeboxserver

RUN mkdir -p /var/log/supervisor
COPY ./start-lms.sh /usr/bin/
COPY ./start-avahi.sh /usr/bin/
COPY ./supervisord.conf /etc/

VOLUME ["/home/public/Music","/home/public/Playlists","/var/lib/squeezeboxserver","/etc/avahi"]
EXPOSE 3483 3483/udp 9000 9090 9005 5353/udp

CMD ["/usr/bin/start-lms.sh"]
