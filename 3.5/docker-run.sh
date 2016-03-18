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

DETECTED_IP=$(
  ip addr show | grep -e "inet[^6]" | \
    sed -e "s/.*inet[^6][^0-9]*\([0-9.]*\)[^0-9]*.*/\1/" | \
    grep -v "^127\."
)

# Set environment variables.
ZOOKEEPER_PREFIX=${ZOOKEEPER_PREFIX:-/opt/zookeeper}
SEED=${SEED:-/opt/zookeeper}
IP=${IP:-${DETECTED_IP}}
CLIENT_PORT=${CLIENT_PORT:-2181}
PEER_PORT=${PEER_PORT:-2888}
ELECTION_PORT=${ELECTION_PORT:-3888}
ROLE=${ROLE:-participant}
CLIENT_IP=${CLIENT_IP:-0.0.0.0}
ZOOCFGDIR=${ZOOCFGDIR:-${ZOOKEEPER_PREFIX}/conf}
ZOO_DATADIR=${ZOO_DATADIR:-${ZOOKEEPER_PREFIX}/data}
FOREGROUND=${FOREGROUND:-1}

# Show environment variables.
echo "ZOOKEEPER_PREFIX=${ZOOKEEPER_PREFIX}"
echo "SEED=${SEED}"
echo "IP=${IP}"
echo "CLIENT_PORT=${CLIENT_PORT}"
echo "PEER_PORT=${PEER_PORT}"
echo "ELECTION_PORT=${ELECTION_PORT}"
echo "ROLE=${ROLE}"
echo "CLIENT_IP=${CLIENT_IP}"
echo "ZOOCFGDIR=${ZOOCFGDIR}"
echo "ZOO_DATADIR=${ZOO_DATADIR}"
echo "FOREGROUND=${FOREGROUND}"

# Start function
function start() {
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
  if [ "${FOREGROUND}" == 1 ]; then
    START_OPTS="${START_OPTS} --foreground"
  fi

  ${ZOOKEEPER_PREFIX}/bin/zkEnsemble.sh start ${START_OPTS}
}

# Stop function.
function stop() {
  # Create a stop options.
  STOP_OPTS=""
  if [ -n "${IP}" ]; then
    STOP_OPTS="${STOP_OPTS} --ip=${IP}"
  fi
  if [ -n "${CLIENT_PORT}" ]; then
    STOP_OPTS="${STOP_OPTS} --clientport=${CLIENT_PORT}"
  fi

  ${ZOOKEEPER_PREFIX}/bin/zkEnsemble.sh stop ${STOP_OPTS}
}

trap "stop; exit 1" TERM KILL INT QUIT

# Start
start

# Start infinitive loop
while true
do
 tail -F /dev/null & wait ${!}
done
