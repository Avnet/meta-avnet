#!/bin/sh -e

DEBUG=0

IIO_PATH=/sys/bus/iio/devices
PRESSURE_SENSOR_NAME="lps22hh"
PRESS_PROPERTY_PRESS_RAW="in_pressure_raw"
PRESS_SCALE=4096 # LSB/hPa
PRESS_MIN=260
PRESS_MAX=1260

TEMP_SENSOR_NAME="stts22h"
TEMP_PROPERTY_TEMP_RAW="in_temp_ambient_raw"
TEMP_PROPERTY_SCALE="scale"
TEMP_MIN=-10
TEMP_MAX=60

get_iio_dev_by_name () {
   dev_name=$1

   iio_dev_path=$(grep -H $dev_name ${IIO_PATH}/*/name |cut -d "/" -f -6)
}

test_pressure_sensor () {

   get_iio_dev_by_name $PRESSURE_SENSOR_NAME
   if [ -z "$iio_dev_path" ]
   then
      echo "error: could not find iio device '$PRESSURE_SENSOR_NAME'"
      return 1
   fi

   if [ $DEBUG -eq 1 ]; then echo "debug: found pressure sensor: $iio_dev_path"; fi

   read_press_raw=$(cat $iio_dev_path/$PRESS_PROPERTY_PRESS_RAW)
   if [ -z "$read_press_raw" ]
   then
      echo "error: could not read pressure value"
      return 1
   fi

   if [ $DEBUG -eq 1 ]; then echo "debug: pressure_raw=$read_press_raw"; fi

   pressure=$(echo "scale=2; $read_press_raw/$PRESS_SCALE" | bc)
   echo -e "\n Pressure is $pressure hPa\n"

   if [ 1 -eq "$(echo "${pressure} < ${PRESS_MIN}" | bc)" ]
   then
      echo "error: Low Pressure $pressure hPa (< $PRESS_MIN)"
      return 1
   fi

   if [ 1 -eq "$(echo "${pressure} > ${PRESS_MAX}" | bc)" ]
   then
      echo "error: High Pressure $pressure hPa (> $PRESS_MAX)"
      return 1
   fi

   return 0
}

test_temperature_sensor () {

   get_iio_dev_by_name $TEMP_SENSOR_NAME
   if [ -z "$iio_dev_path" ]
   then
      echo "error: could not find iio device '$TEMP_SENSOR_NAME'"
      return 1
   fi

   if [ $DEBUG -eq 1 ]; then echo "debug: found temp sensor: $iio_dev_path"; fi

   read_temp_raw=$(cat $iio_dev_path/$TEMP_PROPERTY_TEMP_RAW)
   read_scale=$(cat $iio_dev_path/$TEMP_PROPERTY_SCALE)
   if [ -z "$read_temp_raw" ] || [ -z "$read_scale" ]
   then
      echo "error: could not read values (temp=$read_temp_raw, scale=$read_scale)"
      return 1
   fi

   if [ $DEBUG -eq 1 ]; then echo "debug: temp_raw=$read_temp_raw, scale=$read_scale"; fi

   temp=$(echo "scale=2; $read_temp_raw*$read_scale" | bc)
   echo -e "\n Temperature is $temp °C\n"

   if [ 1 -eq "$(echo "${temp} < ${TEMP_MIN}" | bc)" ]
   then
      echo "error: Low Temperature $temp °C (< $TEMP_MIN)"
      return 1
   fi

   if [ 1 -eq "$(echo "${temp} > ${TEMP_MAX}" | bc)" ]
   then
      echo "error: High Temperature $temp °C (> $TEMP_MAX)"
      return 1
   fi

   return 0
}

error_count=0

echo "*** Test Pressure Sensor ($PRESSURE_SENSOR_NAME)"
echo "***"

status=0
test_pressure_sensor || status=$?

if [ $status -ne 0 ]
then
      echo "error: reading pressure sensor"
      error_count=$((error_count+1))
fi
echo "***"

echo "*** Test Temperature Sensor ($TEMP_SENSOR_NAME)"
echo "***"

status=0
test_temperature_sensor || status=$?

if [ $status -ne 0 ]
then
      echo "error: reading temperature sensor"
      error_count=$((error_count+1))
fi
echo "***"


echo "*** Done."
echo "*** Number of errors = $error_count"
echo "***"

if [ $error_count -ne 0 ]
then
   exit 1
fi

exit
