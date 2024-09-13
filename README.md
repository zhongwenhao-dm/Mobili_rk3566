# Mobili_rk3566
在rk3566上部署mobili，实现数据录制和组件运行

- 使用前需要系统已经安装好git和docker

- 确保rk3566和电脑连接在同一局域网内，ssh连接控制rk3566


## 数据录制
使用如下命令录制数据，ctrl+c终止录制并杀死进程
```
bash ./record_data.sh
```


## Pose_Server
使用如下命令启动Pose_Server。

只启用三个component：imu_component, gps_component, pose_server_component，ctrl+c终止并杀死进程

```
bash ./start_service.sh
```


## 监控消息channel
monitor只能在arm架构上使用
进入容器内执行如下命令

```
./external/dm_wurmloch/tools/wurmloch_monitor/wurmloch_monitor
```


## 数据分析工具
稍微分析一下采集到的imu和gps的数据，看看有没有基本的异常
```
# 包括时序分析、频域分析、完整性分析、统计分析、二阶导可视化
python tools/data_analyze.py -type [imu/gps] -csv_path <csv_file_path>
```


## docker-cmopose部署容器
使用docker-compose部署容器
需要安装好docker-compose
```
# 安装docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.28.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# rk3566中启动、停止、监控
bash rk3566_scripts/start.sh
bash rk3566_scripts/stop.sh
bash rk3566_scripts/monitor.sh
