# System Monitor Script

## Overview

This script provides real-time monitoring of system resources such as **disk usage**, **CPU usage**, and **memory usage**. It helps users assess system performance and identify potential issues. Additionally, it can send email alerts when disk usage exceeds a specified threshold.

## Features

- Displays disk usage of all mounted devices.
- Calculates and shows CPU usage percentage.
- Monitors available and used memory.
- Sends email alerts when disk usage exceeds a defined threshold.
- Can be scheduled to run periodically using **cron**.

## Prerequisites

- Ubuntu 24.04 (or any Linux distribution with `df`, `top`, `awk`, `grep`, `free`, and `sendemail` installed).
- A Gmail account with an **App Password** (since Google blocks less secure apps).

## Installation

### 1. Install Required Packages

Run the following commands to install `sendemail` and `ssmtp` for email alerts:

sudo apt update sudo apt install sendemail ssmtp -y

shell
Copy
Edit

### 2. Copy the Script to Your Home Directory

cp system_monitor.sh ~/system_monitor.sh

shell
Copy
Edit

### 3. Grant Execution Permissions

chmod +x ~/system_monitor.sh

shell
Copy
Edit

## Usage

To run the script manually:

./system_monitor.sh

csharp
Copy
Edit

## Configuration

### Set Disk Usage Alert Threshold

By default, the script sends an email alert when disk usage exceeds **1%**. To change this, update the `THRESHOLD` value in the script:

THRESHOLD=80 # Alerts if disk usage exceeds 80%

csharp
Copy
Edit

### Set Email Credentials

Modify the following variables with your Gmail credentials:

EMAIL="your_email@example.com" # Recipient email FROM="your_gmail@gmail.com" # Sender email SMTP_USER="your_gmail@gmail.com" SMTP_PASS="your_app_password"

pgsql
Copy
Edit

**Important**: If using Gmail, generate an **App Password** instead of your regular password.

## Example Output

🚨 Sending alert email... ✅ Email sent successfully! 📂 System report saved to system_monitor.log

markdown
Copy
Edit

## Script Breakdown

- **Disk Usage**: Uses `df -h | grep -E '^/dev'` to filter mounted disk partitions.
- **CPU Usage**: Extracts the idle percentage from `top -bn1` and calculates the used percentage.
- **Memory Usage**: Uses `free -m` to display available and used memory.
- **Email Alerts**: Uses `sendemail` to notify users of high disk usage.

## Automating with Cron

To schedule the script to run every 5 minutes, open the crontab editor:

crontab -e

arduino
Copy
Edit

Add the following line to schedule the script:

*/5 * * * * /home/your_username/system_monitor.sh >> /home/your_username/system_monitor.log 2>&1

markdown
Copy
Edit

## Troubleshooting

- **Permission Denied**: Ensure the script has execution rights:

chmod +x system_monitor.sh

markdown
Copy
Edit

- **Email Not Sent**: Ensure that `sendemail` and `ssmtp` are installed.
- **SMTP Authentication Failures**: Check your SMTP settings and verify your app password.

## Author

Created by **Negm**, Ubuntu 24.04, running in VMware.
