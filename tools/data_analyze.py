import numpy as np
import matplotlib.pyplot as plt
from scipy.fft import fft, fftfreq
import argparse


# 读入imu数据
def load_imu(csv_file_path):
    data = np.loadtxt(csv_file_path, delimiter=',', skiprows=1)
    
    return data


# 读入gps数据
def load_gps(csv_file_path):
    gps_data = []
    
    
    return gps_data


# 频域分析
def plot_fft(data, sample_rate, title):
    N = len(data)
    yf = fft(data)
    xf = fftfreq(N, 1 / sample_rate)[:N // 2]
    plt.plot(xf, 2.0 / N * np.abs(yf[0:N // 2]))
    plt.grid()
    plt.title(title)
    plt.xlabel('Frequency (Hz)')
    plt.ylabel('Amplitude')
    plt.show()
    
    
# 统计分析，计算均值和方差
def statistical_analysis(data, title):
    mean = np.mean(data, axis=0)
    variance = np.var(data, axis=0)
    print(f'{title} Mean:', mean)
    print(f'{title} Variance:', variance)
    
    
# 完整性分析检查
def check_missing_data(data, title):
    if np.any(np.isnan(data)) or np.any(np.isinf(data)):
        print(f'{title} 包含缺失或无穷值')
    else:
        print(f'{title} 数据完整')
     
        
# 时序分析，可视化查看是否有时间的跳变、缺失等
def plot_imu_data(time, accel, gyro):
    fig, ax = plt.subplots(2, 1, figsize=(12, 8))
    
    ax[0].plot(time, accel)
    ax[0].set_title('Accelerometer Data')
    ax[0].set_xlabel('Time')
    ax[0].set_ylabel('Acceleration (m/s^2)')
    ax[0].legend(['X', 'Y', 'Z'])
    
    ax[1].plot(time, gyro)
    ax[1].set_title('Gyroscope Data')
    ax[1].set_xlabel('Time')
    ax[1].set_ylabel('Angular Velocity (rad/s)')
    ax[1].legend(['X', 'Y', 'Z'])
    
    plt.tight_layout()
    plt.show()
    

def second_derivative(time, data):
    # 计算时间间隔
    dt = np.diff(time)
    # import pdb; pdb.set_trace()
    # 计算一阶导数
    first_derivative = np.diff(data, axis=0) / dt
    # 计算一阶导数的时间间隔
    dt_first_derivative = (time[2:] - time[:-2]) / 2
    # 计算二阶导数
    result = np.diff(first_derivative, axis=0) / dt_first_derivative
    
    return result


# 计算二阶导数
def compute_second_derivative(time, accel, gyro):
    time = time / 1e9
    
    # 初始化加速度和角速度的二阶导数矩阵
    accel_second_derivative = np.zeros((accel.shape[0] - 2, accel.shape[1]))
    gyro_second_derivative = np.zeros((gyro.shape[0] - 2, gyro.shape[1]))
    
    # 计算每个加速度分量的二阶导数
    for i in range(accel.shape[1]):
        accel_second_derivative[:, i] = second_derivative(time, accel[:, i])
    
    # 计算每个角速度分量的二阶导数
    for i in range(gyro.shape[1]):
        gyro_second_derivative[:, i] = second_derivative(time, gyro[:, i])
    
    return accel_second_derivative, gyro_second_derivative

def plot_second_derivatives(time, second_derivative, title):
    plt.figure(figsize=(10, 6))
    Axis_name = ["X", "Y", "Z"]
    for i in range(second_derivative.shape[1]):
        plt.plot(time[1:-1], second_derivative[:, i], label=Axis_name[i])
    plt.title(title)
    plt.xlabel('Time')
    plt.ylabel('Second Derivative')
    plt.legend()
    plt.show()

if __name__ == "__main__":
    argparser = argparse.ArgumentParser(description=__doc__)
    argparser.add_argument(
        "-type",
        default="imu",
        help="gps or imu"
    )
    argparser.add_argument(
        "-csv_path",
        default="",
        help="path to data file"
    )
    
    args = argparser.parse_args()
    data_type = args.type
    data_path = args.csv_path
    
    if data_type == "imu":
        data_list = load_imu(data_path)
    else:
        data_list = load_gps(data_path)
    print("Load %s data! Totle %d!" % (data_type, len(data_list)))
    
    if data_type == "imu":
        time = data_list[1:, 0]
        gyr = data_list[1:, 1:4]
        acc = data_list[1:, 4:]
        
        # plot_imu_data(time, acc, gyr)
        
        # sample_rate = 100
        # plot_fft(acc[:, 0], sample_rate, 'Accelerometer X-Axis FFT')
        
        statistical_analysis(acc, 'Accelerometer')
        statistical_analysis(gyr, 'Gyroscope')
        
        check_missing_data(acc, 'Accelerometer')
        check_missing_data(gyr, 'Gyroscope')
        
        accel_second_derivative, gyro_second_derivative = compute_second_derivative(time, acc, gyr)
        plot_second_derivatives(time, accel_second_derivative, 'Second Derivative of Acceleration')
        plot_second_derivatives(time, gyro_second_derivative, 'Second Derivative of Angular Velocity')
    else:
        print("gps!")
        
    
    