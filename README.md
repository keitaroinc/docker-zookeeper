# docker-zookeeper

## How to use this Docker image

Example:  

Start a 1st node of ensemble
```sh
$ docker run -d -p 12181:2181 mosuka/docker-zookeeper docker-zookeeper.sh
```

Start a 2nd node of ensemble
```
$ docker run -d -p 22181:2181 mosuka/docker-zookeeper docker-zookeeper.sh --seed=<1st node IP:PORT>
```

Start a 3rd node of ensemble
```
$ docker run -d -p 32181:2181 mosuka/docker-zookeeper docker-zookeeper.sh --seed=<1st node IP:PORT>
```
