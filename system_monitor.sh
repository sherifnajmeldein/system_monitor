#!/bin/bash

# Default values
LOG_FILE="system_monitor.log"
THRESHOLD=80  # Set a disk usage threshold (default 80%)
EMAIL="Your recipient's email"  # Your email recipient

# Email parameters
FROM="Your-Email"
SMTP_SERVER="smtp.gmail.com:587"
SMTP_USER="Your-Email"
SMTP_PASS=$(cat ~/.smtp_pass)  # Read password securely

# Parse command-line options
while getopts "f:t:e:" opt; do
  case $opt in
    f) LOG_FILE="$OPTARG" ;;
    t) THRESHOLD="$OPTARG" ;;
    e) EMAIL="$OPTARG" ;;
  esac
done

# Start logging
echo "System Monitoring Report - $(date)" > "$LOG_FILE"
echo "======================================" >> "$LOG_FILE"

# Check Disk Usage
ALERT_MESSAGE=""
echo "Disk Usage:" >> "$LOG_FILE"
while read -r line; do
  usage=$(echo "$line" | awk '{print $5}' | sed 's/%//')
  echo "Checking disk usage: $usage%"  # Debugging line
  if [ "$usage" -ge "$THRESHOLD" ]; then
    WARNING="Warning: High disk usage on $(echo "$line" | awk '{print $1}'): $usage%"
    echo "$WARNING" >> "$LOG_FILE"
    ALERT_MESSAGE="${ALERT_MESSAGE}\n${WARNING}"
  fi
  echo "$line" >> "$LOG_FILE"
done < <(df -h | grep -E '^/dev')

echo "" >> "$LOG_FILE"

# Check CPU Usage
echo "CPU Usage:" >> "$LOG_FILE"
top -bn1 | grep "Cpu(s)" | awk '{print "CPU Usage:", 100 - $8, "%"}' >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

# Check Memory Usage
echo "Memory Usage:" >> "$LOG_FILE"
free -h | awk 'NR==2{print "Total:", $2, "| Used:", $3, "| Free:", $4}' >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

# Check Running Processes
echo "Top 5 Memory-Consuming Processes:" >> "$LOG_FILE"
ps aux --sort=-%mem | awk 'NR==1 || NR<=6 {print $2, $1, $4, $11}' >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

# Function to send email
send_email() {
  echo "Attempting to send email..."  # Debugging line
  echo -e "$1" | sendemail -f "$FROM" -t "$EMAIL" \
  -u "System Monitoring Alert - $(date)" \
  -s "$SMTP_SERVER" -o tls=yes \
  -xu "$SMTP_USER" -xp "$SMTP_PASS" \
  -o message-content-type=text/plain
  
  if [ $? -eq 0 ]; then
    echo "✅ Email sent successfully!"  # Success debug line
  else
    echo "❌ Email failed to send."  # Failure debug line
  fi
}

# Send Email Alert if needed
if [ -n "$ALERT_MESSAGE" ]; then
  echo "🚨 Sending alert email..."  # Debugging line
  send_email "System Monitoring Alert - $(date)\n$ALERT_MESSAGE"
else
  echo "✅ No critical alerts. No email sent."  # Debugging line
fi

# Print the report location
echo "📂 System report saved to $LOG_FILE"
