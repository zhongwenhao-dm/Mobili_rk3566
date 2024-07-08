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
        # import pdb; pdb.set_trace()
        time = data_list[1:, 0]
        gyr = data_list[1:, 1:4]
        acc = data_list[1:, 4:]
        
        plot_imu_data(time, acc, gyr)
        
        sample_rate = 100
        plot_fft(acc[:, 0], sample_rate, 'Accelerometer X-Axis FFT')
        
        statistical_analysis(acc, 'Accelerometer')
        statistical_analysis(gyr, 'Gyroscope')
        
        check_missing_data(acc, 'Accelerometer')
        check_missing_data(gyr, 'Gyroscope')
    else:
        print("gps!")
        
    
    