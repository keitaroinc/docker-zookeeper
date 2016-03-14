# docker-zookeeper

## Standalone ZooKeeper example

### 1. Start standalone ZooKeeper

```sh
$ docker run -d -p 2182:2181 --name zookeeper mosuka/docker-zookeeper:release-3.4
d98212b5603d3450e4e269549e58857d3e42c543e5fb8748aa7353bb80306c51
```

### 2. Check container ID

```sh
$ docker ps
CONTAINER ID        IMAGE                                 COMMAND                  CREATED             STATUS              PORTS                                         NAMES
d98212b5603d        mosuka/docker-zookeeper:release-3.4   "/usr/local/bin/docke"   18 seconds ago      Up 17 seconds       2888/tcp, 3888/tcp, 0.0.0.0:2182->2181/tcp   zookeeper
```

### 3. Get container IP

```sh
$ docker inspect -f '{{ .NetworkSettings.IPAddress }}' zookeeper
172.17.0.2
```

### 4. Get host IP

```sh
$ docker-machine ip default
192.168.99.100
```

### 5. Connect to ZooKeeper using zkCli.sh on the local machine

```sh
$ /Users/mosuka/zookeeper/zookeeper-3.4.8/bin/zkCli.sh -server 192.168.99.100:2182
Connecting to 192.168.99.100:2182
2016-03-10 14:26:29,460 [myid:] - INFO  [main:Environment@100] - Client environment:zookeeper.version=3.4.8--1, built on 02/06/2016 03:18 GMT
2016-03-10 14:26:29,463 [myid:] - INFO  [main:Environment@100] - Client environment:host.name=172.17.4.1
2016-03-10 14:26:29,463 [myid:] - INFO  [main:Environment@100] - Client environment:java.version=1.8.0_65
2016-03-10 14:26:29,466 [myid:] - INFO  [main:Environment@100] - Client environment:java.vendor=Oracle Corporation
2016-03-10 14:26:29,466 [myid:] - INFO  [main:Environment@100] - Client environment:java.home=/Library/Java/JavaVirtualMachines/jdk1.8.0_65.jdk/Contents/Home/jre
2016-03-10 14:26:29,466 [myid:] - INFO  [main:Environment@100] - Client environment:java.class.path=/Users/mosuka/zookeeper/zookeeper-3.4.8/bin/../build/classes:/Users/mosuka/zookeeper/zookeeper-3.4.8/bin/../build/lib/*.jar:/Users/mosuka/zookeeper/zookeeper-3.4.8/bin/../lib/slf4j-log4j12-1.6.1.jar:/Users/mosuka/zookeeper/zookeeper-3.4.8/bin/../lib/slf4j-api-1.6.1.jar:/Users/mosuka/zookeeper/zookeeper-3.4.8/bin/../lib/netty-3.7.0.Final.jar:/Users/mosuka/zookeeper/zookeeper-3.4.8/bin/../lib/log4j-1.2.16.jar:/Users/mosuka/zookeeper/zookeeper-3.4.8/bin/../lib/jline-0.9.94.jar:/Users/mosuka/zookeeper/zookeeper-3.4.8/bin/../zookeeper-3.4.8.jar:/Users/mosuka/zookeeper/zookeeper-3.4.8/bin/../src/java/lib/*.jar:/Users/mosuka/zookeeper/zookeeper-3.4.8/bin/../conf:
2016-03-10 14:26:29,466 [myid:] - INFO  [main:Environment@100] - Client environment:java.library.path=/Users/mosuka/Library/Java/Extensions:/Library/Java/Extensions:/Network/Library/Java/Extensions:/System/Library/Java/Extensions:/usr/lib/java:.
2016-03-10 14:26:29,466 [myid:] - INFO  [main:Environment@100] - Client environment:java.io.tmpdir=/var/folders/99/p369dv7n5sqdl9rdvyx0vqzr0000gn/T/
2016-03-10 14:26:29,466 [myid:] - INFO  [main:Environment@100] - Client environment:java.compiler=<NA>
2016-03-10 14:26:29,467 [myid:] - INFO  [main:Environment@100] - Client environment:os.name=Mac OS X
2016-03-10 14:26:29,467 [myid:] - INFO  [main:Environment@100] - Client environment:os.arch=x86_64
2016-03-10 14:26:29,467 [myid:] - INFO  [main:Environment@100] - Client environment:os.version=10.11.3
2016-03-10 14:26:29,467 [myid:] - INFO  [main:Environment@100] - Client environment:user.name=mosuka
2016-03-10 14:26:29,467 [myid:] - INFO  [main:Environment@100] - Client environment:user.home=/Users/mosuka
2016-03-10 14:26:29,468 [myid:] - INFO  [main:Environment@100] - Client environment:user.dir=/Users/mosuka
2016-03-10 14:26:29,469 [myid:] - INFO  [main:ZooKeeper@438] - Initiating client connection, connectString=192.168.99.100:2182 sessionTimeout=30000 watcher=org.apache.zookeeper.ZooKeeperMain$MyWatcher@446cdf90
Welcome to ZooKeeper!
2016-03-10 14:26:29,504 [myid:] - INFO  [main-SendThread(192.168.99.100:2182):ClientCnxn$SendThread@1032] - Opening socket connection to server 192.168.99.100/192.168.99.100:2182. Will not attempt to authenticate using SASL (unknown error)
JLine support is enabled
2016-03-10 14:26:29,640 [myid:] - INFO  [main-SendThread(192.168.99.100:2182):ClientCnxn$SendThread@876] - Socket connection established to 192.168.99.100/192.168.99.100:2182, initiating session
2016-03-10 14:26:29,698 [myid:] - INFO  [main-SendThread(192.168.99.100:2182):ClientCnxn$SendThread@1299] - Session establishment complete on server 192.168.99.100/192.168.99.100:2182, sessionid = 0x1535ef9701c0001, negotiated timeout = 30000

WATCHER::

WatchedEvent state:SyncConnected type:None path:null
[zk: 192.168.99.100:2182(CONNECTED) 0]
```



