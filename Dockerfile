FROM debian:jessie
MAINTAINER dianwei

RUN buildDeps='wget gcc libc6-dev make ruby-full rubygems' \
	&& set -x \
	&& apt-get update && apt-get install -y $buildDeps --no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p /app
RUN mkdir -p /app/redis
RUN mkdir -p /data

WORKDIR /app

ENV REDIS_VERSION 3.2.1
ENV REDIS_DOWNLOAD_URL http://download.redis.io/releases/redis-3.2.1.tar.gz
ENV REDIS_DOWNLOAD_SHA1 26c0fc282369121b4e278523fce122910b65fbbf

#ADD redis.tar.gz /app
ADD redis-3.2.1.gem /app

RUN gem install -l redis-3.2.1.gem

RUN cd /app \
        && wget -O redis.tar.gz "$REDIS_DOWNLOAD_URL" \
        && tar -xzf redis.tar.gz -C redis --strip-components=1 \
        && cd redis \
        && cd deps \
        && make hiredis lua\
        && cd jemalloc;./configure;make;cd ../..\
        && make \
        && make install \
        && apt-get purge -y --auto-remove $buildDeps

VOLUME /data

ADD redis.conf /app
ADD redis.sh /app

RUN chmod +x /app/redis.sh

ENV REDIS_PORT 6379

ENTRYPOINT ["/app/redis.sh", "-d"]
