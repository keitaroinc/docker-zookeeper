FROM java:openjdk-8-jre
MAINTAINER Minoru Osuka "minoru.osuka@gmail.com"

RUN apt-get update ¥
 && apt-get -y install git ant ¥
 && apt-get clean

# Build ZooKeeper
RUN mkdir /tmp/zookeeper
WORKDIR /tmp/zookeeper
RUN git clone https://github.com/apache/zookeeper.git .
RUN git checkout release-3.5.1-rc4
RUN ant jar
RUN cp /tmp/zookeeper/conf/zoo_sample.cfg /tmp/zookeeper/conf/zoo.cfg

# Appy Dynamic Reconfiguration
# see https://zookeeper.apache.org/doc/trunk/zookeeperReconfig.html
RUN echo "standaloneEnabled=false" >> /tmp/zookeeper/conf/zoo.cfg
RUN echo "dynamicConfigFile=/tmp/zookeeper/conf/zoo.cfg.dynamic" >> /tmp/zookeeper/conf/zoo.cfg
