# docker-zookeeper

## Standalone ZooKeeper example

### 1. Start standalone ZooKeeper

```sh
$ docker run -d -p 2182:2181 --name zookeeper \
    mosuka/docker-zookeeper:release-3.5
c387ac9764215a64afca120ff61acf78851cdf313584a310422876dac3a38a0a

$ ZOOKEEPER_CONTAINER_IP=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' zookeeper)
$ echo ${ZOOKEEPER_CONTAINER_IP}
172.17.0.2
```

### 2. Check container ID

```sh
$ docker ps
CONTAINER ID        IMAGE                                 COMMAND                  CREATED             STATUS              PORTS                                        NAMES
c387ac976421        mosuka/docker-zookeeper:release-3.5   "/usr/local/bin/docke"   15 minutes ago      Up 36 seconds       2888/tcp, 3888/tcp, 0.0.0.0:2182->2181/tcp   zookeeper
```

### 3. Get host IP

```sh
$ ZOOKEEPER_HOST_IP=$(docker-machine ip default)
$ echo ${ZOOKEEPER_HOST_IP}
192.168.99.101
```

### 4. Connect to ZooKeeper using zkCli.sh on the local machine

```sh
$ ${HOME}/zookeeper/zookeeper-3.5.1-alpha/bin/zkCli.sh -server ${ZOOKEEPER_HOST_IP}:2182 get /zookeeper/config
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



## ZooKeeper ensemble (3 nodes) example

### 1. Start ZooKeeper

```sh
$ docker run -d -p 2182:2181 --name zookeeper1 \
    mosuka/docker-zookeeper:release-3.5
98be9f02ca78c27f2de65a03eba13541f5a4c7b649a3c42dbbd1e159f9edc445

$ ZOOKEEPER_1_CONTAINER_IP=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' zookeeper1)
$ echo ${ZOOKEEPER_1_CONTAINER_IP}
172.17.0.2

$ docker run -d -p 2183:2181 --name zookeeper2 \
    -e ZOOKEEPER_SEED_HOST=${ZOOKEEPER_1_CONTAINER_IP} \
    -e ZOOKEEPER_SEED_PORT=2181 \
    mosuka/docker-zookeeper:release-3.5
3f4e90c90d7635319deac5756bb21f7c4da4270ebfd0102fc201befdca78a673

$ ZOOKEEPER_2_CONTAINER_IP=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' zookeeper2)
$ echo ${ZOOKEEPER_2_CONTAINER_IP}
172.17.0.3

$ docker run -d -p 2184:2181 --name zookeeper3 \
    -e ZOOKEEPER_SEED_HOST=${ZOOKEEPER_2_CONTAINER_IP} \
    -e ZOOKEEPER_SEED_PORT=2181 \
    mosuka/docker-zookeeper:release-3.5
a0c84a6d592345208387acb255c10f557b86d9eb7c560e3e8d77ef993d9acf25

