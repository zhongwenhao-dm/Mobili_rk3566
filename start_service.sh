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

# 捕获ctrl+c，终止数据录制
cleanup() {
    echo "Caught interrupt signal! Terminating process..."
    PID_POSE=$(sudo docker exec $CONTAINER_NAME pgrep -f pose_server_component_main)
    PID_IMU=$(sudo docker exec $CONTAINER_NAME pgrep -f imu_component_main)
    PID_GPS=$(sudo docker exec $CONTAINER_NAME pgrep -f gps_component_main)
    sudo docker exec $CONTAINER_NAME kill -9 $PID_POSE $PID_GPS $PID_IMU
    exit 0
}
trap cleanup INT

# 启动imu_component和gps_component
echo "Start imu_component and gps_component!"
gnome-terminal -- bash -c "sudo docker exec $CONTAINER_NAME bash -c "./components/drivers/imu_component_main"; exit"
gnome-terminal -- bash -c "sudo docker exec $CONTAINER_NAME bash -c "./components/drivers/gps_component_main"; exit"
echo "wait 12 seconds for imu and gps components....."
sleep 12

# 启动pose_server_component
CONFIG_FILE=msp20_pose_server_rk3566.proto.txt
sudo docker cp ./config/$CONFIG_FILE $CONTAINER_NAME:/work/launch/xavier_local/$CONFIG_FILE
sudo docker exec $CONTAINER_NAME bash -c "./components/map/pose_server_component_main --config_file /work/launch/xavier_local/$CONFIG_FILE"

sleep 100