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

# IP detection.
DETECTED_IP_LIST=($(
  ip addr show | grep -e "inet[^6]" | \
    sed -e "s/.*inet[^6][^0-9]*\([0-9.]*\)[^0-9]*.*/\1/" | \
    grep -v "^127\."
))
DETECTED_IP=${DETECTED_IP_LIST[0]}

# Set environment variables.
ZOOKEEPER_PREFIX=${ZOOKEEPER_PREFIX:-/opt/zookeeper}
echo "ZOOKEEPER_PREFIX=${ZOOKEEPER_PREFIX}"
ZOOCFGDIR=${ZOOCFGDIR:-${ZOOKEEPER_PREFIX}/conf}
echo "ZOOCFGDIR=${ZOOCFGDIR}"
ZOOCFG=${ZOOCFG:-${ZOOCFGDIR}/zoo.cfg}
echo "ZOOCFG=${ZOOCFG}"

ZOOKEEPER_HOST=${ZOOKEEPER_HOST:-${DETECTED_IP}}
echo "ZOOKEEPER_HOST=${ZOOKEEPER_HOST}"
ZOOKEEPER_CLIENT_PORT=${ZOOKEEPER_CLIENT_PORT:-2181}
echo "ZOOKEEPER_CLIENT_PORT=${ZOOKEEPER_CLIENT_PORT}"

ZOOKEEPER_ACCESS_RETRY_COUNT=${ZOOKEEPER_ACCESS_RETRY_COUNT:-10}
echo "ZOOKEEPER_ACCESS_RETRY_COUNT=${ZOOKEEPER_ACCESS_RETRY_COUNT}"
ZOOKEEPER_ACCESS_INTERVAL=${ZOOKEEPER_ACCESS_INTERVAL:-1}
echo "ZOOKEEPER_ACCESS_INTERVAL=${ZOOKEEPER_ACCESS_INTERVAL}"

# Stop function.
function stop() {
  # Generate ZooKeeper server list from the ensemble.
  declare -a ZOOKEEPER_SERVER_LIST=()
  if [ -n "${ZOOKEEPER_HOST}" ]; then
    for i in `seq ${ZOOKEEPER_ACCESS_RETRY_COUNT}`
    do
      ZOOKEEPER_SERVER_LIST=($(
        echo "conf" | nc ${ZOOKEEPER_HOST} ${ZOOKEEPER_CLIENT_PORT} | grep -E "^server\.[0-9]{1,3}=.*"
      ))
      if [ -n "${ZOOKEEPER_SERVER_LIST}" ]; then
        break
      fi
      sleep ${ZOOKEEPER_ACCESS_INTERVAL}
    done
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
      echo ${LINE} | grep -E "^server\.[0-9]+=${ZOOKEEPER_HOST}:.*:${ZOOKEEPER_CLIENT_PORT}$" | cut -d"=" -f1 | cut -d"." -f2
    )
    if [ -n "${ZOOKEEPER_ID}" ]; then
      break
    fi
  done

  # Make sure that node is the last node of the ensemble.
  if [[ " ${ZOOKEEPER_ID_LIST[@]} " != " ${ZOOKEEPER_ID} " ]]; then
    # Remove ZooKeeper from the ensemble.
    ${ZOOKEEPER_PREFIX}/bin/zkCli.sh -server ${ZOOKEEPER_HOST}:${ZOOKEEPER_CLIENT_PORT} reconfig -remove ${ZOOKEEPER_ID}
    sleep ${ZOOKEEPER_ACCESS_INTERVAL}
  fi

  # Stop ZooKeeper.
  ${ZOOKEEPER_PREFIX}/bin/zkServer.sh stop ${ZOOCFG}
}

# Stop
stop