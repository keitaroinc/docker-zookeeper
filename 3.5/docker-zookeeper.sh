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

if ! OPTS=$(getopt -n $0 -o "" -l "seed:" -l "ip:" -l "clientport:" -l "peerport:" -l "electionport:" -l "role:" -l "clientip:" -l "confdir:" -l "datadir:" -l "foreground" -- "$@" 2>/dev/null); then
  exit 1
fi

# check options
eval set -- "${OPTS}"
while true; do
  case "$1" in
    --seed)
      SEED=$2; shift 2
      ;;
    --ip)
      IP=$2; shift 2
      ;;
    --clientport)
      CLIENT_PORT=$2; shift 2
      ;;
    --peerport)
      PEER_PORT=$2; shift 2
      ;;
    --electionport)
      ELECTION_PORT=$2; shift 2
      ;;
    --role)
      ROLE=$2; shift 2
      ;;
    --clientip)
      CLIENT_IP=$2; shift 2
      ;;
    --confdir)
      ZOOCFGDIR=$2; shift 2
      ;;
    --datadir)
      ZOO_DATADIR=$2; shift 2
      ;;
    --foreground)
      FOREGROUND=1; shift 1
      ;;
    --)
      shift
      break
      ;;
    *)
      echo "unknown option: $1"
      exit 1
      ;;
  esac
done

# create start options
START_OPTS=""
if [ -n "${SEED}" ]; then
  START_OPTS="${START_OPTS} --seed=${SEED}"
fi
if [ -n "${IP}" ]; then
  START_OPTS="${START_OPTS} --ip=${IP}"
fi
if [ -n "${CLIENT_PORT}" ]; then
  START_OPTS="${START_OPTS} --clientport=${CLIENT_PORT}"
fi
if [ -n "${PEER_PORT}" ]; then
  START_OPTS="${START_OPTS} --peerport=${PEER_PORT}"
fi
if [ -n "${ELECTION_PORT}" ]; then
  START_OPTS="${START_OPTS} --electionport=${ELECTION_PORT}"
fi
if [ -n "${ROLE}" ]; then
  START_OPTS="${START_OPTS} --role=${ROLE}"
fi
if [ -n "${CLIENT_IP}" ]; then
  START_OPTS="${START_OPTS} --clientip=${CLIENT_IP}"
fi
if [ -n "${ZOOCFGDIR}" ]; then
  START_OPTS="${START_OPTS} --confdir=${ZOOCFGDIR}"
fi
if [ -n "${ZOO_DATADIR}" ]; then
  START_OPTS="${START_OPTS} --datadir=${ZOO_DATADIR}"
fi
if [ ${FOREGROUND} -eq 1 ]; then
  START_OPTS="${START_OPTS} --foreground"
fi

# create stop options
STOP_OPTS=""
if [ -n "${IP}" ]; then
  STOP_OPTS="${STOP_OPTS} --ip=${IP}"
fi
if [ -n "${CLIENT_PORT}" ]; then
  STOP_OPTS="${STOP_OPTS} --clientport=${CLIENT_PORT}"
fi

# start service in background here
echo "Starting ZooKeeper"
$ZOOKEEPER_HOME/bin/zkEnsemble.sh start ${START_OPTS}

echo "[hit enter key to exit] or run 'docker stop <container>'"
read

# stop service and clean up here
echo "Stopping ZooKeeper"
$ZOOKEEPER_HOME/bin/zkEnsemble.sh stop ${STOP_OPTS}

echo "exited $0"
