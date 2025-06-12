#!/bin/bash
# Copyright (c) 2021 Cisco Systems, Inc. and Tim Evens.
# All rights reserved.

ADMIN_ID=${ADMIN_ID:="collector"}

DOCKER_HOST_IP=$(ip route | grep default | head -1 | awk '{ print $3}')

if [[ ${KAFKA_FQDN:-""} == "" ]]; then
   echo "ERROR: Missing ENV KAFKA_FQDN.  Cannot proceed until you add that in docker run -e KAFKA_FQDN=<...>"
   exit 1
else
    if [[ ${KAFKA_FQDN} == "localhost" ]]; then
        KAFKA_FQDN="docker-localhost"

    elif [[ ${KAFKA_FQDN} == "127.0.0.1" ]]; then
        KAFKA_FQDN="docker-localhost"

    elif [[ ${KAFKA_FQDN} == "::1" ]]; then
        KAFKA_FQDN="docker-localhost"
    fi
fi

#
# System info
#
if [[ ${MEM:-""} = "" ]]; then    
    SYS_TOTAL_MEM=$(grep MemTotal /proc/meminfo | awk '{print int($2 / 1000)}')
else
    SYS_TOTAL_MEM=$(($MEM * 1024))
fi

SYS_NUM_CPU=$(grep processor /proc/cpuinfo | wc -l)

# Update the hosts file
echo "$DOCKER_HOST_IP         docker-localhost" >> /etc/hosts

# Update the etc hosts file
if [[ -f /config/hosts ]]; then
    cat /config/hosts >> /etc/hosts
fi


# Update collectord config file
COLLECTOR_CFG_FILE=/usr/etc/bgpdata/collectord.conf
sed -r -i "s/admin_id:.*/admin_id: ${ADMIN_ID}/" /usr/etc/bgpdata/collectord.conf
sed -r -i "s/localhost:9092/${KAFKA_FQDN}/" /usr/etc/bgpdata/collectord.conf

# Startup delay to allow for Kafka to start if not already running
echo "Waiting 30 seconds to allow for Kafka and other containers to startup."
sleep 30

# Start collectord and wait - collectord runs in foreground

echo "Running collectord collector, see /var/log/collectord.log "
/usr/bin/collectord -f -c ${COLLECTOR_CFG_FILE}