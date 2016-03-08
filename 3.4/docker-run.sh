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

# Set environment variables.
ZOOKEEPER_ID=${ZOOKEEPER_ID:-1}
ZOOKEEPER_PREFIX=${ZOOKEEPER_PREFIX:-/opt/zookeeper}
ZOOCFGDIR=${ZOOCFGDIR:-${ZOOKEEPER_PREFIX}/conf}
ZOOCFG=${ZOOCFG:-${ZOOCFGDIR}/zoo.cfg}
ZOO_LOG4J_PROP=${ZOO_LOG4J_PROP:-${ZOOCFGDIR}/log4j.properties}
ZOO_DATADIR=${ZOO_DATADIR:-${ZOOKEEPER_PREFIX}/data}
ZOOPIDFILE=${ZOOPIDFILE:-${ZOO_DATADIR}/zookeeper_server.pid}
ZOOKEEPER_MYIDFILE=${ZOOKEEPER_MYIDFILE:-${ZOO_DATADIR}/myid}
ZOO_LOG_DIR=${ZOO_LOG_DIR:-${ZOOKEEPER_PREFIX}/logs}
ZOOKEEPER_CLIENT_PORT=${ZOOKEEPER_CLIENT_PORT:-2181}
ZOOKEEPER_PEER_PORT=${ZOOKEEPER_PEER_PORT:-2888}
ZOOKEEPER_ELECTION_PORT=${ZOOKEEPER_ELECTION_PORT:-3888}
ZOOKEEPER_TICK_TIME=${ZOOKEEPER_TICK_TIME:-2000}
ZOOKEEPER_INIT_LIMIT=${ZOOKEEPER_INIT_LIMIT:-10}
ZOOKEEPER_SYNC_LIMIT=${ZOOKEEPER_SYNC_LIMIT:-5}
ZOOKEEPER_MAX_CLIENT_CNXNS=${ZOOKEEPER_MAX_CLIENT_CNXNS:-60}
ZOOKEEPER_AUTOPURGE_SNAP_RETAIN_COUNT=${ZOOKEEPER_AUTOPURGE_SNAP_RETAIN_COUNT:-3}
ZOOKEEPER_AUTOPURGE_PURGE_INTERVAL=${ZOOKEEPER_AUTOPURGE_PURGE_INTERVAL:-1}
declare -a ZOOKEEPER_SERVER_LIST=()
ZOOKEEPER_SERVER_LIST=(
  $(for LINE in `env | grep -E "^ZOOKEEPER_SERVER_[0-9]+=.+$" | sort -t "_" -k 3 -n`
    do
      echo ${LINE}
    done
  )
)

# Show environment variables.
echo "ZOOKEEPER_ID=${ZOOKEEPER_ID}"
echo "ZOOKEEPER_PREFIX=${ZOOKEEPER_PREFIX}"
echo "ZOOCFGDIR=${ZOOCFGDIR}"
echo "ZOOCFG=${ZOOCFG}"
echo "ZOO_LOG4J_PROP=${ZOO_LOG4J_PROP}"
echo "ZOO_DATADIR=${ZOO_DATADIR}"
echo "ZOOPIDFILE=${ZOOPIDFILE}"
echo "ZOOKEEPER_MYIDFILE=${ZOOKEEPER_MYIDFILE}"
echo "ZOO_LOG_DIR=${ZOO_LOG_DIR}"
echo "ZOOKEEPER_CLIENT_PORT=${ZOOKEEPER_CLIENT_PORT}"
echo "ZOOKEEPER_PEER_PORT=${ZOOKEEPER_PEER_PORT}"
echo "ZOOKEEPER_ELECTION_PORT=${ZOOKEEPER_ELECTION_PORT}"
echo "ZOOKEEPER_TICK_TIME=${ZOOKEEPER_TICK_TIME}"
echo "ZOOKEEPER_INIT_LIMIT=${ZOOKEEPER_INIT_LIMIT}"
echo "ZOOKEEPER_SYNC_LIMIT=${ZOOKEEPER_SYNC_LIMIT}"
echo "ZOOKEEPER_CLIENT_CNXNS=${ZOOKEEPER_MAX_CLIENT_CNXNS}"
echo "ZOOKEEPER_AUTOPURGE_SNAP_RETAIN_COUNT=${ZOOKEEPER_AUTOPURGE_SNAP_RETAIN_COUNT}"
echo "ZOOKEEPER_AUTOPURGE_PURGE_INTERVAL=${ZOOKEEPER_AUTOPURGE_PURGE_INTERVAL}"
for ZOOKEEPER_SERVER in "${ZOOKEEPER_SERVER_LIST[@]}"
do 
  echo "${ZOOKEEPER_SERVER}"
done

# Make directories.
mkdir -p ${ZOOCFGDIR}
mkdir -p ${ZOO_LOG_DIR}
mkdir -p ${ZOO_DATADIR}

# Generate configuration files.
echo "tickTime=${ZOOKEEPER_TICK_TIME}" > ${ZOOCFG}
echo "initLimit=${ZOOKEEPER_INIT_LIMIT}" >> ${ZOOCFG}
echo "syncLimit=${ZOOKEEPER_SYNC_LIMIT}" >> ${ZOOCFG}
echo "dataDir=${ZOO_DATADIR}" >> ${ZOOCFG}
echo "clientPort=${ZOOKEEPER_CLIENT_PORT}" >> ${ZOOCFG}
echo "maxClientCnxns=${ZOOKEEPER_MAX_CLIENT_CNXNS}" >> ${ZOOCFG}
echo "autopurge.snapRetainCount=${ZOOKEEPER_AUTOPURGE_SNAP_RETAIN_COUNT}" >> ${ZOOCFG}
echo "autopurge.purgeInterval=${ZOOKEEPER_AUTOPURGE_PURGE_INTERVAL}" >> ${ZOOCFG}
for ZOOKEEPER_SERVER in "${ZOOKEEPER_SERVER_LIST[@]}"
do 
  SERVER_ID=`echo "${ZOOKEEPER_SERVER}" | sed -e "s/^ZOOKEEPER_SERVER_\([0-9]\{1,\}\)=.\{1,\}/\1/"`
  SERVER_IP=`echo "${ZOOKEEPER_SERVER}" | sed -e "s/^ZOOKEEPER_SERVER_[0-9]\{1,\}=\(.\{1,\}\)$/\1/"`
  if [ "${SERVER_ID}" = "${ZOOKEEPER_ID}" ]; then
    echo "server.${SERVER_ID}=0.0.0.0:${ZOOKEEPER_PEER_PORT}:${ZOOKEEPER_ELECTION_PORT}" >> ${ZOOCFG}
    echo ${ZOOKEEPER_ID} > ${ZOOKEEPER_MYIDFILE}
  else
    echo "server.${SERVER_ID}=${SERVER_IP}:${ZOOKEEPER_PEER_PORT}:${ZOOKEEPER_ELECTION_PORT}" >> ${ZOOCFG}
  fi
done

# Show configuration file.
if [ -e ${ZOOCFG} ]; then
  echo ${ZOOCFG}
  cat ${ZOOCFG}
fi
if [ -e ${ZOOKEEPER_MYIDFILE} ]; then
  echo ${ZOOKEEPER_MYIDFILE}
  cat ${ZOOKEEPER_MYIDFILE}
fi

# Start ZooKeeper.
${ZOOKEEPER_PREFIX}/bin/zkServer.sh start-foreground ${ZOOCFG}
