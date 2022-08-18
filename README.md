# docker-redis-cluster
## 配置

批量生成配置文件

```bash
bash redis-cluster-config.sh
```

启动容器

```bash
docker-compose up
```

进入容器

```bash
docker exec -it compose-redis-cluster-redis7001-1 /bin/bash
```

初始化集群(三主三副本)

```bash
redis-cli -p 7001 -a auth123 --cluster create 192.168.1.222:7001 192.168.1.222:7002 192.168.1.222:7003 192.168.1.222:7004 192.168.1.222:7005 192.168.1.222:7006 --cluster-replicas 1

# 输出
>>> Performing hash slots allocation on 6 nodes...
Master[0] -> Slots 0 - 5460
Master[1] -> Slots 5461 - 10922
Master[2] -> Slots 10923 - 16383
Adding replica 192.168.1.222:7005 to 192.168.1.222:7001
Adding replica 192.168.1.222:7006 to 192.168.1.222:7002
Adding replica 192.168.1.222:7004 to 192.168.1.222:7003
>>> Trying to optimize slaves allocation for anti-affinity
[WARNING] Some slaves are in the same host as their master
M: 30c0a71e384a206cf39ff2fb34cc4d8dd23c1f61 192.168.1.222:7001
   slots:[0-5460] (5461 slots) master
M: 43159aa88fe2a911134a3591e6246acfc05d4021 192.168.1.222:7002
   slots:[5461-10922] (5462 slots) master
M: 812f0eab714c071a45489a85e66e2bd76ca3d9a3 192.168.1.222:7003
   slots:[10923-16383] (5461 slots) master
S: c29bf51272edbff882d052094703f78db6bbef7b 192.168.1.222:7004
   replicates 30c0a71e384a206cf39ff2fb34cc4d8dd23c1f61
S: 87a739023379723d603ecd0a96837cb0f2b39bc5 192.168.1.222:7005
   replicates 43159aa88fe2a911134a3591e6246acfc05d4021
S: bd285219b714e82d11247594af40bc2ebf87c443 192.168.1.222:7006
   replicates 812f0eab714c071a45489a85e66e2bd76ca3d9a3
Can I set the above configuration? (type 'yes' to accept): yes
>>> Nodes configuration updated
>>> Assign a different config epoch to each node
>>> Sending CLUSTER MEET messages to join the cluster
Waiting for the cluster to join
.
>>> Performing Cluster Check (using node 192.168.1.222:7001)
M: 30c0a71e384a206cf39ff2fb34cc4d8dd23c1f61 192.168.1.222:7001
   slots:[0-5460] (5461 slots) master
   1 additional replica(s)
S: c29bf51272edbff882d052094703f78db6bbef7b 192.168.1.222:7004
   slots: (0 slots) slave
   replicates 30c0a71e384a206cf39ff2fb34cc4d8dd23c1f61
M: 43159aa88fe2a911134a3591e6246acfc05d4021 192.168.1.222:7002
   slots:[5461-10922] (5462 slots) master
   1 additional replica(s)
S: 87a739023379723d603ecd0a96837cb0f2b39bc5 192.168.1.222:7005
   slots: (0 slots) slave
   replicates 43159aa88fe2a911134a3591e6246acfc05d4021
M: 812f0eab714c071a45489a85e66e2bd76ca3d9a3 192.168.1.222:7003
   slots:[10923-16383] (5461 slots) master
   1 additional replica(s)
S: bd285219b714e82d11247594af40bc2ebf87c443 192.168.1.222:7006
   slots: (0 slots) slave
   replicates 812f0eab714c071a45489a85e66e2bd76ca3d9a3
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
>>> Check slots coverage...
[OK] All 16384 slots covered.
```

## 查看集群

进入redis

```bash
redis-cli -c  -p 7001 -a auth123
```

查看节点

```bash
127.0.0.1:7001> cluster nodes
c29bf51272edbff882d052094703f78db6bbef7b 192.168.1.222:7004@17004 slave 30c0a71e384a206cf39ff2fb34cc4d8dd23c1f61 0 1660818408325 1 connected
43159aa88fe2a911134a3591e6246acfc05d4021 192.168.1.222:7002@17002 master - 0 1660818407600 2 connected 5461-10922
87a739023379723d603ecd0a96837cb0f2b39bc5 192.168.1.222:7005@17005 slave 43159aa88fe2a911134a3591e6246acfc05d4021 0 1660818406268 2 connected
812f0eab714c071a45489a85e66e2bd76ca3d9a3 192.168.1.222:7003@17003 master - 0 1660818406574 3 connected 10923-16383
30c0a71e384a206cf39ff2fb34cc4d8dd23c1f61 192.168.1.222:7001@17001 myself,master - 0 1660818407000 1 connected 0-5460
bd285219b714e82d11247594af40bc2ebf87c443 192.168.1.222:7006@17006 slave 812f0eab714c071a45489a85e66e2bd76ca3d9a3 0 1660818407295 3 connected
```

测试

```bash
127.0.0.1:7001> set foo bar
-> Redirected to slot [12182] located at 192.168.1.222:7003
OK
192.168.1.222:7003> get foo
"bar"
192.168.1.222:7003>
```

