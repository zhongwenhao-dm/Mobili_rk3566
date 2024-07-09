#!/usr/bin/env python3

import os
import subprocess
import signal
from threading import Event
import json
import argparse

processes = []


def reset_terminal_settings():
    os.system("stty sane")


def launch_binaries(binaries):
    for binary in binaries:
        cmd = [binary["path"]] + binary["flags"]
        try:
            process = subprocess.Popen(cmd, preexec_fn=os.setsid)
        except OSError as e:
            print(e.strerror, cmd)
            terminate_processes()
            break
        except Exception as e:
            print(e.message, cmd)
            terminate_processes()
            break
        processes.append(process)


def terminate_processes():
    for process in processes:
        os.killpg(os.getpgid(process.pid), signal.SIGTERM)


def wait_for_termination():
    for process in processes:
        process.wait()


def signal_handler(sig, frame):
    print("\nCTRL+C detected. Terminating all processes...", flush=True)
    terminate_processes()
    reset_terminal_settings()
    print("Waiting for all processes to terminate...", flush=True)
    wait_for_termination()
    reset_terminal_settings()
    exit_event.set()
    print("All the process down!")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        prog='Component pool',
        description='launch a list of binaries',
        epilog='write a json launch file which contains the binaries and flags')
    parser.add_argument('launch_file')
    args = parser.parse_args()
    binaries = json.load(open(args.launch_file))["components"]
    print(binaries)

    signal.signal(signal.SIGINT, signal_handler)

    print("Launching binaries...")
    running_processes = launch_binaries(binaries)

    exit_event = Event()
    try:
        print("Press CTRL+C to terminate all processes.", flush=True)
        exit_event.wait()
    except KeyboardInterrupt:
        signal_handler(signal.SIGINT, None)
