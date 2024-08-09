#!/bin/bash

# PARENT_DIR=/home/dmgz/Data
# YML_FILE=/home/dmgz/ZWH/Mobili_rk3566/docker_compose/docker-compose-pose_server-amd.yml
PARENT_DIR=/home/cat/Data
YML_FILE=~/work/Mobili_rk3566/docker_compose/docker-compose-pose_server-arm.yml

TEMP_DIR=$PARENT_DIR/../temp
mkdir $TEMP_DIR

# 给保存的数据文件夹的后缀名
OUTPUT_DIR_NAME=$1

# 启动compose， 输出到日志文件
sudo docker-compose -f $YML_FILE up > $TEMP_DIR/docker-compose.log 2>&1 &
sleep 4

# 保存record容器id，以及原始的session_name
RECORDER_CONTAINER_ID=$(sudo docker-compose -f $YML_FILE ps -q record)
echo $RECORDER_CONTAINER_ID > $TEMP_DIR/recorder_container.id
SESSION_NAME=$(grep -m 1 "Write to session:" "$TEMP_DIR/docker-compose.log" | awk -F': ' '{print $2}' | awk '{$1=$1;print}')
echo $SESSION_NAME > $TEMP_DIR/session_name.txt


COMPOSE_PID=$!
echo $COMPOSE_PID > $TEMP_DIR/docker-compose.pid
echo $OUTPUT_DIR_NAME > $TEMP_DIR/output-dir.name
echo "docker-compose启动！"

