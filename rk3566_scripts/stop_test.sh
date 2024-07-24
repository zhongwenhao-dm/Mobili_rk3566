#!/bin/bash

# PARENT_DIR=/home/dmgz/Data
# YML_FILE=/home/dmgz/ZWH/Mobili_rk3566/docker_compose/docker-compose-amd.yml
PARENT_DIR=/home/cat/Data
YML_FILE=~/work/Mobili_rk3566/docker_compose/docker-compose-arm-test.yml

TEMP_DIR=$PARENT_DIR/../temp

echo "Stop data recording!"

# 读取进程id，杀死进程
# COMPOSE_PID=$(cat $TEMP_DIR/docker-compose.pid)
# kill $COMPOSE_PID

# 找到recorder_container id，终止recorder
if [ -f $TEMP_DIR/recorder_container.id ]; then
    echo "find recorder container, send SIGINT to the process....."
    # 读取容器 ID
    RECORDER_CONTAINER_ID=$(cat $TEMP_DIR/recorder_container.id)
    # 发送 SIGINT 信号到 recorder 容器内的进程
    PID_RECORD=$(sudo docker exec $RECORDER_CONTAINER_ID pgrep -f wurmloch_recorder)
    sudo docker exec $RECORDER_CONTAINER_ID kill -SIGINT $PID_RECORD
    sleep 5
fi

sudo docker-compose -f $YML_FILE down

# 查找最近新增的子文件夹
OUTPUT_DIR_NAME=$(cat $TEMP_DIR/output-dir.name)
LATEST_DIR=$(find "$PARENT_DIR" -mindepth 1 -maxdepth 1 -type d -printf "%T@ %p\n" | sort -n | tail -1 | cut -d' ' -f2-)
# 检查是否找到子文件夹
if [ -z "$LATEST_DIR" ]; then
    echo "没有找到新增的子文件夹。"
    exit 0
fi
# 移动log文件到最新文件夹中
mv "$TEMP_DIR/docker-compose.log" "$LATEST_DIR/docker-compose.log"

# 找到log中的GPS_TIME
# I20240717 14:18:39.930855 1346944 serial_port_gps.cc:133] GPS time = 20240705203456
LOG_FILE=$LATEST_DIR/docker-compose.log
GPS_TIME=$(grep -m 1 "GPS time =" "$LOG_FILE" | awk -F'=' '{print $2}' | awk '{$1=$1;print}')
# 如果找到了GPS_TIME，将其作为文件夹的名称
if [ -n "${GPS_TIME}" ]; then
    mv "$LATEST_DIR" "$PARENT_DIR/$GPS_TIME"
    LATEST_DIR="$PARENT_DIR/$GPS_TIME"
fi

# 如果存在输入，重命名最新的文件夹
if [ -n  "${OUTPUT_DIR_NAME}" ]; then
    BASE_NAME=$(basename "$LATEST_DIR")
    NEW_NAME="${BASE_NAME}_${OUTPUT_DIR_NAME}"
    mv "$LATEST_DIR" "$PARENT_DIR/$NEW_NAME"
    echo $PARENT_DIR/$NEW_NAME
else
    echo $LATEST_DIR
fi

rm -rf $TEMP_DIR
echo "delete $TEMP_DIR"

exit 0