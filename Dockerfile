FROM debian:jessie
MAINTAINER Michael Pope <map7777@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y wget perl supervisor && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ADD ./install.sh /install.sh
RUN chmod u+x /install.sh
RUN /install.sh
    
RUN mkdir -p /var/log/supervisor

COPY ./etc/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

VOLUME ["/mnt/state"]
EXPOSE 3483 9000 9090

CMD ["/usr/bin/supervisord"]

