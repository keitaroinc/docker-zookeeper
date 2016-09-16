#!/usr/bin/env bash

# IP detection.
DETECTED_IP_LIST=($(
  ip addr show | grep -e "inet[^6]" | \
    sed -e "s/.*inet[^6][^0-9]*\([0-9.]*\)[^0-9]*.*/\1/" | \
    grep -v "^127\."
))
DETECTED_IP=${DETECTED_IP_LIST[0]:-127.0.0.1}
echo "DETECTED_IP=${DETECTED_IP}"

# Set environment variables.
ZOOKEEPER_PREFIX=${ZOOKEEPER_PREFIX:-/opt/zookeeper}
echo "ZOOKEEPER_PREFIX=${ZOOKEEPER_PREFIX}"
ZOO_DATADIR=${ZOO_DATADIR:-${ZOOKEEPER_PREFIX}/data}
echo "ZOO_DATADIR=${ZOO_DATADIR}"
ZOOCFGDIR=${ZOOCFGDIR:-${ZOOKEEPER_PREFIX}/conf}
echo "ZOOCFGDIR=${ZOOCFGDIR}"
ZOOCFG=${ZOOCFG:-${ZOOCFGDIR}/zoo.cfg}
echo "ZOOCFG=${ZOOCFG}"

ZOOKEEPER_SEED_HOST=${ZOOKEEPER_SEED_HOST:-""}
echo "ZOOKEEPER_SEED_HOST=${ZOOKEEPER_SEED_HOST}"
ZOOKEEPER_SEED_PORT=${ZOOKEEPER_SEED_PORT:-2181}
echo "ZOOKEEPER_SEED_PORT=${ZOOKEEPER_SEED_PORT}"

ZOOKEEPER_HOST_LIST=${ZOOKEEPER_HOST_LIST:-""}
echo "ZOOKEEPER_HOST_LIST=${ZOOKEEPER_HOST_LIST}"

ZOOKEEPER_ID=${ZOOKEEPER_ID:-""}
echo "ZOOKEEPER_ID=${ZOOKEEPER_ID}"

ZOOKEEPER_HOST=${ZOOKEEPER_HOST:-${DETECTED_IP}}
echo "ZOOKEEPER_HOST=${ZOOKEEPER_HOST}"
ZOOKEEPER_CLIENT_PORT=${ZOOKEEPER_CLIENT_PORT:-2181}
echo "ZOOKEEPER_CLIENT_PORT=${ZOOKEEPER_CLIENT_PORT}"
ZOOKEEPER_PEER_PORT=${ZOOKEEPER_PEER_PORT:-2888}
echo "ZOOKEEPER_PEER_PORT=${ZOOKEEPER_PEER_PORT}"
ZOOKEEPER_ELECTION_PORT=${ZOOKEEPER_ELECTION_PORT:-3888}
echo "ZOOKEEPER_ELECTION_PORT=${ZOOKEEPER_ELECTION_PORT}"
ZOOKEEPER_ROLE=${ZOOKEEPER_ROLE:-participant}
echo "ZOOKEEPER_ROLE=${ZOOKEEPER_ROLE}"
ZOOKEEPER_CLIENT_IP=${ZOOKEEPER_CLIENT_IP:-0.0.0.0}
echo "ZOOKEEPER_CLIENT_IP=${ZOOKEEPER_CLIENT_IP}"

ZOOKEEPER_TICK_TIME=${ZOOKEEPER_TICK_TIME:-2000}
echo "ZOOKEEPER_TICK_TIME=${ZOOKEEPER_TICK_TIME}"
ZOOKEEPER_INIT_LIMIT=${ZOOKEEPER_INIT_LIMIT:-10}
echo "ZOOKEEPER_INIT_LIMIT=${ZOOKEEPER_INIT_LIMIT}"
ZOOKEEPER_SYNC_LIMIT=${ZOOKEEPER_SYNC_LIMIT:-5}
echo "ZOOKEEPER_SYNC_LIMIT=${ZOOKEEPER_SYNC_LIMIT}"
ZOOKEEPER_MAX_CLIENT_CNXNS=${ZOOKEEPER_MAX_CLIENT_CNXNS:-60}
echo "ZOOKEEPER_MAX_CLIENT_CNXNS=${ZOOKEEPER_MAX_CLIENT_CNXNS}"
ZOOKEEPER_AUTOPURGE_SNAP_RETAIN_COUNT=${ZOOKEEPER_AUTOPURGE_SNAP_RETAIN_COUNT:-3}
echo "ZOOKEEPER_AUTOPURGE_SNAP_RETAIN_COUNT=${ZOOKEEPER_AUTOPURGE_SNAP_RETAIN_COUNT}"
ZOOKEEPER_AUTOPURGE_PURGE_INTERVAL=${ZOOKEEPER_AUTOPURGE_PURGE_INTERVAL:-1}
echo "ZOOKEEPER_AUTOPURGE_PURGE_INTERVAL=${ZOOKEEPER_AUTOPURGE_PURGE_INTERVAL}"

ZOOKEEPER_ACCESS_RETRY_COUNT=${ZOOKEEPER_ACCESS_RETRY_COUNT:-10}
echo "ZOOKEEPER_ACCESS_RETRY_COUNT=${ZOOKEEPER_ACCESS_RETRY_COUNT}"
ZOOKEEPER_ACCESS_INTERVAL=${ZOOKEEPER_ACCESS_INTERVAL:-1}
echo "ZOOKEEPER_ACCESS_INTERVAL=${ZOOKEEPER_ACCESS_INTERVAL}"

# Make directories.
mkdir -p ${ZOOCFGDIR}
mkdir -p ${ZOO_DATADIR}

