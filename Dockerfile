FROM debian:latest
MAINTAINER Plopix

RUN apt-get update -q -y && apt-get install -q -y --force-yes --no-install-recommends build-essential flex \
    libtool m4 automake autoconf make g++ gcc lua5.1 lua5.1-dev pkg-config libmariadbclient-dev libglib2.0-dev libevent-dev && \
    rm -rf /var/lib/apt/lists/*

# MySQL Proxy - Source
ADD https://github.com/mysql/mysql-proxy/archive/rel-0.8.5.tar.gz /usr/src

# The Debug LUA script
ADD https://raw.githubusercontent.com/patrickallaert/MySQL-Proxy-scripts-for-devs/master/debug.lua /usr/src/debug_template.lua

# config
COPY mp_template.conf /usr/src
COPY entrypoint.bash /entrypoint.bash

RUN cd /usr/src && tar xvzf rel-0.8.5.tar.gz && cd mysql-proxy-rel-0.8.5 && \
    ./autogen.sh && ./configure && make && make install && chmod +x /entrypoint.bash && \
    rm -rf /usr/src/mysql-proxy-rel-0.8.5

ENV BACKEND 127.0.0.1
ENV USE_NO_CACHE 1

EXPOSE 3306

ENTRYPOINT ["/entrypoint.bash"]
CMD ["/usr/local/bin/mysql-proxy", "--plugins=proxy", "--defaults-file=/etc/mp.conf", "-s", "/etc/debug.lua"]
