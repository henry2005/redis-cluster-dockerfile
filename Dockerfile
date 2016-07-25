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

CMD ["/bin/bash"]