# Start function
function start() {
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

  declare -a ZOOKEEPER_CONFIG=()

  if [ -n "${ZOOKEEPER_SEED_HOST}" ]; then
    # Generate dynamic configuration file from ${ZOOKEEPER_SEED_HOST}.
    if [ ${ZOOKEEPER_SEED_HOST} != ${ZOOKEEPER_HOST} ]; then
      for i in `seq ${ZOOKEEPER_ACCESS_RETRY_COUNT}`
      do
        ZOOKEEPER_CONFIG=($(
          echo "conf" | nc ${ZOOKEEPER_SEED_HOST} ${ZOOKEEPER_SEED_PORT} | grep -E "^server\.[0-9]{1,3}=.*" | grep -v -E "^server\.[0-9]{1,3}=${ZOOKEEPER_HOST}:.*:${ZOOKEEPER_CLIENT_PORT}$"
        ))
        if [ -n "${ZOOKEEPER_CONFIG}" ]; then
          break
        fi
        sleep ${ZOOKEEPER_ACCESS_INTERVAL}
      done
    fi
  else
    # Generate dynamic configuration file from ${ZOOKEEPER_HOST_LIST}.
    for HOST in ${ZOOKEEPER_HOST_LIST}
    do
      for i in `seq ${ZOOKEEPER_ACCESS_RETRY_COUNT}`
      do
        if [ ${HOST} != ${ZOOKEEPER_HOST} ]; then
          TMP_ZOOKEEPER_CONFIG=$(echo "conf" | nc ${HOST} ${ZOOKEEPER_CLIENT_PORT} | grep -E "^server\.[0-9]{1,3}=${HOST}:.*:${ZOOKEEPER_CLIENT_PORT}$")
          if [ -n "${TMP_ZOOKEEPER_CONFIG}" ]; then
            ZOOKEEPER_CONFIG=("${ZOOKEEPER_CONFIG[@]}" "${TMP_ZOOKEEPER_CONFIG}")
            break
          fi
          sleep ${ZOOKEEPER_ACCESS_INTERVAL}
        fi
      done
    done
  fi

  if [ -z ${ZOOKEEPER_ID} ]; then
    # Generate ZooKeeper ID list from ZooKeeper config.
    ZOOKEEPER_ID_LIST=($(
      for LINE in ${ZOOKEEPER_CONFIG[@]}
      do
        echo ${LINE} | cut -d"=" -f1 | cut -d"." -f2
      done | sort -u -n
    ))

    # Generate available ZooKeeper ID list
    AVAILABLE_ZOOKEEPER_ID_LIST=($(
      diff --old-line-format='' \
        --new-line-format='%L' \
        --unchanged-line-format='' \
        <(printf "%s\n" ${ZOOKEEPER_ID_LIST[@]}) \
        <(printf "%s\n" $(seq 1 255))
    ))

    # Detect ZooKeeper ID
    ZOOKEEPER_ID=${AVAILABLE_ZOOKEEPER_ID_LIST[0]}
  fi

  if [ -n "${ZOOKEEPER_CONFIG}" ]; then
    # Generate dynamic configuration file.
    echo -n > ${ZOOCFG}.dynamic
    for LINE in ${ZOOKEEPER_CONFIG[@]}
    do
      echo ${LINE} >> ${ZOOCFG}.dynamic
    done
    echo "server.${ZOOKEEPER_ID}=${ZOOKEEPER_HOST}:${ZOOKEEPER_PEER_PORT}:${ZOOKEEPER_ELECTION_PORT}:observer;${ZOOKEEPER_CLIENT_IP}:${ZOOKEEPER_CLIENT_PORT}" >> ${ZOOCFG}.dynamic

    # Start ZooKeeper as observer.
    ${ZOOKEEPER_PREFIX}/bin/zkServer-initialize.sh --configfile ${ZOOCFG} --myid ${ZOOKEEPER_ID} --force
    ${ZOOKEEPER_PREFIX}/bin/zkServer.sh start ${ZOOCFG}

    # Wait until reconfiguration.
    for i in `seq ${ZOOKEEPER_ACCESS_RETRY_COUNT}`
    do
      # Add ZooKeeper to the ensemble as participant.
      ${ZOOKEEPER_PREFIX}/bin/zkCli.sh -server ${ZOOKEEPER_HOST}:${ZOOKEEPER_CLIENT_PORT} reconfig -add "server.${ZOOKEEPER_ID}=${ZOOKEEPER_HOST}:${ZOOKEEPER_PEER_PORT}:${ZOOKEEPER_ELECTION_PORT}:${ZOOKEEPER_ROLE};${ZOOKEEPER_CLIENT_IP}:${ZOOKEEPER_CLIENT_PORT}"

      sleep ${ZOOKEEPER_ACCESS_INTERVAL}

      NEW_ZOOKEEPER_HOST=$(echo "conf" | nc ${ZOOKEEPER_HOST} ${ZOOKEEPER_CLIENT_PORT} | grep -E "^server\.[0-9]{1,3}=${ZOOKEEPER_HOST}:.*:${ZOOKEEPER_CLIENT_PORT}" | cut -d"=" -f2 | awk -F : '{print $1}')
      if [ "${NEW_ZOOKEEPER_HOST}" = "${ZOOKEEPER_HOST}" ]; then
        break
      fi
      sleep ${ZOOKEEPER_ACCESS_INTERVAL}
    done

    # Stop ZooKeeper.
    ${ZOOKEEPER_PREFIX}/bin/zkServer.sh stop ${ZOOCFG}
    
    sleep ${ZOOKEEPER_ACCESS_INTERVAL}
    
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

trap "docker-stop.sh; exit 1" TERM KILL INT QUIT

# Start
start

# Start infinitive loop.
while true
do
 sleep 1
done
