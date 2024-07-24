#!/bin/bash

# PARENT_DIR=/home/dmgz/Data
# YML_FILE=/home/dmgz/ZWH/Mobili_rk3566/docker_compose/docker-compose-amd.yml
PARENT_DIR=/home/cat/Data
YML_FILE=~/work/Mobili_rk3566/docker_compose/docker-compose-arm-test.yml

TEMP_DIR=$PARENT_DIR/../temp
mkdir $TEMP_DIR

# 给保存的数据文件夹的后缀名
OUTPUT_DIR_NAME=$1

# 启动compose， 输出到日志文件
echo "start imu and gps component...."
sudo docker-compose -f $YML_FILE up -d gps imu
sleep 8
echo "start record component...."
sudo docker-compose -f $YML_FILE up -d record > $TEMP_DIR/docker-compose.log 2>&1 &

# 保存record容器id
RECORDER_CONTAINER_ID=$(docker-compose ps -q recorder)
echo $RECORDER_CONTAINER_ID > $TEMP_DIR/recorder_container.id


COMPOSE_PID=$!
echo $COMPOSE_PID > $TEMP_DIR/docker-compose.pid
echo $OUTPUT_DIR_NAME > $TEMP_DIR/output-dir.name
echo "docker-compose启动！"


           