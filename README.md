# Mobili_rk3566
在rk3566上部署mobili，实现数据录制和组件运行

使用前需要系统已经安装好git和docker


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

```

```
