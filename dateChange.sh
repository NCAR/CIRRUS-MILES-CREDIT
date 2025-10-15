#!/bin/bash
# Path to the file to edit
FILE="/workspace/CIRRUS-MILES-CREDIT/model_predict_old.yml"
#export TZ="America/Denver"

# Determine which 6-hour window we're in
hour=$(date +%H)
case $hour in
  00|01|02|03|04|05) start_hour=00 ;;
  06|07|08|09|10|11) start_hour=06 ;;
  12|13|14|15|16|17) start_hour=12 ;;
  *) start_hour=18 ;;
esac

# Build timestamps
#TZ="America/Denver"
#date_str=$(TZ="America/Denver" date +%Y-%m-%d)
#start_time="${date_str} $(printf "%02d" $start_hour):00:00"
#end_time=$(date -d "$start_time +6 hours" +"%Y-%m-%d %H:%M:%S")

#start_time=$(TZ="America/Denver" date +"%Y-%m-%d %H:00:00")
#end_time=$(TZ="America/Denver" date -d "$start_time +6 hours" +"%Y-%m-%d %H:%M:%S")

#start_time=$(TZ="America/Denver" date +"%Y-%m-%d %H:00:00"); \
#end_time=$(TZ="America/Denver" date -d "$start_time +6 hours" +"%Y-%m-%d %H:%M:%S")

#TZ="America/Denver"
#start_time=$(date +"%Y-%m-%d %H:00:00")
#end_time=$(date -d "$start_time +6 hours" +"%Y-%m-%d %H:%M:%S")

#echo "start time $start_time"
#echo "end   time $end_time"

#start_time=$(TZ="America/Denver" date +"%Y-%m-%d %H:00:00")
#end_time=$(date -d "$(TZ="America/Denver" date -d "$start_time +6 hours")" +"%Y-%m-%d %H:%M:%S")

# Get epoch time for now in Denver
epoch_start=$(TZ="America/Denver" date +%s)
# Add 6 hours (in seconds)
epoch_end=$((epoch_start + 6*3600))
# Format both in Denver local time
start_time=$(TZ="America/Denver" date -d @"$epoch_start" +"%Y-%m-%d %H:%M:%S")
end_time=$(TZ="America/Denver" date -d @"$epoch_end" +"%Y-%m-%d %H:%M:%S")
echo "start=$start_time end=$end_time"

# Apply sed replacements in-place
sed -i \
  -e "s|^\(.*forecast_start_time: *\).*|\1\"${start_time}\"|" \
  -e "s|^\(.*forecast_end_time: *\).*|\1\"${end_time}\"|" \
  "$FILE"
