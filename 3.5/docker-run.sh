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
ZOO_DATADIR=${ZOO_DATADIR:-${ZOOKEEPER_PREFIX}/data}
ZOOCFGDIR=${ZOOCFGDIR:-${ZOOKEEPER_PREFIX}/conf}
ZOOCFG=${ZOOCFG:-${ZOOCFGDIR}/zoo.cfg}

ZOOKEEPER_SEED_HOST=${ZOOKEEPER_SEED_HOST:-""}
ZOOKEEPER_SEED_PORT=${ZOOKEEPER_SEED_PORT:-2181}

ZOOKEEPER_ID=""
ZOOKEEPER_HOST=${ZOOKEEPER_HOST:-${DETECTED_IP}}
ZOOKEEPER_CLIENT_PORT=${ZOOKEEPER_CLIENT_PORT:-2181}
ZOOKEEPER_PEER_PORT=${ZOOKEEPER_PEER_PORT:-2888}
ZOOKEEPER_ELECTION_PORT=${ZOOKEEPER_ELECTION_PORT:-3888}
ZOOKEEPER_ROLE=${ZOOKEEPER_ROLE:-participant}
ZOOKEEPER_CLIENT_IP=${ZOOKEEPER_CLIENT_IP:-0.0.0.0}

ZOOKEEPER_TICK_TIME=${ZOOKEEPER_TICK_TIME:-2000}
ZOOKEEPER_INIT_LIMIT=${ZOOKEEPER_INIT_LIMIT:-10}
ZOOKEEPER_SYNC_LIMIT=${ZOOKEEPER_SYNC_LIMIT:-5}
ZOOKEEPER_MAX_CLIENT_CNXNS=${ZOOKEEPER_MAX_CLIENT_CNXNS:-60}
ZOOKEEPER_AUTOPURGE_SNAP_RETAIN_COUNT=${ZOOKEEPER_AUTOPURGE_SNAP_RETAIN_COUNT:-3}
ZOOKEEPER_AUTOPURGE_PURGE_INTERVAL=${ZOOKEEPER_AUTOPURGE_PURGE_INTERVAL:-1}

# Show environment variables.
echo "ZOOKEEPER_PREFIX=${ZOOKEEPER_PREFIX}"
echo "ZOO_DATADIR=${ZOO_DATADIR}"
echo "ZOOCFGDIR=${ZOOCFGDIR}"
echo "ZOOCFG=${ZOOCFG}"

echo "ZOOKEEPER_SEED_HOST=${ZOOKEEPER_SEED_HOST}"
echo "ZOOKEEPER_SEED_PORT=${ZOOKEEPER_SEED_PORT}"

echo "ZOOKEEPER_ID=${ZOOKEEPER_ID}"
echo "ZOOKEEPER_HOST=${ZOOKEEPER_HOST}"
echo "ZOOKEEPER_CLIENT_PORT=${ZOOKEEPER_CLIENT_PORT}"
echo "ZOOKEEPER_PEER_PORT=${ZOOKEEPER_PEER_PORT}"
echo "ZOOKEEPER_ELECTION_PORT=${ZOOKEEPER_ELECTION_PORT}"
echo "ZOOKEEPER_ROLE=${ZOOKEEPER_ROLE}"
echo "ZOOKEEPER_CLIENT_IP=${ZOOKEEPER_CLIENT_IP}"

echo "ZOOKEEPER_TICK_TIME=${ZOOKEEPER_TICK_TIME}"
echo "ZOOKEEPER_INIT_LIMIT=${ZOOKEEPER_INIT_LIMIT}"
echo "ZOOKEEPER_SYNC_LIMIT=${ZOOKEEPER_SYNC_LIMIT}"
echo "ZOOKEEPER_MAX_CLIENT_CNXNS=${ZOOKEEPER_MAX_CLIENT_CNXNS}"
echo "ZOOKEEPER_AUTOPURGE_SNAP_RETAIN_COUNT=${ZOOKEEPER_AUTOPURGE_SNAP_RETAIN_COUNT}"
echo "ZOOKEEPER_AUTOPURGE_PURGE_INTERVAL=${ZOOKEEPER_AUTOPURGE_PURGE_INTERVAL}"

# Make directories.
mkdir -p ${ZOOCFGDIR}
mkdir -p ${ZOO_DATADIR}

