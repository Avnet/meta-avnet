#!/bin/sh -e

error_count=0

sensors_array=("iio_hwmon-isa-0000" "irps5401-i2c-6-43" "irps5401-i2c-6-44" "ir38060-i2c-6-45")

read_sensor_temp1 () {
   sensor_string=$1
   status=0
   temp1=0

   temp1_str=$(sensors -u $sensor_string | grep temp1_input) || status=$?
   if [ $status -ne 0 ]
   then
      echo "error: reading temperature from sensor '$sensor_string'"
      return 1
   fi

   temp1=$(echo $temp1_str | awk -F: '{print $2}')
   echo "      temperature1 for sensor '$sensor_string' is $temp1 °C"

   if (( $(echo "$temp1 <= 0" | bc -l) ))
   then
      echo "      error: bad temperature read from sensor '$sensor_string', should be greater than 0"
      return 1
   fi

   return 0
}

for sensor in "${sensors_array[@]}"; do
   
   status=0

   echo "*** Test reading temperature on sensor '$sensor'"
   echo "***"

   read_sensor_temp1 $sensor || status=$?

   if [ $status -ne 0 ]
   then
      error_count=$((error_count+1))
   fi

   echo "***"

done

echo "*** Done."
echo "*** Number of errors = $error_count"
echo "***"

if [ $error_count -ne 0 ]
then
   exit 1
fi

exit