$ ZOOKEEPER_3_CONTAINER_IP=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' zookeeper3)
$ echo ${ZOOKEEPER_3_CONTAINER_IP}
172.17.0.4
```

### 2. Check container ID

```sh
$ docker ps
CONTAINER ID        IMAGE                                 COMMAND                  CREATED             STATUS              PORTS                                        NAMES
a0c84a6d5923        mosuka/docker-zookeeper:release-3.5   "/usr/local/bin/docke"   15 minutes ago      Up 52 seconds       2888/tcp, 3888/tcp, 0.0.0.0:2184->2181/tcp   zookeeper3
3f4e90c90d76        mosuka/docker-zookeeper:release-3.5   "/usr/local/bin/docke"   16 minutes ago      Up 2 minutes        2888/tcp, 3888/tcp, 0.0.0.0:2183->2181/tcp   zookeeper2
98be9f02ca78        mosuka/docker-zookeeper:release-3.5   "/usr/local/bin/docke"   17 minutes ago      Up 2 minutes        2888/tcp, 3888/tcp, 0.0.0.0:2182->2181/tcp   zookeeper1
```

### 3. Get host IP

```sh
$ ZOOKEEPER_HOST_IP=$(docker-machine ip default)
$ echo ${ZOOKEEPER_HOST_IP}
192.168.99.101
```

### 4. Connect to ZooKeeper using zkCli.sh on the local machine

```sh
$ ${HOME}/zookeeper/zookeeper-3.5.1-alpha/bin/zkCli.sh -server ${ZOOKEEPER_HOST_IP}:2182 get /zookeeper/config
Connecting to 192.168.99.101:2182
2016-03-22 11:21:08,910 [myid:] - INFO  [main:Environment@109] - Client environment:zookeeper.version=3.5.1-alpha-1693007, built on 07/28/2015 07:19 GMT
2016-03-22 11:21:08,915 [myid:] - INFO  [main:Environment@109] - Client environment:host.name=172.24.231.14
2016-03-22 11:21:08,916 [myid:] - INFO  [main:Environment@109] - Client environment:java.version=1.8.0_65
2016-03-22 11:21:08,919 [myid:] - INFO  [main:Environment@109] - Client environment:java.vendor=Oracle Corporation
2016-03-22 11:21:08,920 [myid:] - INFO  [main:Environment@109] - Client environment:java.home=/Library/Java/JavaVirtualMachines/jdk1.8.0_65.jdk/Contents/Home/jre
2016-03-22 11:21:08,920 [myid:] - INFO  [main:Environment@109] - Client environment:java.class.path=/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../build/classes:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../build/lib/*.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/slf4j-log4j12-1.7.5.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/slf4j-api-1.7.5.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/servlet-api-2.5-20081211.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/netty-3.7.0.Final.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/log4j-1.2.16.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jline-2.11.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jetty-util-6.1.26.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jetty-6.1.26.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/javacc.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jackson-mapper-asl-1.9.11.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jackson-core-asl-1.9.11.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/commons-cli-1.2.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../zookeeper-3.5.1-alpha.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../src/java/lib/*.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../conf:
2016-03-22 11:21:08,920 [myid:] - INFO  [main:Environment@109] - Client environment:java.library.path=/Users/mosuka/Library/Java/Extensions:/Library/Java/Extensions:/Network/Library/Java/Extensions:/System/Library/Java/Extensions:/usr/lib/java:.
2016-03-22 11:21:08,920 [myid:] - INFO  [main:Environment@109] - Client environment:java.io.tmpdir=/var/folders/99/p369dv7n5sqdl9rdvyx0vqzr0000gn/T/
2016-03-22 11:21:08,921 [myid:] - INFO  [main:Environment@109] - Client environment:java.compiler=<NA>
2016-03-22 11:21:08,921 [myid:] - INFO  [main:Environment@109] - Client environment:os.name=Mac OS X
2016-03-22 11:21:08,921 [myid:] - INFO  [main:Environment@109] - Client environment:os.arch=x86_64
2016-03-22 11:21:08,921 [myid:] - INFO  [main:Environment@109] - Client environment:os.version=10.11.3
2016-03-22 11:21:08,921 [myid:] - INFO  [main:Environment@109] - Client environment:user.name=mosuka
2016-03-22 11:21:08,922 [myid:] - INFO  [main:Environment@109] - Client environment:user.home=/Users/mosuka
2016-03-22 11:21:08,922 [myid:] - INFO  [main:Environment@109] - Client environment:user.dir=/Users/mosuka/git/docker-zookeeper
2016-03-22 11:21:08,922 [myid:] - INFO  [main:Environment@109] - Client environment:os.memory.free=117MB
2016-03-22 11:21:08,924 [myid:] - INFO  [main:Environment@109] - Client environment:os.memory.max=228MB
2016-03-22 11:21:08,924 [myid:] - INFO  [main:Environment@109] - Client environment:os.memory.total=123MB
2016-03-22 11:21:08,930 [myid:] - INFO  [main:ZooKeeper@716] - Initiating client connection, connectString=192.168.99.101:2182 sessionTimeout=30000 watcher=org.apache.zookeeper.ZooKeeperMain$MyWatcher@593634ad
2016-03-22 11:21:08,991 [myid:] - INFO  [main-SendThread(192.168.99.101:2182):ClientCnxn$SendThread@1138] - Opening socket connection to server 192.168.99.101/192.168.99.101:2182. Will not attempt to authenticate using SASL (unknown error)
2016-03-22 11:21:09,150 [myid:] - INFO  [main-SendThread(192.168.99.101:2182):ClientCnxn$SendThread@980] - Socket connection established, initiating session, client: /192.168.99.1:55799, server: 192.168.99.101/192.168.99.101:2182
2016-03-22 11:21:09,171 [myid:] - INFO  [main-SendThread(192.168.99.101:2182):ClientCnxn$SendThread@1400] - Session establishment complete on server 192.168.99.101/192.168.99.101:2182, sessionid = 0x100007688b50000, negotiated timeout = 30000

WATCHER::

WatchedEvent state:SyncConnected type:None path:null
server.1=172.17.0.2:2888:3888:participant;0.0.0.0:2181
server.2=172.17.0.3:2888:3888:participant;0.0.0.0:2181
server.3=172.17.0.4:2888:3888:participant;0.0.0.0:2181
version=200000003

$ ${HOME}/zookeeper/zookeeper-3.5.1-alpha/bin/zkCli.sh -server ${ZOOKEEPER_HOST_IP}:2183 get /zookeeper/config
Connecting to 192.168.99.101:2183
2016-03-22 11:21:56,104 [myid:] - INFO  [main:Environment@109] - Client environment:zookeeper.version=3.5.1-alpha-1693007, built on 07/28/2015 07:19 GMT
2016-03-22 11:21:56,110 [myid:] - INFO  [main:Environment@109] - Client environment:host.name=172.24.231.14
2016-03-22 11:21:56,110 [myid:] - INFO  [main:Environment@109] - Client environment:java.version=1.8.0_65
2016-03-22 11:21:56,114 [myid:] - INFO  [main:Environment@109] - Client environment:java.vendor=Oracle Corporation
2016-03-22 11:21:56,114 [myid:] - INFO  [main:Environment@109] - Client environment:java.home=/Library/Java/JavaVirtualMachines/jdk1.8.0_65.jdk/Contents/Home/jre
2016-03-22 11:21:56,114 [myid:] - INFO  [main:Environment@109] - Client environment:java.class.path=/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../build/classes:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../build/lib/*.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/slf4j-log4j12-1.7.5.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/slf4j-api-1.7.5.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/servlet-api-2.5-20081211.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/netty-3.7.0.Final.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/log4j-1.2.16.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jline-2.11.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jetty-util-6.1.26.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jetty-6.1.26.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/javacc.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jackson-mapper-asl-1.9.11.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jackson-core-asl-1.9.11.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/commons-cli-1.2.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../zookeeper-3.5.1-alpha.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../src/java/lib/*.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../conf:
2016-03-22 11:21:56,160 [myid:] - INFO  [main:Environment@109] - Client environment:java.library.path=/Users/mosuka/Library/Java/Extensions:/Library/Java/Extensions:/Network/Library/Java/Extensions:/System/Library/Java/Extensions:/usr/lib/java:.
2016-03-22 11:21:56,160 [myid:] - INFO  [main:Environment@109] - Client environment:java.io.tmpdir=/var/folders/99/p369dv7n5sqdl9rdvyx0vqzr0000gn/T/
2016-03-22 11:21:56,161 [myid:] - INFO  [main:Environment@109] - Client environment:java.compiler=<NA>
2016-03-22 11:21:56,161 [myid:] - INFO  [main:Environment@109] - Client environment:os.name=Mac OS X
2016-03-22 11:21:56,161 [myid:] - INFO  [main:Environment@109] - Client environment:os.arch=x86_64
2016-03-22 11:21:56,161 [myid:] - INFO  [main:Environment@109] - Client environment:os.version=10.11.3
2016-03-22 11:21:56,161 [myid:] - INFO  [main:Environment@109] - Client environment:user.name=mosuka
2016-03-22 11:21:56,161 [myid:] - INFO  [main:Environment@109] - Client environment:user.home=/Users/mosuka
2016-03-22 11:21:56,161 [myid:] - INFO  [main:Environment@109] - Client environment:user.dir=/Users/mosuka/git/docker-zookeeper
2016-03-22 11:21:56,161 [myid:] - INFO  [main:Environment@109] - Client environment:os.memory.free=117MB
2016-03-22 11:21:56,164 [myid:] - INFO  [main:Environment@109] - Client environment:os.memory.max=228MB
2016-03-22 11:21:56,164 [myid:] - INFO  [main:Environment@109] - Client environment:os.memory.total=123MB
2016-03-22 11:21:56,174 [myid:] - INFO  [main:ZooKeeper@716] - Initiating client connection, connectString=192.168.99.101:2183 sessionTimeout=30000 watcher=org.apache.zookeeper.ZooKeeperMain$MyWatcher@593634ad
2016-03-22 11:21:56,233 [myid:] - INFO  [main-SendThread(192.168.99.101:2183):ClientCnxn$SendThread@1138] - Opening socket connection to server 192.168.99.101/192.168.99.101:2183. Will not attempt to authenticate using SASL (unknown error)
2016-03-22 11:21:56,426 [myid:] - INFO  [main-SendThread(192.168.99.101:2183):ClientCnxn$SendThread@980] - Socket connection established, initiating session, client: /192.168.99.1:55804, server: 192.168.99.101/192.168.99.101:2183
2016-03-22 11:21:56,440 [myid:] - INFO  [main-SendThread(192.168.99.101:2183):ClientCnxn$SendThread@1400] - Session establishment complete on server 192.168.99.101/192.168.99.101:2183, sessionid = 0x200007688a00002, negotiated timeout = 30000

WATCHER::

WatchedEvent state:SyncConnected type:None path:null
server.1=172.17.0.2:2888:3888:participant;0.0.0.0:2181
server.2=172.17.0.3:2888:3888:participant;0.0.0.0:2181
server.3=172.17.0.4:2888:3888:participant;0.0.0.0:2181
version=200000003

$ ${HOME}/zookeeper/zookeeper-3.5.1-alpha/bin/zkCli.sh -server ${ZOOKEEPER_HOST_IP}:2184 get /zookeeper/config
Connecting to 192.168.99.101:2184
2016-03-22 11:22:16,788 [myid:] - INFO  [main:Environment@109] - Client environment:zookeeper.version=3.5.1-alpha-1693007, built on 07/28/2015 07:19 GMT
2016-03-22 11:22:16,793 [myid:] - INFO  [main:Environment@109] - Client environment:host.name=172.24.231.14
2016-03-22 11:22:16,793 [myid:] - INFO  [main:Environment@109] - Client environment:java.version=1.8.0_65
2016-03-22 11:22:16,796 [myid:] - INFO  [main:Environment@109] - Client environment:java.vendor=Oracle Corporation
2016-03-22 11:22:16,796 [myid:] - INFO  [main:Environment@109] - Client environment:java.home=/Library/Java/JavaVirtualMachines/jdk1.8.0_65.jdk/Contents/Home/jre
2016-03-22 11:22:16,796 [myid:] - INFO  [main:Environment@109] - Client environment:java.class.path=/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../build/classes:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../build/lib/*.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/slf4j-log4j12-1.7.5.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/slf4j-api-1.7.5.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/servlet-api-2.5-20081211.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/netty-3.7.0.Final.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/log4j-1.2.16.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jline-2.11.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jetty-util-6.1.26.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jetty-6.1.26.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/javacc.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jackson-mapper-asl-1.9.11.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/jackson-core-asl-1.9.11.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../lib/commons-cli-1.2.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../zookeeper-3.5.1-alpha.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../src/java/lib/*.jar:/Users/mosuka/zookeeper/zookeeper-3.5.1-alpha/bin/../conf:
2016-03-22 11:22:16,797 [myid:] - INFO  [main:Environment@109] - Client environment:java.library.path=/Users/mosuka/Library/Java/Extensions:/Library/Java/Extensions:/Network/Library/Java/Extensions:/System/Library/Java/Extensions:/usr/lib/java:.
2016-03-22 11:22:16,797 [myid:] - INFO  [main:Environment@109] - Client environment:java.io.tmpdir=/var/folders/99/p369dv7n5sqdl9rdvyx0vqzr0000gn/T/
2016-03-22 11:22:16,797 [myid:] - INFO  [main:Environment@109] - Client environment:java.compiler=<NA>
2016-03-22 11:22:16,797 [myid:] - INFO  [main:Environment@109] - Client environment:os.name=Mac OS X
2016-03-22 11:22:16,797 [myid:] - INFO  [main:Environment@109] - Client environment:os.arch=x86_64
2016-03-22 11:22:16,797 [myid:] - INFO  [main:Environment@109] - Client environment:os.version=10.11.3
2016-03-22 11:22:16,798 [myid:] - INFO  [main:Environment@109] - Client environment:user.name=mosuka
2016-03-22 11:22:16,798 [myid:] - INFO  [main:Environment@109] - Client environment:user.home=/Users/mosuka
2016-03-22 11:22:16,798 [myid:] - INFO  [main:Environment@109] - Client environment:user.dir=/Users/mosuka/git/docker-zookeeper
2016-03-22 11:22:16,798 [myid:] - INFO  [main:Environment@109] - Client environment:os.memory.free=117MB
2016-03-22 11:22:16,801 [myid:] - INFO  [main:Environment@109] - Client environment:os.memory.max=228MB
2016-03-22 11:22:16,801 [myid:] - INFO  [main:Environment@109] - Client environment:os.memory.total=123MB
2016-03-22 11:22:16,806 [myid:] - INFO  [main:ZooKeeper@716] - Initiating client connection, connectString=192.168.99.101:2184 sessionTimeout=30000 watcher=org.apache.zookeeper.ZooKeeperMain$MyWatcher@593634ad
2016-03-22 11:22:16,842 [myid:] - INFO  [main-SendThread(192.168.99.101:2184):ClientCnxn$SendThread@1138] - Opening socket connection to server 192.168.99.101/192.168.99.101:2184. Will not attempt to authenticate using SASL (unknown error)
2016-03-22 11:22:16,998 [myid:] - INFO  [main-SendThread(192.168.99.101:2184):ClientCnxn$SendThread@980] - Socket connection established, initiating session, client: /192.168.99.1:55805, server: 192.168.99.101/192.168.99.101:2184
2016-03-22 11:22:17,024 [myid:] - INFO  [main-SendThread(192.168.99.101:2184):ClientCnxn$SendThread@1400] - Session establishment complete on server 192.168.99.101/192.168.99.101:2184, sessionid = 0x300007709ed0000, negotiated timeout = 30000

WATCHER::

WatchedEvent state:SyncConnected type:None path:null
server.1=172.17.0.2:2888:3888:participant;0.0.0.0:2181
server.2=172.17.0.3:2888:3888:participant;0.0.0.0:2181
server.3=172.17.0.4:2888:3888:participant;0.0.0.0:2181
version=200000003
```