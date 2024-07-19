#!/bin/bash

# PARENT_DIR=/home/dmgz/Data
# YML_FILE=/home/dmgz/ZWH/Mobili_rk3566/docker_compose/docker-compose-pose_server-amd.yml
PARENT_DIR=/home/cat/Data
YML_FILE=~/work/Mobili_rk3566/docker_compose/docker-compose-pose_server-arm.yml


# 启动compose
sudo docker-compose -f $YML_FILE up

echo "docker-compose-pose_server启动！"

