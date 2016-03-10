# docker-zookeeper

## How to use this Docker image

Example:

### Start Standalone ZooKeeper

```sh
# Start ZooKeeper
$ docker run -d -p 12181:2181 --name zookeeper1 mosuka/docker-zookeeper:release-3.4
d98212b5603d3450e4e269549e58857d3e42c543e5fb8748aa7353bb80306c51

# Check container id
$ docker ps
CONTAINER ID        IMAGE                                 COMMAND                  CREATED             STATUS              PORTS                                         NAMES
d98212b5603d        mosuka/docker-zookeeper:release-3.4   "/usr/local/bin/docke"   18 seconds ago      Up 17 seconds       2888/tcp, 3888/tcp, 0.0.0.0:12181->2181/tcp   zookeeper1

# Get container ip
$ docker inspect d98212b5603d | jq '.[].NetworkSettings.IPAddress' | sed -e 's/[^0-9]*\([0-9.]*\)[^0-9]*.*/\1/g'
172.17.0.2

# Get host ip
$ docker-machine ip default
192.168.99.100

# Connect via zkCli.sh
$ /Users/mosuka/zookeeper/zookeeper-3.4.8/bin/zkCli.sh -server 192.168.99.100:12181
Connecting to 192.168.99.100:12181
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
2016-03-10 14:26:29,469 [myid:] - INFO  [main:ZooKeeper@438] - Initiating client connection, connectString=192.168.99.100:12181 sessionTimeout=30000 watcher=org.apache.zookeeper.ZooKeeperMain$MyWatcher@446cdf90
Welcome to ZooKeeper!
2016-03-10 14:26:29,504 [myid:] - INFO  [main-SendThread(192.168.99.100:12181):ClientCnxn$SendThread@1032] - Opening socket connection to server 192.168.99.100/192.168.99.100:12181. Will not attempt to authenticate using SASL (unknown error)
JLine support is enabled
2016-03-10 14:26:29,640 [myid:] - INFO  [main-SendThread(192.168.99.100:12181):ClientCnxn$SendThread@876] - Socket connection established to 192.168.99.100/192.168.99.100:12181, initiating session
2016-03-10 14:26:29,698 [myid:] - INFO  [main-SendThread(192.168.99.100:12181):ClientCnxn$SendThread@1299] - Session establishment complete on server 192.168.99.100/192.168.99.100:12181, sessionid = 0x1535ef9701c0001, negotiated timeout = 30000

WATCHER::

WatchedEvent state:SyncConnected type:None path:null
[zk: 192.168.99.100:12181(CONNECTED) 0]
```
