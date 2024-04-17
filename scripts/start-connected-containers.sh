#!/bin/bash
# Check if variable is set correctly
if [ -z "${CONNECTED_CONTAINERS%%:*}" ] || [ -z "${CONNECTED_CONTAINERS#*:}" ] || [[ "${CONNECTED_CONTAINERS}" != *:* ]]; then
  echo "---The variable CONNECTED_CONTAINERS is not set properly!---"
  echo "---Please set it like: 127.0.0.1:27286---"
  exit 1
fi

# Wait 10 seconds to start the connection
sleep 10
echo "---Starting connected containers watchdog on ${CONNECTED_CONTAINERS}---"
nc ${CONNECTED_CONTAINERS%%:*} ${CONNECTED_CONTAINERS#*:}
EXIT_STATUS=$?

# Determin on exit status if connection was successfull or if container should be restarted
if [ "${EXIT_STATUS}" != 0 ]; then
  echo "---Couldn't connect to: ${CONNECTED_CONTAINERS%%:*} on port: ${CONNECTED_CONTAINERS#*:}"
  exit 1
else
  echo "---Connection to connected container: ${CONNECTED_CONTAINERS} lost, restarting in 10 seconds...---"
  sleep 10
  kill -SIGTERM $(pidof java)
fi