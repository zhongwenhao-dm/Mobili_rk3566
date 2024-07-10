#!/bin/bash

# PARENT_DIR=/home/dmgz/Data
# YML_FILE=/home/dmgz/ZWH/Mobili_rk3566/docker_compose/docker-compose-amd.yml
PARENT_DIR=/home/cat/Data
YML_FILE=~/work/Mobili_rk3566/docker_compose/docker-compose-arm.yml

TEMP_DIR=$PARENT_DIR/../temp

echo "Stop data recording!"

# 读取进程id，杀死进程
COMPOSE_PID=$(cat $TEMP_DIR/docker-compose.pid)
kill $COMPOSE_PID

sudo docker-compose -f $YML_FILE down

# 查找最近新增的子文件夹
OUTPUT_DIR_NAME=$(cat $TEMP_DIR/output-dir.name)
LATEST_DIR=$(find "$PARENT_DIR" -mindepth 1 -maxdepth 1 -type d -printf "%T@ %p\n" | sort -n | tail -1 | cut -d' ' -f2-)
# 检查是否找到子文件夹
if [ -z "$LATEST_DIR" ]; then
    echo "没有找到新增的子文件夹。"
    exit 0
fi
# 移动log文件到文件夹中
mv "$TEMP_DIR/docker-compose.log" "$LATEST_DIR/docker-compose.log"
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