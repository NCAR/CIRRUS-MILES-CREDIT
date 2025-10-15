#!/bin/bash
# Path to the file to edit
FILE="/workspace/CIRRUS-MILES-CREDIT/model_predict_old.yaml"

echo "changing date on $FILE"

# Determine which 6-hour window we're in
hour=$(date +%H)
case $hour in
  00|01|02|03|04|05) start_hour=00 ;;
  06|07|08|09|10|11) start_hour=06 ;;
  12|13|14|15|16|17) start_hour=12 ;;
  *) start_hour=18 ;;
esac

# Build timestamps
date_str=$(date +%Y-%m-%d)
start_time="${date_str} $(printf "%02d" $start_hour):00:00"
end_time=$(date -d "$start_time +6 hours" +"%Y-%m-%d %H:%M:%S")

echo start and end
echo $start_time
echo $end_time

# Apply sed replacements in-place
sed -i \
  -e "s|^\(.*forecast_start_time: *\).*|\1\"${start_time}\"|" \
  -e "s|^\(.*forecast_end_time: *\).*|\1\"${end_time}\"|" \
  "$FILE"

cat $FILE
