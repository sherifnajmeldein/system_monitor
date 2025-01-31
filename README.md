# System Monitor Script

## Overview
This script provides real-time monitoring of system resources such as disk usage, CPU usage, and memory usage. It helps users quickly assess the system's performance and identify potential issues.

## Features
- Displays disk usage of all mounted devices.
- Calculates and shows CPU usage percentage.
- Monitors available and used memory.
- Can be scheduled to run periodically using `cron`.

## Prerequisites
- Ubuntu 24.04 (or any Linux distribution with `df`, `top`, `awk`, `grep`, and `free` installed).
- Basic knowledge of running shell scripts.

## Installation
1. Copy the script to your home directory:
   ```sh
   cp system_monitor.sh ~/system_monitor.sh
   ```
2. Grant execution permission:
   ```sh
   chmod +x ~/system_monitor.sh
   ```

## Usage
To run the script manually:
```sh
./system_monitor.sh
```

### Example Output
```sh
System Monitoring Report - Thu Jan 30 04:00:01 AM EET 2025
======================================
Disk Usage:
/dev/sda2        49G  9.8G   37G  22% /
Warning: High disk usage on /dev/sr0: 100%
/dev/sr0        5.8G  5.8G     0 100% /media/negm/Ubuntu 24.04.1 LTS amd64

CPU Usage:
CPU Usage: 40.9 %

Memory Usage:
Total: 7.7Gi | Used: 1.3Gi | Free: 5.4Gi

Top 5 Memory-Consuming Processes:
PID USER %MEM COMMAND
2293 negm 2.9 /usr/bin/gnome-shell
5577 negm 1.8 /usr/bin/nautilus
5756 negm 1.8 /usr/bin/gnome-text-editor
3077 negm 0.9 /usr/libexec/mutter-x11-frames
2399 negm 0.9 /usr/bin/Xwayland
```

## Script Breakdown
- **Disk Usage:** Uses `df -h | grep -E '^/dev'` to filter mounted disk partitions.
- **CPU Usage:** Extracts idle percentage from `top -bn1` and calculates the used percentage.
- **Memory Usage:** Uses `free -m` to display available and used memory.

## Automating with Cron
To schedule the script to run every 5 minutes:
```sh
crontab -e
```
Add the following line at the end of the file:
```sh
*/5 * * * * /home/your_username/system_monitor.sh >> /home/your_username/system_monitor.log 2>&1
```

## Troubleshooting
- If you get `Permission denied`, ensure the script has execution rights:
  ```sh
  chmod +x system_monitor.sh
  ```
- If output is incorrect, verify that `top`, `df`, and `free` are installed.

## Author
Created by **Negm**, Ubuntu 24.04, running in VMware.

