#!/bin/bash

CUR_DIR=$(cd `dirname $0` && pwd -P)
# 宿主机 conf 目录
services_dir="$CUR_DIR/services/redis-cluster"
# 宿主机 data 目录
data_dir="$CUR_DIR/data/redis-cluster"

auth=auth123
# 宿主机ip
ip=192.168.1.222
# 容器内 data 目录
dir=/data

for port in `seq 7001 7006`; do \
  mkdir -p $services_dir/${port} \
  && PORT=${port} AUTH=${auth} IP=${ip} DIR=${dir}/${port} envsubst < $CUR_DIR/redis-cluster.tmpl > $services_dir/${port}/redis.conf \
  && mkdir -p $data_dir/${port}; \
done