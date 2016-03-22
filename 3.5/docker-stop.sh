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

# IP detection.
DETECTED_IP_LIST=($(
  ip addr show | grep -e "inet[^6]" | \
    sed -e "s/.*inet[^6][^0-9]*\([0-9.]*\)[^0-9]*.*/\1/" | \
    grep -v "^127\."
))
DETECTED_IP=${DETECTED_IP_LIST[0]}

# Set environment variables.
ZOOKEEPER_PREFIX=${ZOOKEEPER_PREFIX:-/opt/zookeeper}
ZOOCFGDIR=${ZOOCFGDIR:-${ZOOKEEPER_PREFIX}/conf}
ZOOCFG=${ZOOCFG:-${ZOOCFGDIR}/zoo.cfg}

ZOOKEEPER_HOST=${ZOOKEEPER_HOST:-${DETECTED_IP}}
ZOOKEEPER_CLIENT_PORT=${ZOOKEEPER_CLIENT_PORT:-2181}

# Show environment variables.
echo "ZOOKEEPER_PREFIX=${ZOOKEEPER_PREFIX}"
echo "ZOOCFGDIR=${ZOOCFGDIR}"
echo "ZOOCFG=${ZOOCFG}"

echo "ZOOKEEPER_HOST=${ZOOKEEPER_HOST}"
echo "ZOOKEEPER_CLIENT_PORT=${ZOOKEEPER_CLIENT_PORT}"

# Stop function.
function stop() {
  # Generate ZooKeeper server list from the ensemble.
  declare -a ZOOKEEPER_SERVER_LIST=()
  if [ -n "${ZOOKEEPER_HOST}" ]; then
    RESPONSE=$(echo "ruok" | nc ${ZOOKEEPER_HOST} ${ZOOKEEPER_CLIENT_PORT})
    if [ "${RESPONSE}" = "imok" ]; then
      ZOOKEEPER_SERVER_LIST=($(
        ${ZOOKEEPER_PREFIX}/bin/zkCli.sh -server ${ZOOKEEPER_HOST}:${ZOOKEEPER_CLIENT_PORT} get /zookeeper/config | grep -e "^server"
      ))
    else
      echo "${ZOOKEEPER_HOST}:${ZOOKEEPER_CLIENT_PORT} does not working."
    fi
  fi

  # Generate ZooKeeper ID list.
  declare -a ZOOKEEPER_ID_LIST=()
  ZOOKEEPER_ID_LIST=($(
    for LINE in ${ZOOKEEPER_SERVER_LIST[@]}
    do
      echo ${LINE} | cut -d"=" -f1 | cut -d"." -f2
    done | sort -u -n
  ))

  # Detect ZooKeeper ID
  ZOOKEEPER_ID=""
  for LINE in ${ZOOKEEPER_SERVER_LIST[@]}
  do
    ZOOKEEPER_ID=$(
      echo ${LINE} | grep -E "^server\.[0-9]+=${ZOOKEEPER_HOST}.*:${ZOOKEEPER_CLIENT_PORT}$" | cut -d"=" -f1 | cut -d"." -f2
    )
    if [ -n "${ZOOKEEPER_ID}" ]; then
      break
    fi
  done

  # Make sure that node is the last node of the ensemble.
  if [[ " ${ZOOKEEPER_ID_LIST[@]} " != " ${ZOOKEEPER_ID} " ]]; then
    echo "NOT LAST NODE"
    # Remove ZooKeeper from the ensemble.
    ${ZOOKEEPER_PREFIX}/bin/zkCli.sh -server ${ZOOKEEPER_HOST}:${ZOOKEEPER_CLIENT_PORT} reconfig -remove ${ZOOKEEPER_ID}
    sleep 1
  fi

  # Stop ZooKeeper.
  ${ZOOKEEPER_PREFIX}/bin/zkServer.sh stop ${ZOOCFG}
}

# Stop
stop
