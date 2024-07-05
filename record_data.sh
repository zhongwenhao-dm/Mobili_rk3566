#!/bin/bash

# 创建并启动容器
CONTAINER_NAME=test1
echo "Target container's name is '$CONTAINER_NAME'!"
if sudo docker inspect "$CONTAINER_NAME" > /dev/null 2>&1; then
    echo "Container '$CONTAINER_NAME' exists!"
else
    echo "Container '$CONTAINER_NAME' does not exist, create it!"
    bash ./create_container.sh $CONTAINER_NAME
fi


# 启动imu_component和gps_component
echo "Start imu_component and gps_component!"
gnome-terminal -- bash -c "sudo docker exec $CONTAINER_NAME bash -c "./components/drivers/imu_component_main"; exec bash"
gnome-terminal -- bash -c "sudo docker exec $CONTAINER_NAME bash -c "./components/drivers/gps_component_main"; exec bash"
# 等待10s让串口都链接上
sleep 10


# 捕获ctrl+c，终止数据录制
cleanup() {
    echo "Caught interrupt signal! Terminating process..."
    PID_RECORD=$(sudo docker exec $CONTAINER_NAME pgrep -f wurmloch_recorder)
    PID_IMU=$(sudo docker exec $CONTAINER_NAME pgrep -f imu_component_main)
    PID_GPS=$(sudo docker exec $CONTAINER_NAME pgrep -f gps_component_main)
    sudo docker exec $CONTAINER_NAME kill -9 $PID_RECORD $PID_GPS $PID_IMU
    exit 0
}
trap cleanup INT


# 录制数据
RECORD_DIR=./record/
sudo docker exec $CONTAINER_NAME bash -c "./external/dm_wurmloch/tools/wurmloch_recorder/wurmloch_recorder record --output $RECORD_DIR -a"







