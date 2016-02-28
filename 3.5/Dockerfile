# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#
# If this scripted is run out of /usr/bin or some other system bin directory
# it should be linked to and not copied. Things like java jar files are found
# relative to the canonical path of this script.
#

FROM java:openjdk-7-jre
MAINTAINER Minoru Osuka "minoru.osuka@gmail.com"

RUN apt-get update \
 && apt-get install -y wget tar \
 && apt-get clean

# Add group
ENV ZOOKEEPER_GROUP zookeeper
RUN groupadd -r $ZOOKEEPER_GROUP

# Add user
ENV ZOOKEEPER_USER zookeeper
ENV ZOOKEEPER_UID 2181
RUN useradd -r -u $ZOOKEEPER_UID -g $ZOOKEEPER_GROUP $ZOOKEEPER_USER

# Install ZooKeeper
ENV ZOOKEEPER_VERSION 3.5.0-alpha
RUN mkdir -p /opt
WORKDIR /opt
RUN wget https://archive.apache.org/dist/zookeeper/zookeeper-$ZOOKEEPER_VERSION/zookeeper-$ZOOKEEPER_VERSION.tar.gz | tar -xzf - -C /opt
RUN mv /opt/zookeeper-$ZOOKEEPER_VERSION /opt/zookeeper
RUN curl https://gist.githubusercontent.com/mosuka/f124b0c2d0dbaa3278d4/raw/1f7623c62e043fce55f85167ee309d0c1343d6e9/zkEnsemble.sh > /opt/zookeeper/bin/zkEnsemble.sh
RUN chmod +x /opt/zookeeper/bin/zkEnsemble.sh

# Add start script
COPY 3.5/docker-zookeeper.sh /usr/local/bin/

EXPOSE 2181 2888 3888
USER $ZOOKEEPER_USER

CMD ["/usr/local/bin/docker-zookeeper.sh"]
