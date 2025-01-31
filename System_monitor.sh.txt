#!/bin/bash

# Default values
LOG_FILE="system_monitor.log"
THRESHOLD=80  # Default disk usage threshold
EMAIL="negmsherif8@gmail.com"  # Default email recipient

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
df -h | grep -E '^/dev' | while read -r line; do
  usage=$(echo "$line" | awk '{print $5}' | sed 's/%//')  # Extract usage percentage
  if [ "$usage" -ge "$THRESHOLD" ]; then
    WARNING="Warning: High disk usage on $(echo "$line" | awk '{print $1}'): $usage%"
    echo "$WARNING" >> "$LOG_FILE"
    ALERT_MESSAGE="$ALERT_MESSAGE\n$WARNING"
  fi
  echo "$line" >> "$LOG_FILE"
done
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

# Send Email Alert if needed
if [ -n "$ALERT_MESSAGE" ]; then
  echo -e "System Monitoring Alert - $(date)\n$ALERT_MESSAGE" | mail -s "System Alert: High Disk Usage" "$EMAIL"
fi

# Print the report location
echo "System report saved to $LOG_FILE"
