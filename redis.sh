#!/bin/bash
cd /app
echo "============="
echo $REDIS_PORT
echo "============="
sed -i "s/6379/$REDIS_PORT/g" redis.conf
sed -i "s/# bind 127.0.0.1/bind $BIND_ADDRESS/g" redis.conf
sed -i 's/# cluster-enabled yes/cluster-enabled yes/g' redis.conf
sed -i 's/# cluster-node-timeout 15000/cluster-node-timeout 15000/g' redis.conf
sed -i "s/# cluster-config-file nodes.*/cluster-config-file nodes-$REDIS_PORT.conf/g" redis.conf
mkdir -p /data/data
mkdir -p /data/logs
redis-server -v
nohup redis-server redis.conf &
if [[ $1 == "-d" ]]; then
  while true; do sleep 1000; done
fi

if [[ $1 == "-bash" ]]; then
  /bin/bash
fi
