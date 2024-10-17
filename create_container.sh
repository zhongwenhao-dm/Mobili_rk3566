#!/bin/bash

# 获取系统架构类型
arch=$(uname -m)

# 根据不同的架构拉取不同的镜像
if [ "$arch" == "x86_64" ]; then
    echo "The system is based on x86-64 (AMD64) architecture."
    # AMD64系统
    IMG=aliyunregistry-gz-mobi-registry.cn-guangzhou.cr.aliyuncs.com/dm/mobili-app-amd64:presubmit-20241017-df153

elif [ "$arch" == "aarch64" ] || [ "$arch" == "arm64" ]; then
    echo "The system is based on ARM64 architecture."
    # ARM64系统
    IMG=aliyunregistry-gz-mobi-registry.cn-guangzhou.cr.aliyuncs.com/dm/mobili-app:presubmit-20241017-df153

elif [ "$arch" == "armv7l" ] || [ "$arch" == "armv6l" ]; then
    echo "The system is based on 32-bit ARM architecture."
    exit 1
else
    echo "Unknown architecture: $arch"
    exit 1
fi

# 创建容器
NAME=$1
sudo docker run -it -d --name $NAME \
    --privileged \
    --hostname in_docker \
    --add-host in_docker:127.0.0.1 \
    -e DISPLAY \
    -e NVIDIA_VISIBLE_DEVICES=all \
    -e NVIDIA_DRIVER_CAPABILITIES=all \
    -v /etc/localtime:/etc/localtime:ro \
    -v /lib/modules:/lib/modules \
    -v /dev:/dev \
    -v /media:/media \
    -v /mnt:/mnt \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /usr/src:/usr/src \
    -v /home/cat/Data:/work/record \
    $IMG \
    /bin/bash


