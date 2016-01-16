FROM debian:jessie
MAINTAINER Justifiably <justifiably@ymail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN echo "Europe/Berlin" > /etc/timezone && dpkg-reconfigure tzdata
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y curl

# Fetch latest 7.9 release
RUN curl -s "http://www.mysqueezebox.com/update/?version=7.9.0&revision=1&geturl=1&os=deb" | xargs curl -o /tmp/lms.deb 

# Dependencies first
RUN echo "deb http://www.deb-multimedia.org jessie main non-free" | tee -a /etc/apt/sources.list && \
    curl -s -o /tmp/key.deb https://www.deb-multimedia.org/pool/main/d/deb-multimedia-keyring/deb-multimedia-keyring_2015.6.1_all.deb && \
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
    libwww-perl avahi-utils \
    libio-socket-ssl-perl
RUN curl -o /tmp/libnet-sdp-perl_0.07-1_all.deb http://www.inf.udec.cl/~diegocaro/rpi/libnet-sdp-perl_0.07-1_all.deb && \
    dpkg -i /tmp/libnet-sdp-perl_0.07-1_all.deb

RUN echo "en_US.UTF-8 de_DE.UTF-8 UTF-8" >> /etc/locale.gen && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

# Fix UID for squeezeboxserver user to help with host volumes
RUN useradd --system --uid 819 -M -s /bin/false -d /usr/share/squeezeboxserver -G nogroup -c "Logitech Media Server user" squeezeboxserver && \
    dpkg -i /tmp/lms.deb && \
    rm -f  /tmp/lms.deb

# Cleanup
RUN apt-get -y remove curl && \
    apt-get -y autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
        
# Move config dir to allow editing convert.conf
RUN mkdir -p /mnt/state/etc && \
    mv /etc/squeezeboxserver /etc/squeezeboxserver.orig && \
    cp -pr /etc/squeezeboxserver.orig/* /mnt/state/etc && \
    ln -s /mnt/state/etc /etc/squeezeboxserver && \
    chown -R squeezeboxserver.nogroup /mnt/state

RUN mkdir -p /var/log/supervisor
COPY ./supervisord.conf /etc/
COPY ./start-lms.sh /usr/bin/

VOLUME ["/mnt/state","/mnt/music","/mnt/playlists"]
EXPOSE 3483 3483/udp 9000 9090 9005

CMD ["/usr/bin/start-lms.sh"]