# Start function
function start() {
  # Generate ZooKeeper server list from the ensemble.
  declare -a ZOOKEEPER_SERVER_LIST=()
  if [ -n "${ZOOKEEPER_SEED_HOST}" ]; then
    RETRY_CNT=10
    for i in $(seq 1 ${RETRY_CNT})
    do
      RESPONSE=$(echo "ruok" | nc ${ZOOKEEPER_SEED_HOST} ${ZOOKEEPER_SEED_PORT})
      if [ "${RESPONSE}" = "imok" ]; then
        ZOOKEEPER_SERVER_LIST=($(
          ${ZOOKEEPER_PREFIX}/bin/zkCli.sh -server ${ZOOKEEPER_SEED_HOST}:${ZOOKEEPER_SEED_PORT} get /zookeeper/config | grep -e "^server"
        ))
        break
      fi
      MAX_SLEEP=10
      sleep $(((RANDOM % ${MAX_SLEEP}) + 1))
    done
  fi

  # Generate ZooKeeper ID list.
  declare -a ZOOKEEPER_ID_LIST=()
  ZOOKEEPER_ID_LIST=($(
    for LINE in ${ZOOKEEPER_SERVER_LIST}
    do
      echo ${LINE} | cut -d"=" -f1 | cut -d"." -f2
    done | sort -u -n
  ))

  # Generate available ZooKeeper ID list
  declare -a AVAILABLE_ZOOKEEPER_ID_LIST=()
  AVAILABLE_ZOOKEEPER_ID_LIST=($(
    diff --old-line-format='' \
      --new-line-format='%L' \
      --unchanged-line-format='' \
      <(printf "%s\n" ${ZOOKEEPER_ID_LIST[@]}) \
      <(printf "%s\n" $(seq 1 255))
  ))

  # Detect ZooKeeper ID
  ZOOKEEPER_ID=${AVAILABLE_ZOOKEEPER_ID_LIST[0]}

  # Generate configuration file.
  echo "tickTime=${ZOOKEEPER_TICK_TIME}" > ${ZOOCFG}
  echo "initLimit=${ZOOKEEPER_INIT_LIMIT}" >> ${ZOOCFG}
  echo "syncLimit=${ZOOKEEPER_SYNC_LIMIT}" >> ${ZOOCFG}
  echo "dataDir=${ZOO_DATADIR}" >> ${ZOOCFG}
  echo "maxClientCnxns=${ZOOKEEPER_MAX_CLIENT_CNXNS}" >> ${ZOOCFG}
  echo "autopurge.snapRetainCount=${ZOOKEEPER_AUTOPURGE_SNAP_RETAIN_COUNT}" >> ${ZOOCFG}
  echo "autopurge.purgeInterval=${ZOOKEEPER_AUTOPURGE_PURGE_INTERVAL}" >> ${ZOOCFG}
  echo "standaloneEnabled=false" >> ${ZOOCFG}
  echo "dynamicConfigFile=${ZOOCFG}.dynamic" >> ${ZOOCFG}

  if [ -n "${ZOOKEEPER_SERVER_LIST}" ]; then
    # Generate dynamic configuration file.
    echo -n > ${ZOOCFG}.dynamic
    for LINE in ${ZOOKEEPER_SERVER_LIST}
    do
      echo ${LINE} >> ${ZOOCFG}.dynamic
    done
    echo "server.${ZOOKEEPER_ID}=${ZOOKEEPER_HOST}:${ZOOKEEPER_PEER_PORT}:${ZOOKEEPER_ELECTION_PORT}:observer;${ZOOKEEPER_CLIENT_IP}:${ZOOKEEPER_CLIENT_PORT}" >> ${ZOOCFG}.dynamic

    # Start ZooKeeper as observer.
    ${ZOOKEEPER_PREFIX}/bin/zkServer-initialize.sh --configfile ${ZOOCFG} --myid ${ZOOKEEPER_ID} --force
    ${ZOOKEEPER_PREFIX}/bin/zkServer.sh start {ZOOCFG}
    
    sleep 1
    
    # Add ZooKeeper to the ensemble as participant.
    ${ZOOKEEPER_PREFIX}/bin/zkCli.sh -server ${ZOOKEEPER_SEED_HOST}:${ZOOKEEPER_SEED_PORT} reconfig -add "server.${ZOOKEEPER_ID}=${ZOOKEEPER_HOST}:${ZOOKEEPER_PEER_PORT}:${ZOOKEEPER_ELECTION_PORT}:${ZOOKEEPER_ROLE};${ZOOKEEPER_CLIENT_IP}:${ZOOKEEPER_CLIENT_PORT}"
    
    sleep 1
    
    # Stop ZooKeeper.
    ${ZOOKEEPER_PREFIX}/bin/zkServer.sh stop {ZOOCFG}
    
    sleep 1
    
    # Modify dynamic configuration file.
    sed -e "s/^server.${ZOOKEEPER_ID}=.*/server.${ZOOKEEPER_ID}=${ZOOKEEPER_HOST}:${ZOOKEEPER_PEER_PORT}:${ZOOKEEPER_ELECTION_PORT}:${ZOOKEEPER_ROLE};${ZOOKEEPER_CLIENT_IP}:${ZOOKEEPER_CLIENT_PORT}/" ${ZOOCFG}.dynamic > ${ZOOCFG}.dynamic.tmp
    mv ${ZOOCFG}.dynamic.tmp ${ZOOCFG}.dynamic
  else
    # Generate dynamic configuration file.
    echo "server.${ZOOKEEPER_ID}=${ZOOKEEPER_HOST}:${ZOOKEEPER_PEER_PORT}:${ZOOKEEPER_ELECTION_PORT}:${ZOOKEEPER_ROLE};${ZOOKEEPER_CLIENT_IP}:${ZOOKEEPER_CLIENT_PORT}" > ${ZOOCFG}.dynamic
  fi

  # Show configuration file.
  if [ -e ${ZOOCFG} ]; then
    echo ${ZOOCFG}
    cat ${ZOOCFG}
  fi
  if [ -e ${ZOOCFG}.dynamic ]; then
    echo ${ZOOCFG}.dynamic
    cat ${ZOOCFG}.dynamic
  fi

  # Start ZooKeeper.
  ${ZOOKEEPER_PREFIX}/bin/zkServer-initialize.sh --configfile ${ZOOCFG} --myid ${ZOOKEEPER_ID} --force
  ${ZOOKEEPER_PREFIX}/bin/zkServer.sh start ${ZOOCFG}
}

