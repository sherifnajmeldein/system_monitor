System Monitor Script
Overview
This script provides real-time monitoring of system resources such as disk usage, CPU usage, and memory usage. It helps users quickly assess the system's performance and identify potential issues. Additionally, it can send email alerts when disk usage exceeds a specified threshold.

Features
✅ Displays disk usage of all mounted devices.
✅ Calculates and shows CPU usage percentage.
✅ Monitors available and used memory.
✅ Sends email alerts when disk usage exceeds a threshold.
✅ Can be scheduled to run periodically using cron.

Prerequisites
Ubuntu 24.04 (or any Linux distribution with df, top, awk, grep, free, and sendemail installed).
A Gmail account with an App Password (since Google blocks less secure apps).
Installation
1️⃣ Install Required Packages
Before using the script, install sendemail and ssmtp for sending alerts:

sh
Copy
Edit
sudo apt update
sudo apt install sendemail ssmtp -y
2️⃣ Copy the Script to Your Home Directory
sh
Copy
Edit
cp system_monitor.sh ~/system_monitor.sh
3️⃣ Grant Execution Permission
sh
Copy
Edit
chmod +x ~/system_monitor.sh
Usage
To run the script manually:

sh
Copy
Edit
./system_monitor.sh
Configuration
Set Disk Usage Alert Threshold
By default, the script sends an email alert when disk usage exceeds 1%.
To change this, update the THRESHOLD value in the script:

sh
Copy
Edit
THRESHOLD=80  # Alerts if disk usage exceeds 80%
Set Email Credentials
Modify these variables in the script with your Gmail credentials:

sh
Copy
Edit
EMAIL="your_email@example.com"  # Recipient email
FROM="your_gmail@gmail.com"     # Sender email
SMTP_USER="your_gmail@gmail.com"
SMTP_PASS="your_app_password"
💡 Important: If using Gmail, generate an App Password instead of using your regular password.

Example Output
sh
Copy
Edit
🚨 Sending alert email...
✅ Email sent successfully!
📂 System report saved to system_monitor.log
Script Breakdown
Disk Usage: Uses df -h | grep -E '^/dev' to filter mounted disk partitions.
CPU Usage: Extracts idle percentage from top -bn1 and calculates the used percentage.
Memory Usage: Uses free -m to display available and used memory.
Email Alerts: Uses sendemail to notify users of high disk usage.
Automating with Cron
To schedule the script to run every 5 minutes:

sh
Copy
Edit
crontab -e
Add the following line at the end of the file:

sh
Copy
Edit
*/5 * * * * /home/your_username/system_monitor.sh >> /home/your_username/system_monitor.log 2>&1
Troubleshooting
🔹 If you get Permission denied, ensure the script has execution rights:

sh
Copy
Edit
chmod +x system_monitor.sh
🔹 If email is not sent, ensure sendemail and ssmtp are installed.
🔹 Check SMTP settings if authentication fails.

Author
Created by Negm, Ubuntu 24.04, running in VMware.