## ZooKeeper ensemble (3 nodes) example

### 1. Create network

```sh
$ docker network create --subnet=172.18.0.0/16 network1
61ff80da6894f9035ce6425751f3861c6e8b17078883d0bc0218896d894317c9
```

### 2. Start 1st ZooKeeper

```sh
$ docker run -d -p 2182:2181 --net=network1 --ip 172.18.0.2 --name zookeeper1 \
    -e ZOOKEEPER_ID=1 \
    -e ZOOKEEPER_SERVER_1=172.18.0.2 \
    -e ZOOKEEPER_SERVER_2=172.18.0.3 \
    -e ZOOKEEPER_SERVER_3=172.18.0.4 \
    mosuka/docker-zookeeper:release-3.4
fc366f620f79de1385a19eacf2ec1d126eaca7e497dda126dda51bf6e9463b2c
```

### 3. Start 2nd ZooKeeper

```sh
$ docker run -d -p 2183:2181 --net=network1 --ip 172.18.0.3 --name zookeeper2 \
    -e ZOOKEEPER_ID=2 \
    -e ZOOKEEPER_SERVER_1=172.18.0.2 \
    -e ZOOKEEPER_SERVER_2=172.18.0.3 \
    -e ZOOKEEPER_SERVER_3=172.18.0.4 \
    mosuka/docker-zookeeper:release-3.4
d0c05513b4fdd46574db8c455fe8cd720a80bbd822b9ea3f65ed3a5ef6f57a17
```

### 4. Start 3rd ZooKeeper

```sh
$ docker run -d -p 2184:2181 --net=network1 --ip 172.18.0.4 --name zookeeper3 \
    -e ZOOKEEPER_ID=3 \
    -e ZOOKEEPER_SERVER_1=172.18.0.2 \
    -e ZOOKEEPER_SERVER_2=172.18.0.3 \
    -e ZOOKEEPER_SERVER_3=172.18.0.4 \
    mosuka/docker-zookeeper:release-3.4
432afd32772c9e76386284cc19727522fc09f4450ac6b448bb95066941168359
```

### 5. Check container ID

```sh
$ docker ps
CONTAINER ID        IMAGE                                 COMMAND                  CREATED             STATUS              PORTS                                         NAMES
432afd32772c        mosuka/docker-zookeeper:release-3.4   "/usr/local/bin/docke"   9 seconds ago       Up 9 seconds        2888/tcp, 3888/tcp, 0.0.0.0:2184->2181/tcp   zookeeper3
d0c05513b4fd        mosuka/docker-zookeeper:release-3.4   "/usr/local/bin/docke"   19 seconds ago      Up 19 seconds       2888/tcp, 3888/tcp, 0.0.0.0:2183->2181/tcp   zookeeper2
fc366f620f79        mosuka/docker-zookeeper:release-3.4   "/usr/local/bin/docke"   32 seconds ago      Up 31 seconds       2888/tcp, 3888/tcp, 0.0.0.0:2182->2181/tcp   zookeeper1
```

### 6. Get container IP of 1st ZooKeeper

```sh
$ docker inspect -f '{{ .NetworkSettings.Networks.network1.IPAddress }}' zookeeper1
172.18.0.2
```

### 7. Get container IP of 2nd ZooKeeper

```sh
$ docker inspect -f '{{ .NetworkSettings.Networks.network1.IPAddress }}' zookeeper2
172.18.0.3
```

### 8. Get container IP of 3rd ZooKeeper

```sh
$ docker inspect -f '{{ .NetworkSettings.Networks.network1.IPAddress }}' zookeeper3
172.18.0.4
```

### 9. Get host IP

```sh
$ docker-machine ip default
192.168.99.100
```

### 10. Connect to ZooKeeper using zkCli.sh on the local machine

