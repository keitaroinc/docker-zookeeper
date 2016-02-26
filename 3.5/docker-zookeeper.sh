#!/usr/bin/env bash

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

# USE the trap if you need to also do manual cleanup after the service is stopped,
#     or need to start multiple services in the one container
trap "echo TRAPed signal" HUP INT QUIT KILL TERM

# start service in background here
echo "Starting ZooKeeper"
./bin/zkEnsemble.sh start --seed=172.24.230.16:2181 \
                          --ip=127.0.0.1 \
                          --clientport=2181 \
                          --peerport=2888 \
                          --electionport=3888 \
                          --role=participant \
                          --clientport=2181 \
                          --confdir=/opt/zookeeper/conf \
                          --datadir=/opt/zookeeper/data

echo "[hit enter key to exit] or run 'docker stop <container>'"
read

# stop service and clean up here
echo "Stopping ZooKeeper"
./bin/zkEnsemble.sh stop --ip=172.24.230.16 --clientport=2181

echo "exited $0"
