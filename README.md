# docker-zookeeper

This is a Docker image for Apache ZooKeeper.

## What is ZooKeeper?

[ZooKeeper](https://zookeeper.apache.org) is a centralized service for maintaining configuration information, naming, providing distributed synchronization, and providing group services. All of these kinds of services are used in some form or another by distributed applications. Each time they are implemented there is a lot of work that goes into fixing the bugs and race conditions that are inevitable. Because of the difficulty of implementing these kinds of services, applications initially usually skimp on them ,which make them brittle in the presence of change and difficult to manage. Even when done correctly, different implementations of these services lead to management complexity when the applications are deployed.

Learn more about ZooKeeper on the [ZooKeeper Wiki](https://cwiki.apache.org/confluence/display/ZOOKEEPER/Index).

## How to build this Docker image

```
$ git clone git@github.com:mosuka/docker-zookeeper.git ${HOME}/git/docker-zookeeper
$ docker build -t mosuka/docker-zookeeper:latest ${HOME}/git/docker-zookeeper
```

## How to pull this Docker image

```
$ docker pull mosuka/docker-zookeeper:latest
```

## How to use this Docker image

### Standalone ZooKeeper example

#### 1. Start standalone ZooKeeper

```sh
$ docker run -d -p 2182:2181 --name zookeeper mosuka/docker-zookeeper:latest
ff94d300c718bd1c1c7f33cda0fc1b7f07f6c7914893877cafc13222db620c5c

$ ZOOKEEPER_CONTAINER_IP=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' zookeeper)
$ echo ${ZOOKEEPER_CONTAINER_IP}
172.17.0.2
```

#### 2. Check container ID

```sh
$ docker ps
CONTAINER ID        IMAGE                            COMMAND                  CREATED             STATUS              PORTS                                        NAMES
ff94d300c718        mosuka/docker-zookeeper:latest   "/usr/local/bin/docke"   27 seconds ago      Up 25 seconds       2888/tcp, 3888/tcp, 0.0.0.0:2182->2181/tcp   zookeeper
```

#### 3. Get host IP

```sh
$ ZOOKEEPER_HOST_IP=$(docker-machine ip default)
$ ZOOKEEPER_HOST_IP=${ZOOKEEPER_HOST_IP:-127.0.0.1}
$ echo ${ZOOKEEPER_HOST_IP}
127.0.0.1

$ ZOOKEEPER_HOST_PORT=$(docker inspect -f '{{ $port := index .NetworkSettings.Ports "2181/tcp" }}{{ range $port }}{{ .HostPort }}{{ end }}' zookeeper)
$ echo ${ZOOKEEPER_HOST_PORT}
2182
```

#### 4. Connect to ZooKeeper using zkCli.sh on the local machine

```sh
$ docker exec -i -t zookeeper ./zookeeper/bin/zkCli.sh -server localhost:2181 get /zookeeper/config
Connecting to localhost:2181
2016-09-20 00:52:05,612 [myid:] - INFO  [main:Environment@109] - Client environment:zookeeper.version=3.5.1-alpha-1693007, built on 07/28/2015 07:19 GMT
2016-09-20 00:52:05,616 [myid:] - INFO  [main:Environment@109] - Client environment:host.name=ff94d300c718
2016-09-20 00:52:05,617 [myid:] - INFO  [main:Environment@109] - Client environment:java.version=1.7.0_111
2016-09-20 00:52:05,623 [myid:] - INFO  [main:Environment@109] - Client environment:java.vendor=Oracle Corporation
2016-09-20 00:52:05,624 [myid:] - INFO  [main:Environment@109] - Client environment:java.home=/usr/lib/jvm/java-7-openjdk-amd64/jre
2016-09-20 00:52:05,625 [myid:] - INFO  [main:Environment@109] - Client environment:java.class.path=/home/zookeeper/zookeeper-3.5.1-alpha/bin/../build/classes:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../build/lib/*.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/slf4j-log4j12-1.7.5.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/slf4j-api-1.7.5.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/servlet-api-2.5-20081211.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/netty-3.7.0.Final.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/log4j-1.2.16.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jline-2.11.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jetty-util-6.1.26.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jetty-6.1.26.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/javacc.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jackson-mapper-asl-1.9.11.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jackson-core-asl-1.9.11.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/commons-cli-1.2.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../zookeeper-3.5.1-alpha.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../src/java/lib/*.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../conf:
2016-09-20 00:52:05,625 [myid:] - INFO  [main:Environment@109] - Client environment:java.library.path=/usr/java/packages/lib/amd64:/usr/lib/x86_64-linux-gnu/jni:/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu:/usr/lib/jni:/lib:/usr/lib
2016-09-20 00:52:05,626 [myid:] - INFO  [main:Environment@109] - Client environment:java.io.tmpdir=/tmp
2016-09-20 00:52:05,626 [myid:] - INFO  [main:Environment@109] - Client environment:java.compiler=<NA>
2016-09-20 00:52:05,627 [myid:] - INFO  [main:Environment@109] - Client environment:os.name=Linux
2016-09-20 00:52:05,627 [myid:] - INFO  [main:Environment@109] - Client environment:os.arch=amd64
2016-09-20 00:52:05,628 [myid:] - INFO  [main:Environment@109] - Client environment:os.version=4.4.20-moby
2016-09-20 00:52:05,628 [myid:] - INFO  [main:Environment@109] - Client environment:user.name=zookeeper
2016-09-20 00:52:05,629 [myid:] - INFO  [main:Environment@109] - Client environment:user.home=/home/zookeeper
2016-09-20 00:52:05,629 [myid:] - INFO  [main:Environment@109] - Client environment:user.dir=/home/zookeeper
2016-09-20 00:52:05,630 [myid:] - INFO  [main:Environment@109] - Client environment:os.memory.free=25MB
2016-09-20 00:52:05,632 [myid:] - INFO  [main:Environment@109] - Client environment:os.memory.max=227MB
2016-09-20 00:52:05,633 [myid:] - INFO  [main:Environment@109] - Client environment:os.memory.total=30MB
2016-09-20 00:52:05,638 [myid:] - INFO  [main:ZooKeeper@716] - Initiating client connection, connectString=localhost:2181 sessionTimeout=30000 watcher=org.apache.zookeeper.ZooKeeperMain$MyWatcher@28b2311b
2016-09-20 00:52:05,674 [myid:] - INFO  [main-SendThread(localhost:2181):ClientCnxn$SendThread@1138] - Opening socket connection to server localhost/0:0:0:0:0:0:0:1:2181. Will not attempt to authenticate using SASL (unknown error)
2016-09-20 00:52:05,690 [myid:] - INFO  [main-SendThread(localhost:2181):ClientCnxn$SendThread@980] - Socket connection established, initiating session, client: /0:0:0:0:0:0:0:1:52868, server: localhost/0:0:0:0:0:0:0:1:2181
2016-09-20 00:52:05,819 [myid:] - INFO  [main-SendThread(localhost:2181):ClientCnxn$SendThread@1400] - Session establishment complete on server localhost/0:0:0:0:0:0:0:1:2181, sessionid = 0x1000041961a0000, negotiated timeout = 30000

WATCHER::

WatchedEvent state:SyncConnected type:None path:null
server.1=172.17.0.2:2888:3888:participant;0.0.0.0:2181
version=100000000
```

#### 5. Stop ZooKeeper

```sh
$ docker stop zookeeper; docker rm zookeeper
zookeeper
zookeeper
```

### ZooKeeper ensemble (3 nodes) example using ZOOKEEPER_SEED_HOST

#### 1. Start ZooKeeper

```sh
$ docker run -d -p 2182:2181 --name zookeeper1 mosuka/docker-zookeeper:latest
5303c38042ad650d956d2d2a9fdaf167c9cf87e164ffe66de391f31533118626

$ ZOOKEEPER_1_CONTAINER_IP=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' zookeeper1)
$ echo ${ZOOKEEPER_1_CONTAINER_IP}
172.17.0.2

$ docker run -d -p 2183:2181 --name zookeeper2 -e ZOOKEEPER_SEED_HOST=${ZOOKEEPER_1_CONTAINER_IP} mosuka/docker-zookeeper:latest
fd34a51e2915605ee7707b233335fc0591db33fb8efd7b0876423113dea96406

$ ZOOKEEPER_2_CONTAINER_IP=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' zookeeper2)
$ echo ${ZOOKEEPER_2_CONTAINER_IP}
172.17.0.3

$ docker run -d -p 2184:2181 --name zookeeper3 -e ZOOKEEPER_SEED_HOST=${ZOOKEEPER_2_CONTAINER_IP} mosuka/docker-zookeeper:latest
00c1edac4d546765384ccb68f6365643868bbcab16fa322f2b5d74629f459f62

$ ZOOKEEPER_3_CONTAINER_IP=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' zookeeper3)
$ echo ${ZOOKEEPER_3_CONTAINER_IP}
172.17.0.4
```

#### 2. Check container ID

```sh
$ docker ps
CONTAINER ID        IMAGE                            COMMAND                  CREATED              STATUS              PORTS                                        NAMES
00c1edac4d54        mosuka/docker-zookeeper:latest   "/usr/local/bin/docke"   24 seconds ago       Up 21 seconds       2888/tcp, 3888/tcp, 0.0.0.0:2184->2181/tcp   zookeeper3
fd34a51e2915        mosuka/docker-zookeeper:latest   "/usr/local/bin/docke"   56 seconds ago       Up 54 seconds       2888/tcp, 3888/tcp, 0.0.0.0:2183->2181/tcp   zookeeper2
5303c38042ad        mosuka/docker-zookeeper:latest   "/usr/local/bin/docke"   About a minute ago   Up About a minute   2888/tcp, 3888/tcp, 0.0.0.0:2182->2181/tcp   zookeeper1
```

#### 3. Get host IP

```sh
$ ZOOKEEPER_HOST_IP=$(docker-machine ip default)
$ ZOOKEEPER_HOST_IP=${ZOOKEEPER_HOST_IP:-127.0.0.1}
$ echo ${ZOOKEEPER_HOST_IP}
127.0.0.1

$ ZOOKEEPER_1_HOST_PORT=$(docker inspect -f '{{ $port := index .NetworkSettings.Ports "2181/tcp" }}{{ range $port }}{{ .HostPort }}{{ end }}' zookeeper1)
$ echo ${ZOOKEEPER_1_HOST_PORT}
2182

$ ZOOKEEPER_2_HOST_PORT=$(docker inspect -f '{{ $port := index .NetworkSettings.Ports "2181/tcp" }}{{ range $port }}{{ .HostPort }}{{ end }}' zookeeper2)
$ echo ${ZOOKEEPER_2_HOST_PORT}
2183

$ ZOOKEEPER_3_HOST_PORT=$(docker inspect -f '{{ $port := index .NetworkSettings.Ports "2181/tcp" }}{{ range $port }}{{ .HostPort }}{{ end }}' zookeeper3)
$ echo ${ZOOKEEPER_3_HOST_PORT}
2184
```

#### 4. Connect to ZooKeeper using zkCli.sh on the local machine

```sh
$ docker exec -i -t zookeeper1 ./zookeeper/bin/zkCli.sh -server localhost:2181 get /zookeeper/config
Connecting to localhost:2181
2016-09-20 00:55:50,317 [myid:] - INFO  [main:Environment@109] - Client environment:zookeeper.version=3.5.1-alpha-1693007, built on 07/28/2015 07:19 GMT
2016-09-20 00:55:50,323 [myid:] - INFO  [main:Environment@109] - Client environment:host.name=5303c38042ad
2016-09-20 00:55:50,324 [myid:] - INFO  [main:Environment@109] - Client environment:java.version=1.7.0_111
2016-09-20 00:55:50,326 [myid:] - INFO  [main:Environment@109] - Client environment:java.vendor=Oracle Corporation
2016-09-20 00:55:50,327 [myid:] - INFO  [main:Environment@109] - Client environment:java.home=/usr/lib/jvm/java-7-openjdk-amd64/jre
2016-09-20 00:55:50,327 [myid:] - INFO  [main:Environment@109] - Client environment:java.class.path=/home/zookeeper/zookeeper-3.5.1-alpha/bin/../build/classes:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../build/lib/*.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/slf4j-log4j12-1.7.5.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/slf4j-api-1.7.5.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/servlet-api-2.5-20081211.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/netty-3.7.0.Final.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/log4j-1.2.16.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jline-2.11.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jetty-util-6.1.26.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jetty-6.1.26.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/javacc.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jackson-mapper-asl-1.9.11.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jackson-core-asl-1.9.11.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/commons-cli-1.2.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../zookeeper-3.5.1-alpha.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../src/java/lib/*.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../conf:
2016-09-20 00:55:50,327 [myid:] - INFO  [main:Environment@109] - Client environment:java.library.path=/usr/java/packages/lib/amd64:/usr/lib/x86_64-linux-gnu/jni:/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu:/usr/lib/jni:/lib:/usr/lib
2016-09-20 00:55:50,328 [myid:] - INFO  [main:Environment@109] - Client environment:java.io.tmpdir=/tmp
2016-09-20 00:55:50,328 [myid:] - INFO  [main:Environment@109] - Client environment:java.compiler=<NA>
2016-09-20 00:55:50,328 [myid:] - INFO  [main:Environment@109] - Client environment:os.name=Linux
2016-09-20 00:55:50,329 [myid:] - INFO  [main:Environment@109] - Client environment:os.arch=amd64
2016-09-20 00:55:50,329 [myid:] - INFO  [main:Environment@109] - Client environment:os.version=4.4.20-moby
2016-09-20 00:55:50,329 [myid:] - INFO  [main:Environment@109] - Client environment:user.name=zookeeper
2016-09-20 00:55:50,330 [myid:] - INFO  [main:Environment@109] - Client environment:user.home=/home/zookeeper
2016-09-20 00:55:50,330 [myid:] - INFO  [main:Environment@109] - Client environment:user.dir=/home/zookeeper
2016-09-20 00:55:50,330 [myid:] - INFO  [main:Environment@109] - Client environment:os.memory.free=25MB
2016-09-20 00:55:50,333 [myid:] - INFO  [main:Environment@109] - Client environment:os.memory.max=227MB
2016-09-20 00:55:50,334 [myid:] - INFO  [main:Environment@109] - Client environment:os.memory.total=30MB
2016-09-20 00:55:50,338 [myid:] - INFO  [main:ZooKeeper@716] - Initiating client connection, connectString=localhost:2181 sessionTimeout=30000 watcher=org.apache.zookeeper.ZooKeeperMain$MyWatcher@28b2311b
2016-09-20 00:55:50,374 [myid:] - INFO  [main-SendThread(localhost:2181):ClientCnxn$SendThread@1138] - Opening socket connection to server localhost/0:0:0:0:0:0:0:1:2181. Will not attempt to authenticate using SASL (unknown error)
2016-09-20 00:55:50,388 [myid:] - INFO  [main-SendThread(localhost:2181):ClientCnxn$SendThread@980] - Socket connection established, initiating session, client: /0:0:0:0:0:0:0:1:52922, server: localhost/0:0:0:0:0:0:0:1:2181
2016-09-20 00:55:50,591 [myid:] - INFO  [main-SendThread(localhost:2181):ClientCnxn$SendThread@1400] - Session establishment complete on server localhost/0:0:0:0:0:0:0:1:2181, sessionid = 0x100004406e00000, negotiated timeout = 30000

WATCHER::

WatchedEvent state:SyncConnected type:None path:null
server.1=172.17.0.2:2888:3888:participant;0.0.0.0:2181
server.2=172.17.0.3:2888:3888:participant;0.0.0.0:2181
server.3=172.17.0.4:2888:3888:participant;0.0.0.0:2181
version=200000002

$ docker exec -i -t zookeeper2 ./zookeeper/bin/zkCli.sh -server localhost:2181 get /zookeeper/config
Connecting to localhost:2181
2016-09-20 00:56:12,587 [myid:] - INFO  [main:Environment@109] - Client environment:zookeeper.version=3.5.1-alpha-1693007, built on 07/28/2015 07:19 GMT
2016-09-20 00:56:12,593 [myid:] - INFO  [main:Environment@109] - Client environment:host.name=fd34a51e2915
2016-09-20 00:56:12,594 [myid:] - INFO  [main:Environment@109] - Client environment:java.version=1.7.0_111
2016-09-20 00:56:12,600 [myid:] - INFO  [main:Environment@109] - Client environment:java.vendor=Oracle Corporation
2016-09-20 00:56:12,600 [myid:] - INFO  [main:Environment@109] - Client environment:java.home=/usr/lib/jvm/java-7-openjdk-amd64/jre
2016-09-20 00:56:12,601 [myid:] - INFO  [main:Environment@109] - Client environment:java.class.path=/home/zookeeper/zookeeper-3.5.1-alpha/bin/../build/classes:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../build/lib/*.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/slf4j-log4j12-1.7.5.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/slf4j-api-1.7.5.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/servlet-api-2.5-20081211.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/netty-3.7.0.Final.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/log4j-1.2.16.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jline-2.11.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jetty-util-6.1.26.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jetty-6.1.26.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/javacc.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jackson-mapper-asl-1.9.11.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jackson-core-asl-1.9.11.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/commons-cli-1.2.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../zookeeper-3.5.1-alpha.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../src/java/lib/*.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../conf:
2016-09-20 00:56:12,602 [myid:] - INFO  [main:Environment@109] - Client environment:java.library.path=/usr/java/packages/lib/amd64:/usr/lib/x86_64-linux-gnu/jni:/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu:/usr/lib/jni:/lib:/usr/lib
2016-09-20 00:56:12,602 [myid:] - INFO  [main:Environment@109] - Client environment:java.io.tmpdir=/tmp
2016-09-20 00:56:12,603 [myid:] - INFO  [main:Environment@109] - Client environment:java.compiler=<NA>
2016-09-20 00:56:12,603 [myid:] - INFO  [main:Environment@109] - Client environment:os.name=Linux
2016-09-20 00:56:12,604 [myid:] - INFO  [main:Environment@109] - Client environment:os.arch=amd64
2016-09-20 00:56:12,604 [myid:] - INFO  [main:Environment@109] - Client environment:os.version=4.4.20-moby
2016-09-20 00:56:12,605 [myid:] - INFO  [main:Environment@109] - Client environment:user.name=zookeeper
2016-09-20 00:56:12,606 [myid:] - INFO  [main:Environment@109] - Client environment:user.home=/home/zookeeper
2016-09-20 00:56:12,606 [myid:] - INFO  [main:Environment@109] - Client environment:user.dir=/home/zookeeper
2016-09-20 00:56:12,607 [myid:] - INFO  [main:Environment@109] - Client environment:os.memory.free=25MB
2016-09-20 00:56:12,610 [myid:] - INFO  [main:Environment@109] - Client environment:os.memory.max=227MB
2016-09-20 00:56:12,611 [myid:] - INFO  [main:Environment@109] - Client environment:os.memory.total=30MB
2016-09-20 00:56:12,615 [myid:] - INFO  [main:ZooKeeper@716] - Initiating client connection, connectString=localhost:2181 sessionTimeout=30000 watcher=org.apache.zookeeper.ZooKeeperMain$MyWatcher@4ab5f87c
2016-09-20 00:56:12,656 [myid:] - INFO  [main-SendThread(localhost:2181):ClientCnxn$SendThread@1138] - Opening socket connection to server localhost/127.0.0.1:2181. Will not attempt to authenticate using SASL (unknown error)
2016-09-20 00:56:12,674 [myid:] - INFO  [main-SendThread(localhost:2181):ClientCnxn$SendThread@980] - Socket connection established, initiating session, client: /127.0.0.1:50178, server: localhost/127.0.0.1:2181
2016-09-20 00:56:12,803 [myid:] - INFO  [main-SendThread(localhost:2181):ClientCnxn$SendThread@1400] - Session establishment complete on server localhost/127.0.0.1:2181, sessionid = 0x200004405d40000, negotiated timeout = 30000

WATCHER::

WatchedEvent state:SyncConnected type:None path:null
server.1=172.17.0.2:2888:3888:participant;0.0.0.0:2181
server.2=172.17.0.3:2888:3888:participant;0.0.0.0:2181
server.3=172.17.0.4:2888:3888:participant;0.0.0.0:2181
version=200000002

$ docker exec -i -t zookeeper3 ./zookeeper/bin/zkCli.sh -server localhost:2181 get /zookeeper/config
Connecting to localhost:2181
2016-09-20 00:56:49,795 [myid:] - INFO  [main:Environment@109] - Client environment:zookeeper.version=3.5.1-alpha-1693007, built on 07/28/2015 07:19 GMT
2016-09-20 00:56:49,800 [myid:] - INFO  [main:Environment@109] - Client environment:host.name=00c1edac4d54
2016-09-20 00:56:49,801 [myid:] - INFO  [main:Environment@109] - Client environment:java.version=1.7.0_111
2016-09-20 00:56:49,806 [myid:] - INFO  [main:Environment@109] - Client environment:java.vendor=Oracle Corporation
2016-09-20 00:56:49,807 [myid:] - INFO  [main:Environment@109] - Client environment:java.home=/usr/lib/jvm/java-7-openjdk-amd64/jre
2016-09-20 00:56:49,807 [myid:] - INFO  [main:Environment@109] - Client environment:java.class.path=/home/zookeeper/zookeeper-3.5.1-alpha/bin/../build/classes:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../build/lib/*.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/slf4j-log4j12-1.7.5.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/slf4j-api-1.7.5.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/servlet-api-2.5-20081211.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/netty-3.7.0.Final.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/log4j-1.2.16.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jline-2.11.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jetty-util-6.1.26.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jetty-6.1.26.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/javacc.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jackson-mapper-asl-1.9.11.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jackson-core-asl-1.9.11.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/commons-cli-1.2.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../zookeeper-3.5.1-alpha.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../src/java/lib/*.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../conf:
2016-09-20 00:56:49,808 [myid:] - INFO  [main:Environment@109] - Client environment:java.library.path=/usr/java/packages/lib/amd64:/usr/lib/x86_64-linux-gnu/jni:/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu:/usr/lib/jni:/lib:/usr/lib
2016-09-20 00:56:49,808 [myid:] - INFO  [main:Environment@109] - Client environment:java.io.tmpdir=/tmp
2016-09-20 00:56:49,809 [myid:] - INFO  [main:Environment@109] - Client environment:java.compiler=<NA>
2016-09-20 00:56:49,809 [myid:] - INFO  [main:Environment@109] - Client environment:os.name=Linux
2016-09-20 00:56:49,809 [myid:] - INFO  [main:Environment@109] - Client environment:os.arch=amd64
2016-09-20 00:56:49,810 [myid:] - INFO  [main:Environment@109] - Client environment:os.version=4.4.20-moby
2016-09-20 00:56:49,810 [myid:] - INFO  [main:Environment@109] - Client environment:user.name=zookeeper
2016-09-20 00:56:49,810 [myid:] - INFO  [main:Environment@109] - Client environment:user.home=/home/zookeeper
2016-09-20 00:56:49,811 [myid:] - INFO  [main:Environment@109] - Client environment:user.dir=/home/zookeeper
2016-09-20 00:56:49,811 [myid:] - INFO  [main:Environment@109] - Client environment:os.memory.free=25MB
2016-09-20 00:56:49,813 [myid:] - INFO  [main:Environment@109] - Client environment:os.memory.max=227MB
2016-09-20 00:56:49,814 [myid:] - INFO  [main:Environment@109] - Client environment:os.memory.total=30MB
2016-09-20 00:56:49,817 [myid:] - INFO  [main:ZooKeeper@716] - Initiating client connection, connectString=localhost:2181 sessionTimeout=30000 watcher=org.apache.zookeeper.ZooKeeperMain$MyWatcher@28b2311b
2016-09-20 00:56:49,845 [myid:] - INFO  [main-SendThread(localhost:2181):ClientCnxn$SendThread@1138] - Opening socket connection to server localhost/0:0:0:0:0:0:0:1:2181. Will not attempt to authenticate using SASL (unknown error)
2016-09-20 00:56:49,861 [myid:] - INFO  [main-SendThread(localhost:2181):ClientCnxn$SendThread@980] - Socket connection established, initiating session, client: /0:0:0:0:0:0:0:1:52926, server: localhost/0:0:0:0:0:0:0:1:2181
2016-09-20 00:56:50,023 [myid:] - INFO  [main-SendThread(localhost:2181):ClientCnxn$SendThread@1400] - Session establishment complete on server localhost/0:0:0:0:0:0:0:1:2181, sessionid = 0x300004482ff0000, negotiated timeout = 30000

WATCHER::

WatchedEvent state:SyncConnected type:None path:null
server.1=172.17.0.2:2888:3888:participant;0.0.0.0:2181
server.2=172.17.0.3:2888:3888:participant;0.0.0.0:2181
server.3=172.17.0.4:2888:3888:participant;0.0.0.0:2181
version=200000002
```

#### 5. Stop ZooKeeper

```sh
$ docker stop zookeeper1 zookeeper2 zookeeper3; docker rm zookeeper1 zookeeper2 zookeeper3
zookeeper1
zookeeper2
zookeeper3
zookeeper1
zookeeper2
zookeeper3
```

### ZooKeeper ensemble (3 nodes) example using ZOOKEEPER_HOST_LIST

#### 1. Start ZooKeeper

```sh
$ docker run -d -p 2182:2181 --name zookeeper1 -e ZOOKEEPER_HOST_LIST="" mosuka/docker-zookeeper:latest
bb7aeb0ef2ddd7635f41fa8bbb660d74678d09caa143eb6de252c525ddc04e75

$ ZOOKEEPER_1_CONTAINER_IP=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' zookeeper1)
$ echo ${ZOOKEEPER_1_CONTAINER_IP}
172.17.0.2

$ docker run -d -p 2183:2181 --name zookeeper2 -e ZOOKEEPER_HOST_LIST="${ZOOKEEPER_1_CONTAINER_IP}" mosuka/docker-zookeeper:latest
5d72c44b5f487d72b94d6526f8240b166ac8919555054f76e39c7ab3b017b841

$ ZOOKEEPER_2_CONTAINER_IP=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' zookeeper2)
$ echo ${ZOOKEEPER_2_CONTAINER_IP}
172.17.0.3

$ docker run -d -p 2184:2181 --name zookeeper3 -e ZOOKEEPER_HOST_LIST="${ZOOKEEPER_1_CONTAINER_IP} ${ZOOKEEPER_2_CONTAINER_IP}" mosuka/docker-zookeeper:latest
110333f712de4c7872c639849de26d30f70515d5b6c9595754035e30cbd7ea0e

$ ZOOKEEPER_3_CONTAINER_IP=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' zookeeper3)
$ echo ${ZOOKEEPER_3_CONTAINER_IP}
172.17.0.4
```

#### 2. Check container ID

```sh
$ docker ps
CONTAINER ID        IMAGE                            COMMAND                  CREATED              STATUS              PORTS                                        NAMES
110333f712de        mosuka/docker-zookeeper:latest   "/usr/local/bin/docke"   19 seconds ago       Up 17 seconds       2888/tcp, 3888/tcp, 0.0.0.0:2184->2181/tcp   zookeeper3
5d72c44b5f48        mosuka/docker-zookeeper:latest   "/usr/local/bin/docke"   42 seconds ago       Up 40 seconds       2888/tcp, 3888/tcp, 0.0.0.0:2183->2181/tcp   zookeeper2
bb7aeb0ef2dd        mosuka/docker-zookeeper:latest   "/usr/local/bin/docke"   About a minute ago   Up About a minute   2888/tcp, 3888/tcp, 0.0.0.0:2182->2181/tcp   zookeeper1
```

#### 3. Get host IP

```sh
$ ZOOKEEPER_HOST_IP=$(docker-machine ip default)
$ ZOOKEEPER_HOST_IP=${ZOOKEEPER_HOST_IP:-127.0.0.1}
$ echo ${ZOOKEEPER_HOST_IP}
127.0.0.1

$ ZOOKEEPER_1_HOST_PORT=$(docker inspect -f '{{ $port := index .NetworkSettings.Ports "2181/tcp" }}{{ range $port }}{{ .HostPort }}{{ end }}' zookeeper1)
$ echo ${ZOOKEEPER_1_HOST_PORT}
2182

$ ZOOKEEPER_2_HOST_PORT=$(docker inspect -f '{{ $port := index .NetworkSettings.Ports "2181/tcp" }}{{ range $port }}{{ .HostPort }}{{ end }}' zookeeper2)
$ echo ${ZOOKEEPER_2_HOST_PORT}
2183

$ ZOOKEEPER_3_HOST_PORT=$(docker inspect -f '{{ $port := index .NetworkSettings.Ports "2181/tcp" }}{{ range $port }}{{ .HostPort }}{{ end }}' zookeeper3)
$ echo ${ZOOKEEPER_3_HOST_PORT}
2184
```

#### 4. Connect to ZooKeeper using zkCli.sh on the local machine

```sh
$ docker exec -i -t zookeeper1 ./zookeeper/bin/zkCli.sh -server localhost:2181 get /zookeeper/config
Connecting to localhost:2181
2016-09-20 01:00:15,961 [myid:] - INFO  [main:Environment@109] - Client environment:zookeeper.version=3.5.1-alpha-1693007, built on 07/28/2015 07:19 GMT
2016-09-20 01:00:15,965 [myid:] - INFO  [main:Environment@109] - Client environment:host.name=bb7aeb0ef2dd
2016-09-20 01:00:15,965 [myid:] - INFO  [main:Environment@109] - Client environment:java.version=1.7.0_111
2016-09-20 01:00:15,970 [myid:] - INFO  [main:Environment@109] - Client environment:java.vendor=Oracle Corporation
2016-09-20 01:00:15,970 [myid:] - INFO  [main:Environment@109] - Client environment:java.home=/usr/lib/jvm/java-7-openjdk-amd64/jre
2016-09-20 01:00:15,971 [myid:] - INFO  [main:Environment@109] - Client environment:java.class.path=/home/zookeeper/zookeeper-3.5.1-alpha/bin/../build/classes:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../build/lib/*.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/slf4j-log4j12-1.7.5.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/slf4j-api-1.7.5.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/servlet-api-2.5-20081211.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/netty-3.7.0.Final.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/log4j-1.2.16.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jline-2.11.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jetty-util-6.1.26.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jetty-6.1.26.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/javacc.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jackson-mapper-asl-1.9.11.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jackson-core-asl-1.9.11.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/commons-cli-1.2.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../zookeeper-3.5.1-alpha.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../src/java/lib/*.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../conf:
2016-09-20 01:00:15,971 [myid:] - INFO  [main:Environment@109] - Client environment:java.library.path=/usr/java/packages/lib/amd64:/usr/lib/x86_64-linux-gnu/jni:/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu:/usr/lib/jni:/lib:/usr/lib
2016-09-20 01:00:15,972 [myid:] - INFO  [main:Environment@109] - Client environment:java.io.tmpdir=/tmp
2016-09-20 01:00:15,972 [myid:] - INFO  [main:Environment@109] - Client environment:java.compiler=<NA>
2016-09-20 01:00:15,972 [myid:] - INFO  [main:Environment@109] - Client environment:os.name=Linux
2016-09-20 01:00:15,973 [myid:] - INFO  [main:Environment@109] - Client environment:os.arch=amd64
2016-09-20 01:00:15,973 [myid:] - INFO  [main:Environment@109] - Client environment:os.version=4.4.20-moby
2016-09-20 01:00:15,973 [myid:] - INFO  [main:Environment@109] - Client environment:user.name=zookeeper
2016-09-20 01:00:15,974 [myid:] - INFO  [main:Environment@109] - Client environment:user.home=/home/zookeeper
2016-09-20 01:00:15,974 [myid:] - INFO  [main:Environment@109] - Client environment:user.dir=/home/zookeeper
2016-09-20 01:00:15,974 [myid:] - INFO  [main:Environment@109] - Client environment:os.memory.free=25MB
2016-09-20 01:00:15,978 [myid:] - INFO  [main:Environment@109] - Client environment:os.memory.max=227MB
2016-09-20 01:00:15,978 [myid:] - INFO  [main:Environment@109] - Client environment:os.memory.total=30MB
2016-09-20 01:00:15,983 [myid:] - INFO  [main:ZooKeeper@716] - Initiating client connection, connectString=localhost:2181 sessionTimeout=30000 watcher=org.apache.zookeeper.ZooKeeperMain$MyWatcher@28b2311b
2016-09-20 01:00:16,013 [myid:] - INFO  [main-SendThread(localhost:2181):ClientCnxn$SendThread@1138] - Opening socket connection to server localhost/127.0.0.1:2181. Will not attempt to authenticate using SASL (unknown error)
2016-09-20 01:00:16,024 [myid:] - INFO  [main-SendThread(localhost:2181):ClientCnxn$SendThread@980] - Socket connection established, initiating session, client: /127.0.0.1:50296, server: localhost/127.0.0.1:2181
2016-09-20 01:00:16,136 [myid:] - INFO  [main-SendThread(localhost:2181):ClientCnxn$SendThread@1400] - Session establishment complete on server localhost/127.0.0.1:2181, sessionid = 0x1000048c0370000, negotiated timeout = 30000

WATCHER::

WatchedEvent state:SyncConnected type:None path:null
server.1=172.17.0.2:2888:3888:participant;0.0.0.0:2181
server.2=172.17.0.3:2888:3888:participant;0.0.0.0:2181
server.3=172.17.0.4:2888:3888:participant;0.0.0.0:2181
version=200000002

$ docker exec -i -t zookeeper2 ./zookeeper/bin/zkCli.sh -server localhost:2181 get /zookeeper/config
Connecting to localhost:2181
2016-09-20 01:00:34,676 [myid:] - INFO  [main:Environment@109] - Client environment:zookeeper.version=3.5.1-alpha-1693007, built on 07/28/2015 07:19 GMT
2016-09-20 01:00:34,681 [myid:] - INFO  [main:Environment@109] - Client environment:host.name=5d72c44b5f48
2016-09-20 01:00:34,682 [myid:] - INFO  [main:Environment@109] - Client environment:java.version=1.7.0_111
2016-09-20 01:00:34,687 [myid:] - INFO  [main:Environment@109] - Client environment:java.vendor=Oracle Corporation
2016-09-20 01:00:34,688 [myid:] - INFO  [main:Environment@109] - Client environment:java.home=/usr/lib/jvm/java-7-openjdk-amd64/jre
2016-09-20 01:00:34,689 [myid:] - INFO  [main:Environment@109] - Client environment:java.class.path=/home/zookeeper/zookeeper-3.5.1-alpha/bin/../build/classes:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../build/lib/*.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/slf4j-log4j12-1.7.5.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/slf4j-api-1.7.5.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/servlet-api-2.5-20081211.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/netty-3.7.0.Final.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/log4j-1.2.16.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jline-2.11.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jetty-util-6.1.26.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jetty-6.1.26.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/javacc.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jackson-mapper-asl-1.9.11.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jackson-core-asl-1.9.11.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/commons-cli-1.2.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../zookeeper-3.5.1-alpha.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../src/java/lib/*.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../conf:
2016-09-20 01:00:34,690 [myid:] - INFO  [main:Environment@109] - Client environment:java.library.path=/usr/java/packages/lib/amd64:/usr/lib/x86_64-linux-gnu/jni:/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu:/usr/lib/jni:/lib:/usr/lib
2016-09-20 01:00:34,690 [myid:] - INFO  [main:Environment@109] - Client environment:java.io.tmpdir=/tmp
2016-09-20 01:00:34,692 [myid:] - INFO  [main:Environment@109] - Client environment:java.compiler=<NA>
2016-09-20 01:00:34,693 [myid:] - INFO  [main:Environment@109] - Client environment:os.name=Linux
2016-09-20 01:00:34,694 [myid:] - INFO  [main:Environment@109] - Client environment:os.arch=amd64
2016-09-20 01:00:34,695 [myid:] - INFO  [main:Environment@109] - Client environment:os.version=4.4.20-moby
2016-09-20 01:00:34,696 [myid:] - INFO  [main:Environment@109] - Client environment:user.name=zookeeper
2016-09-20 01:00:34,696 [myid:] - INFO  [main:Environment@109] - Client environment:user.home=/home/zookeeper
2016-09-20 01:00:34,697 [myid:] - INFO  [main:Environment@109] - Client environment:user.dir=/home/zookeeper
2016-09-20 01:00:34,697 [myid:] - INFO  [main:Environment@109] - Client environment:os.memory.free=25MB
2016-09-20 01:00:34,700 [myid:] - INFO  [main:Environment@109] - Client environment:os.memory.max=227MB
2016-09-20 01:00:34,701 [myid:] - INFO  [main:Environment@109] - Client environment:os.memory.total=30MB
2016-09-20 01:00:34,707 [myid:] - INFO  [main:ZooKeeper@716] - Initiating client connection, connectString=localhost:2181 sessionTimeout=30000 watcher=org.apache.zookeeper.ZooKeeperMain$MyWatcher@28b2311b
2016-09-20 01:00:34,737 [myid:] - INFO  [main-SendThread(localhost:2181):ClientCnxn$SendThread@1138] - Opening socket connection to server localhost/127.0.0.1:2181. Will not attempt to authenticate using SASL (unknown error)
2016-09-20 01:00:34,754 [myid:] - INFO  [main-SendThread(localhost:2181):ClientCnxn$SendThread@980] - Socket connection established, initiating session, client: /127.0.0.1:50298, server: localhost/127.0.0.1:2181
2016-09-20 01:00:34,867 [myid:] - INFO  [main-SendThread(localhost:2181):ClientCnxn$SendThread@1400] - Session establishment complete on server localhost/127.0.0.1:2181, sessionid = 0x2000048bf5e0000, negotiated timeout = 30000

WATCHER::

WatchedEvent state:SyncConnected type:None path:null
server.1=172.17.0.2:2888:3888:participant;0.0.0.0:2181
server.2=172.17.0.3:2888:3888:participant;0.0.0.0:2181
server.3=172.17.0.4:2888:3888:participant;0.0.0.0:2181
version=200000002

$ docker exec -i -t zookeeper3 ./zookeeper/bin/zkCli.sh -server localhost:2181 get /zookeeper/config
Connecting to localhost:2181
2016-09-20 01:00:55,312 [myid:] - INFO  [main:Environment@109] - Client environment:zookeeper.version=3.5.1-alpha-1693007, built on 07/28/2015 07:19 GMT
2016-09-20 01:00:55,316 [myid:] - INFO  [main:Environment@109] - Client environment:host.name=110333f712de
2016-09-20 01:00:55,316 [myid:] - INFO  [main:Environment@109] - Client environment:java.version=1.7.0_111
2016-09-20 01:00:55,321 [myid:] - INFO  [main:Environment@109] - Client environment:java.vendor=Oracle Corporation
2016-09-20 01:00:55,322 [myid:] - INFO  [main:Environment@109] - Client environment:java.home=/usr/lib/jvm/java-7-openjdk-amd64/jre
2016-09-20 01:00:55,322 [myid:] - INFO  [main:Environment@109] - Client environment:java.class.path=/home/zookeeper/zookeeper-3.5.1-alpha/bin/../build/classes:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../build/lib/*.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/slf4j-log4j12-1.7.5.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/slf4j-api-1.7.5.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/servlet-api-2.5-20081211.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/netty-3.7.0.Final.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/log4j-1.2.16.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jline-2.11.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jetty-util-6.1.26.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jetty-6.1.26.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/javacc.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jackson-mapper-asl-1.9.11.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jackson-core-asl-1.9.11.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/commons-cli-1.2.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../zookeeper-3.5.1-alpha.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../src/java/lib/*.jar:/home/zookeeper/zookeeper-3.5.1-alpha/bin/../conf:
2016-09-20 01:00:55,323 [myid:] - INFO  [main:Environment@109] - Client environment:java.library.path=/usr/java/packages/lib/amd64:/usr/lib/x86_64-linux-gnu/jni:/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu:/usr/lib/jni:/lib:/usr/lib
2016-09-20 01:00:55,323 [myid:] - INFO  [main:Environment@109] - Client environment:java.io.tmpdir=/tmp
2016-09-20 01:00:55,324 [myid:] - INFO  [main:Environment@109] - Client environment:java.compiler=<NA>
2016-09-20 01:00:55,324 [myid:] - INFO  [main:Environment@109] - Client environment:os.name=Linux
2016-09-20 01:00:55,324 [myid:] - INFO  [main:Environment@109] - Client environment:os.arch=amd64
2016-09-20 01:00:55,325 [myid:] - INFO  [main:Environment@109] - Client environment:os.version=4.4.20-moby
2016-09-20 01:00:55,325 [myid:] - INFO  [main:Environment@109] - Client environment:user.name=zookeeper
2016-09-20 01:00:55,325 [myid:] - INFO  [main:Environment@109] - Client environment:user.home=/home/zookeeper
2016-09-20 01:00:55,326 [myid:] - INFO  [main:Environment@109] - Client environment:user.dir=/home/zookeeper
2016-09-20 01:00:55,326 [myid:] - INFO  [main:Environment@109] - Client environment:os.memory.free=25MB
2016-09-20 01:00:55,330 [myid:] - INFO  [main:Environment@109] - Client environment:os.memory.max=227MB
2016-09-20 01:00:55,330 [myid:] - INFO  [main:Environment@109] - Client environment:os.memory.total=30MB
2016-09-20 01:00:55,337 [myid:] - INFO  [main:ZooKeeper@716] - Initiating client connection, connectString=localhost:2181 sessionTimeout=30000 watcher=org.apache.zookeeper.ZooKeeperMain$MyWatcher@28b2311b
2016-09-20 01:00:55,363 [myid:] - INFO  [main-SendThread(localhost:2181):ClientCnxn$SendThread@1138] - Opening socket connection to server localhost/0:0:0:0:0:0:0:1:2181. Will not attempt to authenticate using SASL (unknown error)
2016-09-20 01:00:55,376 [myid:] - INFO  [main-SendThread(localhost:2181):ClientCnxn$SendThread@980] - Socket connection established, initiating session, client: /0:0:0:0:0:0:0:1:53046, server: localhost/0:0:0:0:0:0:0:1:2181
2016-09-20 01:00:55,521 [myid:] - INFO  [main-SendThread(localhost:2181):ClientCnxn$SendThread@1400] - Session establishment complete on server localhost/0:0:0:0:0:0:0:1:2181, sessionid = 0x300004920e00000, negotiated timeout = 30000

WATCHER::

WatchedEvent state:SyncConnected type:None path:null
server.1=172.17.0.2:2888:3888:participant;0.0.0.0:2181
server.2=172.17.0.3:2888:3888:participant;0.0.0.0:2181
server.3=172.17.0.4:2888:3888:participant;0.0.0.0:2181
version=200000002
```

#### 5. Stop ZooKeeper

```sh
$ docker stop zookeeper1 zookeeper2 zookeeper3; docker rm zookeeper1 zookeeper2 zookeeper3
zookeeper1
zookeeper2
zookeeper3
zookeeper1
zookeeper2
zookeeper3
```