# Stop function.
function stop() {
  # Generate ZooKeeper server list from the ensemble.
  declare -a ZOOKEEPER_SERVER_LIST=()
  if [ -n "${ZOOKEEPER_SEED_HOST}" ]; then
    RESPONSE=$(echo "ruok" | nc ${ZOOKEEPER_SEED_HOST} ${ZOOKEEPER_SEED_PORT})
    if [ "${RESPONSE}" = "imok" ]; then
      ZOOKEEPER_SERVER_LIST=($(
        ${ZOOKEEPER_PREFIX}/bin/zkCli.sh -server ${ZOOKEEPER_SEED_HOST}:${ZOOKEEPER_SEED_PORT} get /zookeeper/config | \
          grep -e "^server"
      ))
    else
      echo "${ZOOKEEPER_SEED_HOST}:${ZOOKEEPER_SEED_PORT} does not working."
    fi
  fi

  # Generate ZooKeeper ID list.
  declare -a ZOOKEEPER_ID_LIST=()
  ZOOKEEPER_ID_LIST=($(
    for LINE in ${ZOOKEEPER_SERVER_LIST}
    do
      echo ${LINE} | cut -d"=" -f1 | cut -d"." -f2
    done | sort -u -n
  ))

  # Detect ZooKeeper ID
  ZOOKEEPER_ID=$(
    echo "${ZOOKEEPER_SERVER_LIST[@]}" |\
      grep -E "^server\.[0-9]+=${ZOOKEEPER_HOST}.*:${ZOOKEEPER_CLIENT_PORT}$" |\
      cut -d"=" -f1 |\
      cut -d"." -f2
  )

  # Check ZooKeeper ID.
  if [ -n "${ZOOKEEPER_ID}" ]; then
    # Make sure that node is the last node of the ensemble.
    if [[ " ${ZOOKEEPER_SERVER_LIST[@]} " != " ${ZOOKEEPER_ID} " ]]; then
      # Remove ZooKeeper from the ensemble.
      ${ZOOKEEPER_PREFIX}/bin/zkCli.sh -server ${ZOOKEEPER_HOST}:${ZOOKEEPER_CLIENT_PORT} reconfig -remove ${ZOOKEEPER_ID}
      sleep 1
    fi
  fi

  # Stop ZooKeeper.
  ${ZOOKEEPER_PREFIX}/bin/zkServer.sh stop ${ZOOCFG}
}

trap "stop; exit 1" TERM KILL INT QUIT

# Start
start

# Start infinitive loop.
while true
do
 tail -F /dev/null & wait ${!}
done
