#!/bin/bash

CONTAINER_NAME=docker_compose-record-1
sudo docker start $CONTAINER_NAME
sudo docker exec -it $CONTAINER_NAME bash -c "./external/dm_wurmloch/tools/wurmloch_monitor/wurmloch_monitor"