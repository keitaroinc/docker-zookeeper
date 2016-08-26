# docker-zookeeper

This is a Docker image for Apache ZooKeeper.

## What is ZooKeeper?

[ZooKeeper](https://zookeeper.apache.org) is a centralized service for maintaining configuration information, naming, providing distributed synchronization, and providing group services. All of these kinds of services are used in some form or another by distributed applications. Each time they are implemented there is a lot of work that goes into fixing the bugs and race conditions that are inevitable. Because of the difficulty of implementing these kinds of services, applications initially usually skimp on them ,which make them brittle in the presence of change and difficult to manage. Even when done correctly, different implementations of these services lead to management complexity when the applications are deployed.

Learn more about ZooKeeper on the [ZooKeeper Wiki](https://cwiki.apache.org/confluence/display/ZOOKEEPER/Index).

## How to build this Docker image

```
$ git clone git@github.com:mosuka/docker-zookeeper.git ${HOME}/git/docker-zookeeper
$ cd ${HOME}/git/docker-zookeeper
$ docker build -t mosuka/docker-zookeeper:3.5.1 .
```

## How to use this Docker image

### Standalone ZooKeeper example

#### 1. Start standalone ZooKeeper

```sh
$ docker run -d -p 2182:2181 --name zookeeper mosuka/docker-zookeeper:3.5.1
8e5e4e829b0ad42d0e0400620c3fd045021ebf2926cf5c47f9e54d634ff1d37d

$ ZOOKEEPER_CONTAINER_IP=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' zookeeper)
$ echo ${ZOOKEEPER_CONTAINER_IP}
172.17.0.2
```

#### 2. Check container ID

```sh
$ docker ps
CONTAINER ID        IMAGE                           COMMAND                  CREATED             STATUS              PORTS                                        NAMES
8e5e4e829b0a        mosuka/docker-zookeeper:3.5.1   "/usr/local/bin/docke"   15 minutes ago      Up 36 seconds       2888/tcp, 3888/tcp, 0.0.0.0:2182->2181/tcp   zookeeper
```

#### 3. Get host IP

```sh
$ ZOOKEEPER_HOST_IP=$(docker-machine ip default)
$ ZOOKEEPER_HOST_IP=${ZOOKEEPER_HOST_IP:-127.0.0.1}
$ echo ${ZOOKEEPER_HOST_IP}
192.168.99.101

$ ZOOKEEPER_HOST_PORT=$(docker inspect -f '{{ $port := index .NetworkSettings.Ports "2181/tcp" }}{{ range $port }}{{ .HostPort }}{{ end }}' zookeeper)
$ echo ${ZOOKEEPER_HOST_PORT}
2182
```

#### 4. Connect to ZooKeeper using zkCli.sh on the local machine

```sh
$ ${HOME}/zookeeper/zookeeper-3.5.1-alpha/bin/zkCli.sh -server ${ZOOKEEPER_HOST_IP}:${ZOOKEEPER_HOST_PORT} get /zookeeper/config
Connecting to 192.168.99.101:2182
2016-03-22 12:25:00,298 [myid:] - INFO  [main:Environment@109] - Client environment:zookeeper.version=3.5.1-alpha-1693007, built on 07/28/2015 07:19 GMT
2016-03-22 12:25:00,306 [myid:] - INFO  [main:Environment@109] - Client environment:host.name=192.168.99.1
2016-03-22 12:25:00,306 [myid:] - INFO  [main:Environment@109] - Client environment:java.version=1.8.0_65
2016-03-22 12:25:00,312 [myid:] - INFO  [main:Environment@109] - Client environment:java.vendor=Oracle Corporation
2016-03-22 12:25:00,313 [myid:] - INFO  [main:Environment@109] - Client environment:java.home=/Library/Java/JavaVirtualMachines/jdk1.8.0_65.jdk/Contents/Home/jre
2016-03-22 12:25:00,313 [myid:] - INFO  [main:Environment@109] - Client environment:java.class.path=/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../build/classes:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../build/lib/*.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/slf4j-log4j12-1.7.5.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/slf4j-api-1.7.5.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/servlet-api-2.5-20081211.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/netty-3.7.0.Final.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/log4j-1.2.16.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jline-2.11.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jetty-util-6.1.26.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jetty-6.1.26.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/javacc.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jackson-mapper-asl-1.9.11.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jackson-core-asl-1.9.11.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/commons-cli-1.2.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../zookeeper-3.5.1-alpha.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../src/java/lib/*.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../conf:
2016-03-22 12:25:00,313 [myid:] - INFO  [main:Environment@109] - Client environment:java.library.path=/Users/mosuka/Library/Java/Extensions:/Library/Java/Extensions:/Network/Library/Java/Extensions:/System/Library/Java/Extensions:/usr/lib/java:.
2016-03-22 12:25:00,314 [myid:] - INFO  [main:Environment@109] - Client environment:java.io.tmpdir=/var/folders/99/p369dv7n5sqdl9rdvyx0vqzr0000gn/T/
2016-03-22 12:25:00,314 [myid:] - INFO  [main:Environment@109] - Client environment:java.compiler=<NA>
2016-03-22 12:25:00,314 [myid:] - INFO  [main:Environment@109] - Client environment:os.name=Mac OS X
2016-03-22 12:25:00,314 [myid:] - INFO  [main:Environment@109] - Client environment:os.arch=x86_64
2016-03-22 12:25:00,314 [myid:] - INFO  [main:Environment@109] - Client environment:os.version=10.11.3
2016-03-22 12:25:00,314 [myid:] - INFO  [main:Environment@109] - Client environment:user.name=mosuka
2016-03-22 12:25:00,314 [myid:] - INFO  [main:Environment@109] - Client environment:user.home=/Users/mosuka
2016-03-22 12:25:00,315 [myid:] - INFO  [main:Environment@109] - Client environment:user.dir=/Users/mosuka/git/docker-zookeeper
2016-03-22 12:25:00,315 [myid:] - INFO  [main:Environment@109] - Client environment:os.memory.free=117MB
2016-03-22 12:25:00,317 [myid:] - INFO  [main:Environment@109] - Client environment:os.memory.max=228MB
2016-03-22 12:25:00,318 [myid:] - INFO  [main:Environment@109] - Client environment:os.memory.total=123MB
2016-03-22 12:25:00,324 [myid:] - INFO  [main:ZooKeeper@716] - Initiating client connection, connectString=192.168.99.101:2182 sessionTimeout=30000 watcher=org.apache.zookeeper.ZooKeeperMain$MyWatcher@593634ad
2016-03-22 12:25:00,403 [myid:] - INFO  [main-SendThread(192.168.99.101:2182):ClientCnxn$SendThread@1138] - Opening socket connection to server 192.168.99.101/192.168.99.101:2182. Will not attempt to authenticate using SASL (unknown error)
2016-03-22 12:25:00,768 [myid:] - INFO  [main-SendThread(192.168.99.101:2182):ClientCnxn$SendThread@980] - Socket connection established, initiating session, client: /192.168.99.1:56898, server: 192.168.99.101/192.168.99.101:2182
2016-03-22 12:25:00,800 [myid:] - INFO  [main-SendThread(192.168.99.101:2182):ClientCnxn$SendThread@1400] - Session establishment complete on server 192.168.99.101/192.168.99.101:2182, sessionid = 0x10000b1869e0000, negotiated timeout = 30000

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

### ZooKeeper ensemble (3 nodes) example using ZOOKEEPER_SEED_HOST and ZOOKEEPER_SEED_PORT

#### 1. Start ZooKeeper

```sh
$ docker run -d -p 2182:2181 --name zookeeper1 mosuka/docker-zookeeper:3.5.1
98be9f02ca78c27f2de65a03eba13541f5a4c7b649a3c42dbbd1e159f9edc445

$ ZOOKEEPER_1_CONTAINER_IP=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' zookeeper1)
$ echo ${ZOOKEEPER_1_CONTAINER_IP}
172.17.0.2

$ docker run -d -p 2183:2181 --name zookeeper2 -e ZOOKEEPER_SEED_HOST=${ZOOKEEPER_1_CONTAINER_IP} mosuka/docker-zookeeper:3.5.1
3f4e90c90d7635319deac5756bb21f7c4da4270ebfd0102fc201befdca78a673

$ ZOOKEEPER_2_CONTAINER_IP=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' zookeeper2)
$ echo ${ZOOKEEPER_2_CONTAINER_IP}
172.17.0.3

$ docker run -d -p 2184:2181 --name zookeeper3 -e ZOOKEEPER_SEED_HOST=${ZOOKEEPER_2_CONTAINER_IP} mosuka/docker-zookeeper:3.5.1
a0c84a6d592345208387acb255c10f557b86d9eb7c560e3e8d77ef993d9acf25

$ ZOOKEEPER_3_CONTAINER_IP=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' zookeeper3)
$ echo ${ZOOKEEPER_3_CONTAINER_IP}
172.17.0.4
```

#### 2. Check container ID

```sh
$ docker ps
CONTAINER ID        IMAGE                           COMMAND                  CREATED              STATUS              PORTS                                        NAMES
09f7d69f533d        mosuka/docker-zookeeper:3.5.1   "/usr/local/bin/docke"   28 seconds ago       Up 28 seconds       2888/tcp, 3888/tcp, 0.0.0.0:2184->2181/tcp   zookeeper3
ce95a9734003        mosuka/docker-zookeeper:3.5.1   "/usr/local/bin/docke"   About a minute ago   Up About a minute   2888/tcp, 3888/tcp, 0.0.0.0:2183->2181/tcp   zookeeper2
71a97cff24d4        mosuka/docker-zookeeper:3.5.1   "/usr/local/bin/docke"   2 minutes ago        Up 2 minutes        2888/tcp, 3888/tcp, 0.0.0.0:2182->2181/tcp   zookeeper1
```

#### 3. Get host IP

```sh
$ ZOOKEEPER_HOST_IP=$(docker-machine ip default)
$ ZOOKEEPER_HOST_IP=${ZOOKEEPER_HOST_IP:-127.0.0.1}
$ echo ${ZOOKEEPER_HOST_IP}
192.168.99.100

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
$ ${HOME}/zookeeper/zookeeper-3.5.1-alpha/bin/zkCli.sh -server ${ZOOKEEPER_HOST_IP}:${ZOOKEEPER_1_HOST_PORT} get /zookeeper/config
Connecting to 192.168.99.100:2182
2016-03-23 17:00:37,518 [myid:] - INFO  [main:Environment@109] - Client environment:zookeeper.version=3.5.1-alpha-1693007, built on 07/28/2015 07:19 GMT
2016-03-23 17:00:37,526 [myid:] - INFO  [main:Environment@109] - Client environment:host.name=172.24.230.16
2016-03-23 17:00:37,526 [myid:] - INFO  [main:Environment@109] - Client environment:java.version=1.8.0_65
2016-03-23 17:00:37,532 [myid:] - INFO  [main:Environment@109] - Client environment:java.vendor=Oracle Corporation
2016-03-23 17:00:37,532 [myid:] - INFO  [main:Environment@109] - Client environment:java.home=/Library/Java/JavaVirtualMachines/jdk1.8.0_65.jdk/Contents/Home/jre
2016-03-23 17:00:37,532 [myid:] - INFO  [main:Environment@109] - Client environment:java.class.path=/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../build/classes:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../build/lib/*.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/slf4j-log4j12-1.7.5.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/slf4j-api-1.7.5.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/servlet-api-2.5-20081211.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/netty-3.7.0.Final.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/log4j-1.2.16.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jline-2.11.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jetty-util-6.1.26.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jetty-6.1.26.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/javacc.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jackson-mapper-asl-1.9.11.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jackson-core-asl-1.9.11.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/commons-cli-1.2.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../zookeeper-3.5.1-alpha.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../src/java/lib/*.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../conf:
2016-03-23 17:00:37,532 [myid:] - INFO  [main:Environment@109] - Client environment:java.library.path=/Users/mosuka/Library/Java/Extensions:/Library/Java/Extensions:/Network/Library/Java/Extensions:/System/Library/Java/Extensions:/usr/lib/java:.
2016-03-23 17:00:37,532 [myid:] - INFO  [main:Environment@109] - Client environment:java.io.tmpdir=/var/folders/99/p369dv7n5sqdl9rdvyx0vqzr0000gn/T/
2016-03-23 17:00:37,533 [myid:] - INFO  [main:Environment@109] - Client environment:java.compiler=<NA>
2016-03-23 17:00:37,533 [myid:] - INFO  [main:Environment@109] - Client environment:os.name=Mac OS X
2016-03-23 17:00:37,533 [myid:] - INFO  [main:Environment@109] - Client environment:os.arch=x86_64
2016-03-23 17:00:37,533 [myid:] - INFO  [main:Environment@109] - Client environment:os.version=10.11.4
2016-03-23 17:00:37,533 [myid:] - INFO  [main:Environment@109] - Client environment:user.name=mosuka
2016-03-23 17:00:37,533 [myid:] - INFO  [main:Environment@109] - Client environment:user.home=/Users/mosuka
2016-03-23 17:00:37,534 [myid:] - INFO  [main:Environment@109] - Client environment:user.dir=/Users/mosuka/git/docker-solr
2016-03-23 17:00:37,534 [myid:] - INFO  [main:Environment@109] - Client environment:os.memory.free=117MB
2016-03-23 17:00:37,537 [myid:] - INFO  [main:Environment@109] - Client environment:os.memory.max=228MB
2016-03-23 17:00:37,537 [myid:] - INFO  [main:Environment@109] - Client environment:os.memory.total=123MB
2016-03-23 17:00:37,543 [myid:] - INFO  [main:ZooKeeper@716] - Initiating client connection, connectString=192.168.99.100:2182 sessionTimeout=30000 watcher=org.apache.zookeeper.ZooKeeperMain$MyWatcher@593634ad
2016-03-23 17:00:37,614 [myid:] - INFO  [main-SendThread(192.168.99.100:2182):ClientCnxn$SendThread@1138] - Opening socket connection to server 192.168.99.100/192.168.99.100:2182. Will not attempt to authenticate using SASL (unknown error)
2016-03-23 17:00:37,792 [myid:] - INFO  [main-SendThread(192.168.99.100:2182):ClientCnxn$SendThread@980] - Socket connection established, initiating session, client: /192.168.99.1:54009, server: 192.168.99.100/192.168.99.100:2182
2016-03-23 17:00:37,807 [myid:] - INFO  [main-SendThread(192.168.99.100:2182):ClientCnxn$SendThread@1400] - Session establishment complete on server 192.168.99.100/192.168.99.100:2182, sessionid = 0x10001a31c770000, negotiated timeout = 30000

WATCHER::

WatchedEvent state:SyncConnected type:None path:null
server.1=172.17.0.2:2888:3888:participant;0.0.0.0:2181
server.2=172.17.0.3:2888:3888:participant;0.0.0.0:2181
server.3=172.17.0.4:2888:3888:participant;0.0.0.0:2181
version=200000003

$ ${HOME}/zookeeper/zookeeper-3.5.1-alpha/bin/zkCli.sh -server ${ZOOKEEPER_HOST_IP}:${ZOOKEEPER_2_HOST_PORT} get /zookeeper/config
Connecting to 192.168.99.100:2183
2016-03-23 17:01:07,073 [myid:] - INFO  [main:Environment@109] - Client environment:zookeeper.version=3.5.1-alpha-1693007, built on 07/28/2015 07:19 GMT
2016-03-23 17:01:07,078 [myid:] - INFO  [main:Environment@109] - Client environment:host.name=172.24.230.16
2016-03-23 17:01:07,078 [myid:] - INFO  [main:Environment@109] - Client environment:java.version=1.8.0_65
2016-03-23 17:01:07,081 [myid:] - INFO  [main:Environment@109] - Client environment:java.vendor=Oracle Corporation
2016-03-23 17:01:07,082 [myid:] - INFO  [main:Environment@109] - Client environment:java.home=/Library/Java/JavaVirtualMachines/jdk1.8.0_65.jdk/Contents/Home/jre
2016-03-23 17:01:07,082 [myid:] - INFO  [main:Environment@109] - Client environment:java.class.path=/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../build/classes:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../build/lib/*.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/slf4j-log4j12-1.7.5.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/slf4j-api-1.7.5.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/servlet-api-2.5-20081211.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/netty-3.7.0.Final.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/log4j-1.2.16.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jline-2.11.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jetty-util-6.1.26.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jetty-6.1.26.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/javacc.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jackson-mapper-asl-1.9.11.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jackson-core-asl-1.9.11.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/commons-cli-1.2.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../zookeeper-3.5.1-alpha.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../src/java/lib/*.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../conf:
2016-03-23 17:01:07,082 [myid:] - INFO  [main:Environment@109] - Client environment:java.library.path=/Users/mosuka/Library/Java/Extensions:/Library/Java/Extensions:/Network/Library/Java/Extensions:/System/Library/Java/Extensions:/usr/lib/java:.
2016-03-23 17:01:07,082 [myid:] - INFO  [main:Environment@109] - Client environment:java.io.tmpdir=/var/folders/99/p369dv7n5sqdl9rdvyx0vqzr0000gn/T/
2016-03-23 17:01:07,082 [myid:] - INFO  [main:Environment@109] - Client environment:java.compiler=<NA>
2016-03-23 17:01:07,083 [myid:] - INFO  [main:Environment@109] - Client environment:os.name=Mac OS X
2016-03-23 17:01:07,083 [myid:] - INFO  [main:Environment@109] - Client environment:os.arch=x86_64
2016-03-23 17:01:07,083 [myid:] - INFO  [main:Environment@109] - Client environment:os.version=10.11.4
2016-03-23 17:01:07,083 [myid:] - INFO  [main:Environment@109] - Client environment:user.name=mosuka
2016-03-23 17:01:07,083 [myid:] - INFO  [main:Environment@109] - Client environment:user.home=/Users/mosuka
2016-03-23 17:01:07,083 [myid:] - INFO  [main:Environment@109] - Client environment:user.dir=/Users/mosuka/git/docker-solr
2016-03-23 17:01:07,084 [myid:] - INFO  [main:Environment@109] - Client environment:os.memory.free=117MB
2016-03-23 17:01:07,086 [myid:] - INFO  [main:Environment@109] - Client environment:os.memory.max=228MB
2016-03-23 17:01:07,086 [myid:] - INFO  [main:Environment@109] - Client environment:os.memory.total=123MB
2016-03-23 17:01:07,090 [myid:] - INFO  [main:ZooKeeper@716] - Initiating client connection, connectString=192.168.99.100:2183 sessionTimeout=30000 watcher=org.apache.zookeeper.ZooKeeperMain$MyWatcher@593634ad
2016-03-23 17:01:07,141 [myid:] - INFO  [main-SendThread(192.168.99.100:2183):ClientCnxn$SendThread@1138] - Opening socket connection to server 192.168.99.100/192.168.99.100:2183. Will not attempt to authenticate using SASL (unknown error)
2016-03-23 17:01:07,275 [myid:] - INFO  [main-SendThread(192.168.99.100:2183):ClientCnxn$SendThread@980] - Socket connection established, initiating session, client: /192.168.99.1:54012, server: 192.168.99.100/192.168.99.100:2183
2016-03-23 17:01:07,293 [myid:] - INFO  [main-SendThread(192.168.99.100:2183):ClientCnxn$SendThread@1400] - Session establishment complete on server 192.168.99.100/192.168.99.100:2183, sessionid = 0x20001a31c610002, negotiated timeout = 30000

WATCHER::

WatchedEvent state:SyncConnected type:None path:null
server.1=172.17.0.2:2888:3888:participant;0.0.0.0:2181
server.2=172.17.0.3:2888:3888:participant;0.0.0.0:2181
server.3=172.17.0.4:2888:3888:participant;0.0.0.0:2181
version=200000003

$ ${HOME}/zookeeper/zookeeper-3.5.1-alpha/bin/zkCli.sh -server ${ZOOKEEPER_HOST_IP}:${ZOOKEEPER_3_HOST_PORT} get /zookeeper/config
Connecting to 192.168.99.100:2184
2016-03-23 17:01:23,715 [myid:] - INFO  [main:Environment@109] - Client environment:zookeeper.version=3.5.1-alpha-1693007, built on 07/28/2015 07:19 GMT
2016-03-23 17:01:23,719 [myid:] - INFO  [main:Environment@109] - Client environment:host.name=172.24.230.16
2016-03-23 17:01:23,719 [myid:] - INFO  [main:Environment@109] - Client environment:java.version=1.8.0_65
2016-03-23 17:01:23,721 [myid:] - INFO  [main:Environment@109] - Client environment:java.vendor=Oracle Corporation
2016-03-23 17:01:23,721 [myid:] - INFO  [main:Environment@109] - Client environment:java.home=/Library/Java/JavaVirtualMachines/jdk1.8.0_65.jdk/Contents/Home/jre
2016-03-23 17:01:23,721 [myid:] - INFO  [main:Environment@109] - Client environment:java.class.path=/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../build/classes:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../build/lib/*.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/slf4j-log4j12-1.7.5.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/slf4j-api-1.7.5.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/servlet-api-2.5-20081211.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/netty-3.7.0.Final.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/log4j-1.2.16.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jline-2.11.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jetty-util-6.1.26.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jetty-6.1.26.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/javacc.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jackson-mapper-asl-1.9.11.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jackson-core-asl-1.9.11.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/commons-cli-1.2.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../zookeeper-3.5.1-alpha.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../src/java/lib/*.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../conf:
2016-03-23 17:01:23,722 [myid:] - INFO  [main:Environment@109] - Client environment:java.library.path=/Users/mosuka/Library/Java/Extensions:/Library/Java/Extensions:/Network/Library/Java/Extensions:/System/Library/Java/Extensions:/usr/lib/java:.
2016-03-23 17:01:23,722 [myid:] - INFO  [main:Environment@109] - Client environment:java.io.tmpdir=/var/folders/99/p369dv7n5sqdl9rdvyx0vqzr0000gn/T/
2016-03-23 17:01:23,722 [myid:] - INFO  [main:Environment@109] - Client environment:java.compiler=<NA>
2016-03-23 17:01:23,722 [myid:] - INFO  [main:Environment@109] - Client environment:os.name=Mac OS X
2016-03-23 17:01:23,722 [myid:] - INFO  [main:Environment@109] - Client environment:os.arch=x86_64
2016-03-23 17:01:23,722 [myid:] - INFO  [main:Environment@109] - Client environment:os.version=10.11.4
2016-03-23 17:01:23,722 [myid:] - INFO  [main:Environment@109] - Client environment:user.name=mosuka
2016-03-23 17:01:23,723 [myid:] - INFO  [main:Environment@109] - Client environment:user.home=/Users/mosuka
2016-03-23 17:01:23,723 [myid:] - INFO  [main:Environment@109] - Client environment:user.dir=/Users/mosuka/git/docker-solr
2016-03-23 17:01:23,723 [myid:] - INFO  [main:Environment@109] - Client environment:os.memory.free=117MB
2016-03-23 17:01:23,725 [myid:] - INFO  [main:Environment@109] - Client environment:os.memory.max=228MB
2016-03-23 17:01:23,725 [myid:] - INFO  [main:Environment@109] - Client environment:os.memory.total=123MB
2016-03-23 17:01:23,730 [myid:] - INFO  [main:ZooKeeper@716] - Initiating client connection, connectString=192.168.99.100:2184 sessionTimeout=30000 watcher=org.apache.zookeeper.ZooKeeperMain$MyWatcher@593634ad
2016-03-23 17:01:23,767 [myid:] - INFO  [main-SendThread(192.168.99.100:2184):ClientCnxn$SendThread@1138] - Opening socket connection to server 192.168.99.100/192.168.99.100:2184. Will not attempt to authenticate using SASL (unknown error)
2016-03-23 17:01:23,913 [myid:] - INFO  [main-SendThread(192.168.99.100:2184):ClientCnxn$SendThread@980] - Socket connection established, initiating session, client: /192.168.99.1:54015, server: 192.168.99.100/192.168.99.100:2184
2016-03-23 17:01:23,937 [myid:] - INFO  [main-SendThread(192.168.99.100:2184):ClientCnxn$SendThread@1400] - Session establishment complete on server 192.168.99.100/192.168.99.100:2184, sessionid = 0x30001a35e820000, negotiated timeout = 30000

WATCHER::

WatchedEvent state:SyncConnected type:None path:null
server.1=172.17.0.2:2888:3888:participant;0.0.0.0:2181
server.2=172.17.0.3:2888:3888:participant;0.0.0.0:2181
server.3=172.17.0.4:2888:3888:participant;0.0.0.0:2181
version=200000003
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

docker run -d -p 2182:2181 --name zookeeper1 -e ZOOKEEPER_HOST_LIST="" mosuka/docker-zookeeper:3.5.1
docker run -d -p 2183:2181 --name zookeeper2 -e ZOOKEEPER_HOST_LIST="172.17.0.2" mosuka/docker-zookeeper:3.5.1
docker run -d -p 2184:2181 --name zookeeper3 -e ZOOKEEPER_HOST_LIST="172.17.0.2 172.17.0.3" mosuka/docker-zookeeper:3.5.1

```sh
$ docker run -d -p 2182:2181 --name zookeeper1 -e ZOOKEEPER_HOST_LIST="" mosuka/docker-zookeeper:3.5.1
98be9f02ca78c27f2de65a03eba13541f5a4c7b649a3c42dbbd1e159f9edc445

$ ZOOKEEPER_1_CONTAINER_IP=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' zookeeper1)
$ echo ${ZOOKEEPER_1_CONTAINER_IP}
172.17.0.2

$ docker run -d -p 2183:2181 --name zookeeper2 -e ZOOKEEPER_HOST_LIST="172.17.0.2" mosuka/docker-zookeeper:3.5.1
3f4e90c90d7635319deac5756bb21f7c4da4270ebfd0102fc201befdca78a673

$ ZOOKEEPER_2_CONTAINER_IP=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' zookeeper2)
$ echo ${ZOOKEEPER_2_CONTAINER_IP}
172.17.0.3

$ docker run -d -p 2184:2181 --name zookeeper3 -e ZOOKEEPER_HOST_LIST="172.17.0.2 172.17.0.3" mosuka/docker-zookeeper:3.5.1
a0c84a6d592345208387acb255c10f557b86d9eb7c560e3e8d77ef993d9acf25

$ ZOOKEEPER_3_CONTAINER_IP=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' zookeeper3)
$ echo ${ZOOKEEPER_3_CONTAINER_IP}
172.17.0.4
```

#### 2. Check container ID

```sh
$ docker ps
CONTAINER ID        IMAGE                           COMMAND                  CREATED              STATUS              PORTS                                        NAMES
09f7d69f533d        mosuka/docker-zookeeper:3.5.1   "/usr/local/bin/docke"   28 seconds ago       Up 28 seconds       2888/tcp, 3888/tcp, 0.0.0.0:2184->2181/tcp   zookeeper3
ce95a9734003        mosuka/docker-zookeeper:3.5.1   "/usr/local/bin/docke"   About a minute ago   Up About a minute   2888/tcp, 3888/tcp, 0.0.0.0:2183->2181/tcp   zookeeper2
71a97cff24d4        mosuka/docker-zookeeper:3.5.1   "/usr/local/bin/docke"   2 minutes ago        Up 2 minutes        2888/tcp, 3888/tcp, 0.0.0.0:2182->2181/tcp   zookeeper1
```

#### 3. Get host IP

```sh
$ ZOOKEEPER_HOST_IP=$(docker-machine ip default)
$ ZOOKEEPER_HOST_IP=${ZOOKEEPER_HOST_IP:-127.0.0.1}
$ echo ${ZOOKEEPER_HOST_IP}
192.168.99.100

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
$ ${HOME}/zookeeper/zookeeper-3.5.1-alpha/bin/zkCli.sh -server ${ZOOKEEPER_HOST_IP}:${ZOOKEEPER_1_HOST_PORT} get /zookeeper/config
Connecting to 192.168.99.100:2182
2016-03-23 17:00:37,518 [myid:] - INFO  [main:Environment@109] - Client environment:zookeeper.version=3.5.1-alpha-1693007, built on 07/28/2015 07:19 GMT
2016-03-23 17:00:37,526 [myid:] - INFO  [main:Environment@109] - Client environment:host.name=172.24.230.16
2016-03-23 17:00:37,526 [myid:] - INFO  [main:Environment@109] - Client environment:java.version=1.8.0_65
2016-03-23 17:00:37,532 [myid:] - INFO  [main:Environment@109] - Client environment:java.vendor=Oracle Corporation
2016-03-23 17:00:37,532 [myid:] - INFO  [main:Environment@109] - Client environment:java.home=/Library/Java/JavaVirtualMachines/jdk1.8.0_65.jdk/Contents/Home/jre
2016-03-23 17:00:37,532 [myid:] - INFO  [main:Environment@109] - Client environment:java.class.path=/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../build/classes:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../build/lib/*.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/slf4j-log4j12-1.7.5.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/slf4j-api-1.7.5.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/servlet-api-2.5-20081211.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/netty-3.7.0.Final.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/log4j-1.2.16.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jline-2.11.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jetty-util-6.1.26.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jetty-6.1.26.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/javacc.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jackson-mapper-asl-1.9.11.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jackson-core-asl-1.9.11.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/commons-cli-1.2.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../zookeeper-3.5.1-alpha.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../src/java/lib/*.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../conf:
2016-03-23 17:00:37,532 [myid:] - INFO  [main:Environment@109] - Client environment:java.library.path=/Users/mosuka/Library/Java/Extensions:/Library/Java/Extensions:/Network/Library/Java/Extensions:/System/Library/Java/Extensions:/usr/lib/java:.
2016-03-23 17:00:37,532 [myid:] - INFO  [main:Environment@109] - Client environment:java.io.tmpdir=/var/folders/99/p369dv7n5sqdl9rdvyx0vqzr0000gn/T/
2016-03-23 17:00:37,533 [myid:] - INFO  [main:Environment@109] - Client environment:java.compiler=<NA>
2016-03-23 17:00:37,533 [myid:] - INFO  [main:Environment@109] - Client environment:os.name=Mac OS X
2016-03-23 17:00:37,533 [myid:] - INFO  [main:Environment@109] - Client environment:os.arch=x86_64
2016-03-23 17:00:37,533 [myid:] - INFO  [main:Environment@109] - Client environment:os.version=10.11.4
2016-03-23 17:00:37,533 [myid:] - INFO  [main:Environment@109] - Client environment:user.name=mosuka
2016-03-23 17:00:37,533 [myid:] - INFO  [main:Environment@109] - Client environment:user.home=/Users/mosuka
2016-03-23 17:00:37,534 [myid:] - INFO  [main:Environment@109] - Client environment:user.dir=/Users/mosuka/git/docker-solr
2016-03-23 17:00:37,534 [myid:] - INFO  [main:Environment@109] - Client environment:os.memory.free=117MB
2016-03-23 17:00:37,537 [myid:] - INFO  [main:Environment@109] - Client environment:os.memory.max=228MB
2016-03-23 17:00:37,537 [myid:] - INFO  [main:Environment@109] - Client environment:os.memory.total=123MB
2016-03-23 17:00:37,543 [myid:] - INFO  [main:ZooKeeper@716] - Initiating client connection, connectString=192.168.99.100:2182 sessionTimeout=30000 watcher=org.apache.zookeeper.ZooKeeperMain$MyWatcher@593634ad
2016-03-23 17:00:37,614 [myid:] - INFO  [main-SendThread(192.168.99.100:2182):ClientCnxn$SendThread@1138] - Opening socket connection to server 192.168.99.100/192.168.99.100:2182. Will not attempt to authenticate using SASL (unknown error)
2016-03-23 17:00:37,792 [myid:] - INFO  [main-SendThread(192.168.99.100:2182):ClientCnxn$SendThread@980] - Socket connection established, initiating session, client: /192.168.99.1:54009, server: 192.168.99.100/192.168.99.100:2182
2016-03-23 17:00:37,807 [myid:] - INFO  [main-SendThread(192.168.99.100:2182):ClientCnxn$SendThread@1400] - Session establishment complete on server 192.168.99.100/192.168.99.100:2182, sessionid = 0x10001a31c770000, negotiated timeout = 30000

WATCHER::

WatchedEvent state:SyncConnected type:None path:null
server.1=172.17.0.2:2888:3888:participant;0.0.0.0:2181
server.2=172.17.0.3:2888:3888:participant;0.0.0.0:2181
server.3=172.17.0.4:2888:3888:participant;0.0.0.0:2181
version=200000003

$ ${HOME}/zookeeper/zookeeper-3.5.1-alpha/bin/zkCli.sh -server ${ZOOKEEPER_HOST_IP}:${ZOOKEEPER_2_HOST_PORT} get /zookeeper/config
Connecting to 192.168.99.100:2183
2016-03-23 17:01:07,073 [myid:] - INFO  [main:Environment@109] - Client environment:zookeeper.version=3.5.1-alpha-1693007, built on 07/28/2015 07:19 GMT
2016-03-23 17:01:07,078 [myid:] - INFO  [main:Environment@109] - Client environment:host.name=172.24.230.16
2016-03-23 17:01:07,078 [myid:] - INFO  [main:Environment@109] - Client environment:java.version=1.8.0_65
2016-03-23 17:01:07,081 [myid:] - INFO  [main:Environment@109] - Client environment:java.vendor=Oracle Corporation
2016-03-23 17:01:07,082 [myid:] - INFO  [main:Environment@109] - Client environment:java.home=/Library/Java/JavaVirtualMachines/jdk1.8.0_65.jdk/Contents/Home/jre
2016-03-23 17:01:07,082 [myid:] - INFO  [main:Environment@109] - Client environment:java.class.path=/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../build/classes:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../build/lib/*.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/slf4j-log4j12-1.7.5.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/slf4j-api-1.7.5.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/servlet-api-2.5-20081211.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/netty-3.7.0.Final.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/log4j-1.2.16.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jline-2.11.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jetty-util-6.1.26.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jetty-6.1.26.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/javacc.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jackson-mapper-asl-1.9.11.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jackson-core-asl-1.9.11.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/commons-cli-1.2.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../zookeeper-3.5.1-alpha.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../src/java/lib/*.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../conf:
2016-03-23 17:01:07,082 [myid:] - INFO  [main:Environment@109] - Client environment:java.library.path=/Users/mosuka/Library/Java/Extensions:/Library/Java/Extensions:/Network/Library/Java/Extensions:/System/Library/Java/Extensions:/usr/lib/java:.
2016-03-23 17:01:07,082 [myid:] - INFO  [main:Environment@109] - Client environment:java.io.tmpdir=/var/folders/99/p369dv7n5sqdl9rdvyx0vqzr0000gn/T/
2016-03-23 17:01:07,082 [myid:] - INFO  [main:Environment@109] - Client environment:java.compiler=<NA>
2016-03-23 17:01:07,083 [myid:] - INFO  [main:Environment@109] - Client environment:os.name=Mac OS X
2016-03-23 17:01:07,083 [myid:] - INFO  [main:Environment@109] - Client environment:os.arch=x86_64
2016-03-23 17:01:07,083 [myid:] - INFO  [main:Environment@109] - Client environment:os.version=10.11.4
2016-03-23 17:01:07,083 [myid:] - INFO  [main:Environment@109] - Client environment:user.name=mosuka
2016-03-23 17:01:07,083 [myid:] - INFO  [main:Environment@109] - Client environment:user.home=/Users/mosuka
2016-03-23 17:01:07,083 [myid:] - INFO  [main:Environment@109] - Client environment:user.dir=/Users/mosuka/git/docker-solr
2016-03-23 17:01:07,084 [myid:] - INFO  [main:Environment@109] - Client environment:os.memory.free=117MB
2016-03-23 17:01:07,086 [myid:] - INFO  [main:Environment@109] - Client environment:os.memory.max=228MB
2016-03-23 17:01:07,086 [myid:] - INFO  [main:Environment@109] - Client environment:os.memory.total=123MB
2016-03-23 17:01:07,090 [myid:] - INFO  [main:ZooKeeper@716] - Initiating client connection, connectString=192.168.99.100:2183 sessionTimeout=30000 watcher=org.apache.zookeeper.ZooKeeperMain$MyWatcher@593634ad
2016-03-23 17:01:07,141 [myid:] - INFO  [main-SendThread(192.168.99.100:2183):ClientCnxn$SendThread@1138] - Opening socket connection to server 192.168.99.100/192.168.99.100:2183. Will not attempt to authenticate using SASL (unknown error)
2016-03-23 17:01:07,275 [myid:] - INFO  [main-SendThread(192.168.99.100:2183):ClientCnxn$SendThread@980] - Socket connection established, initiating session, client: /192.168.99.1:54012, server: 192.168.99.100/192.168.99.100:2183
2016-03-23 17:01:07,293 [myid:] - INFO  [main-SendThread(192.168.99.100:2183):ClientCnxn$SendThread@1400] - Session establishment complete on server 192.168.99.100/192.168.99.100:2183, sessionid = 0x20001a31c610002, negotiated timeout = 30000

WATCHER::

WatchedEvent state:SyncConnected type:None path:null
server.1=172.17.0.2:2888:3888:participant;0.0.0.0:2181
server.2=172.17.0.3:2888:3888:participant;0.0.0.0:2181
server.3=172.17.0.4:2888:3888:participant;0.0.0.0:2181
version=200000003

$ ${HOME}/zookeeper/zookeeper-3.5.1-alpha/bin/zkCli.sh -server ${ZOOKEEPER_HOST_IP}:${ZOOKEEPER_3_HOST_PORT} get /zookeeper/config
Connecting to 192.168.99.100:2184
2016-03-23 17:01:23,715 [myid:] - INFO  [main:Environment@109] - Client environment:zookeeper.version=3.5.1-alpha-1693007, built on 07/28/2015 07:19 GMT
2016-03-23 17:01:23,719 [myid:] - INFO  [main:Environment@109] - Client environment:host.name=172.24.230.16
2016-03-23 17:01:23,719 [myid:] - INFO  [main:Environment@109] - Client environment:java.version=1.8.0_65
2016-03-23 17:01:23,721 [myid:] - INFO  [main:Environment@109] - Client environment:java.vendor=Oracle Corporation
2016-03-23 17:01:23,721 [myid:] - INFO  [main:Environment@109] - Client environment:java.home=/Library/Java/JavaVirtualMachines/jdk1.8.0_65.jdk/Contents/Home/jre
2016-03-23 17:01:23,721 [myid:] - INFO  [main:Environment@109] - Client environment:java.class.path=/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../build/classes:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../build/lib/*.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/slf4j-log4j12-1.7.5.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/slf4j-api-1.7.5.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/servlet-api-2.5-20081211.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/netty-3.7.0.Final.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/log4j-1.2.16.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jline-2.11.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jetty-util-6.1.26.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jetty-6.1.26.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/javacc.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jackson-mapper-asl-1.9.11.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jackson-core-asl-1.9.11.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/commons-cli-1.2.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../zookeeper-3.5.1-alpha.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../src/java/lib/*.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../conf:
2016-03-23 17:01:23,722 [myid:] - INFO  [main:Environment@109] - Client environment:java.library.path=/Users/mosuka/Library/Java/Extensions:/Library/Java/Extensions:/Network/Library/Java/Extensions:/System/Library/Java/Extensions:/usr/lib/java:.
2016-03-23 17:01:23,722 [myid:] - INFO  [main:Environment@109] - Client environment:java.io.tmpdir=/var/folders/99/p369dv7n5sqdl9rdvyx0vqzr0000gn/T/
2016-03-23 17:01:23,722 [myid:] - INFO  [main:Environment@109] - Client environment:java.compiler=<NA>
2016-03-23 17:01:23,722 [myid:] - INFO  [main:Environment@109] - Client environment:os.name=Mac OS X
2016-03-23 17:01:23,722 [myid:] - INFO  [main:Environment@109] - Client environment:os.arch=x86_64
2016-03-23 17:01:23,722 [myid:] - INFO  [main:Environment@109] - Client environment:os.version=10.11.4
2016-03-23 17:01:23,722 [myid:] - INFO  [main:Environment@109] - Client environment:user.name=mosuka
2016-03-23 17:01:23,723 [myid:] - INFO  [main:Environment@109] - Client environment:user.home=/Users/mosuka
2016-03-23 17:01:23,723 [myid:] - INFO  [main:Environment@109] - Client environment:user.dir=/Users/mosuka/git/docker-solr
2016-03-23 17:01:23,723 [myid:] - INFO  [main:Environment@109] - Client environment:os.memory.free=117MB
2016-03-23 17:01:23,725 [myid:] - INFO  [main:Environment@109] - Client environment:os.memory.max=228MB
2016-03-23 17:01:23,725 [myid:] - INFO  [main:Environment@109] - Client environment:os.memory.total=123MB
2016-03-23 17:01:23,730 [myid:] - INFO  [main:ZooKeeper@716] - Initiating client connection, connectString=192.168.99.100:2184 sessionTimeout=30000 watcher=org.apache.zookeeper.ZooKeeperMain$MyWatcher@593634ad
2016-03-23 17:01:23,767 [myid:] - INFO  [main-SendThread(192.168.99.100:2184):ClientCnxn$SendThread@1138] - Opening socket connection to server 192.168.99.100/192.168.99.100:2184. Will not attempt to authenticate using SASL (unknown error)
2016-03-23 17:01:23,913 [myid:] - INFO  [main-SendThread(192.168.99.100:2184):ClientCnxn$SendThread@980] - Socket connection established, initiating session, client: /192.168.99.1:54015, server: 192.168.99.100/192.168.99.100:2184
2016-03-23 17:01:23,937 [myid:] - INFO  [main-SendThread(192.168.99.100:2184):ClientCnxn$SendThread@1400] - Session establishment complete on server 192.168.99.100/192.168.99.100:2184, sessionid = 0x30001a35e820000, negotiated timeout = 30000

WATCHER::

WatchedEvent state:SyncConnected type:None path:null
server.1=172.17.0.2:2888:3888:participant;0.0.0.0:2181
server.2=172.17.0.3:2888:3888:participant;0.0.0.0:2181
server.3=172.17.0.4:2888:3888:participant;0.0.0.0:2181
version=200000003
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