```sh
$ /Users/mosuka/zookeeper/zookeeper-3.4.8/bin/zkCli.sh -server 192.168.99.100:2182
Connecting to 192.168.99.100:2182
2016-03-10 14:26:29,460 [myid:] - INFO  [main:Environment@100] - Client environment:zookeeper.version=3.4.8--1, built on 02/06/2016 03:18 GMT
2016-03-10 14:26:29,463 [myid:] - INFO  [main:Environment@100] - Client environment:host.name=172.17.4.1
2016-03-10 14:26:29,463 [myid:] - INFO  [main:Environment@100] - Client environment:java.version=1.8.0_65
2016-03-10 14:26:29,466 [myid:] - INFO  [main:Environment@100] - Client environment:java.vendor=Oracle Corporation
2016-03-10 14:26:29,466 [myid:] - INFO  [main:Environment@100] - Client environment:java.home=/Library/Java/JavaVirtualMachines/jdk1.8.0_65.jdk/Contents/Home/jre
2016-03-10 14:26:29,466 [myid:] - INFO  [main:Environment@100] - Client environment:java.class.path=/Users/mosuka/zookeeper/zookeeper-3.4.8/bin/../build/classes:/Users/mosuka/zookeeper/zookeeper-3.4.8/bin/../build/lib/*.jar:/Users/mosuka/zookeeper/zookeeper-3.4.8/bin/../lib/slf4j-log4j12-1.6.1.jar:/Users/mosuka/zookeeper/zookeeper-3.4.8/bin/../lib/slf4j-api-1.6.1.jar:/Users/mosuka/zookeeper/zookeeper-3.4.8/bin/../lib/netty-3.7.0.Final.jar:/Users/mosuka/zookeeper/zookeeper-3.4.8/bin/../lib/log4j-1.2.16.jar:/Users/mosuka/zookeeper/zookeeper-3.4.8/bin/../lib/jline-0.9.94.jar:/Users/mosuka/zookeeper/zookeeper-3.4.8/bin/../zookeeper-3.4.8.jar:/Users/mosuka/zookeeper/zookeeper-3.4.8/bin/../src/java/lib/*.jar:/Users/mosuka/zookeeper/zookeeper-3.4.8/bin/../conf:
2016-03-10 14:26:29,466 [myid:] - INFO  [main:Environment@100] - Client environment:java.library.path=/Users/mosuka/Library/Java/Extensions:/Library/Java/Extensions:/Network/Library/Java/Extensions:/System/Library/Java/Extensions:/usr/lib/java:.
2016-03-10 14:26:29,466 [myid:] - INFO  [main:Environment@100] - Client environment:java.io.tmpdir=/var/folders/99/p369dv7n5sqdl9rdvyx0vqzr0000gn/T/
2016-03-10 14:26:29,466 [myid:] - INFO  [main:Environment@100] - Client environment:java.compiler=<NA>
2016-03-10 14:26:29,467 [myid:] - INFO  [main:Environment@100] - Client environment:os.name=Mac OS X
2016-03-10 14:26:29,467 [myid:] - INFO  [main:Environment@100] - Client environment:os.arch=x86_64
2016-03-10 14:26:29,467 [myid:] - INFO  [main:Environment@100] - Client environment:os.version=10.11.3
2016-03-10 14:26:29,467 [myid:] - INFO  [main:Environment@100] - Client environment:user.name=mosuka
2016-03-10 14:26:29,467 [myid:] - INFO  [main:Environment@100] - Client environment:user.home=/Users/mosuka
2016-03-10 14:26:29,468 [myid:] - INFO  [main:Environment@100] - Client environment:user.dir=/Users/mosuka
2016-03-10 14:26:29,469 [myid:] - INFO  [main:ZooKeeper@438] - Initiating client connection, connectString=192.168.99.100:2182 sessionTimeout=30000 watcher=org.apache.zookeeper.ZooKeeperMain$MyWatcher@446cdf90
Welcome to ZooKeeper!
2016-03-10 14:26:29,504 [myid:] - INFO  [main-SendThread(192.168.99.100:2182):ClientCnxn$SendThread@1032] - Opening socket connection to server 192.168.99.100/192.168.99.100:2182. Will not attempt to authenticate using SASL (unknown error)
JLine support is enabled
2016-03-10 14:26:29,640 [myid:] - INFO  [main-SendThread(192.168.99.100:2182):ClientCnxn$SendThread@876] - Socket connection established to 192.168.99.100/192.168.99.100:2182, initiating session
2016-03-10 14:26:29,698 [myid:] - INFO  [main-SendThread(192.168.99.100:2182):ClientCnxn$SendThread@1299] - Session establishment complete on server 192.168.99.100/192.168.99.100:2182, sessionid = 0x1535ef9701c0001, negotiated timeout = 30000

WATCHER::

WatchedEvent state:SyncConnected type:None path:null
[zk: 192.168.99.100:2182(CONNECTED) 0]
```
