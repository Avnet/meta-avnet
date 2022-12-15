#!/bin/sh -e

DEBUG=0

CONF_FILE=/home/root/factest_scripts/sysmon.conf
IIO_PATH=/sys/bus/iio/devices
SYSMON_NAME="ams"

get_iio_dev_by_name () {
   dev_name=$1

   iio_dev_path=$(grep -H $dev_name ${IIO_PATH}/*/name |cut -d "/" -f -6)
}

test_property () {
   prop_bank=$1
   prop_name=$2
   prop_unit=$3
   prop_details=$4
   prop_min=$5
   prop_max=$6

   if [ $DEBUG -eq 1 ]; then echo "debug: testing property name= $prop_name, bank=$prop_bank, unit='$prop_unit', details='$prop_details', min=$prop_min, max=$prop_max"; fi

   read_prop_raw=$(cat ${iio_dev_path}/${prop_name}_raw)
   if [ -z "$read_prop_raw" ]
   then
      echo "error: could not read ${prop_name}_raw"
      return 1
   fi

   read_prop_offset=$(cat ${iio_dev_path}/${prop_name}_offset 2>/dev/null)
   if [ -z "$read_prop_offset" ]
   then
      # offset is optional
      read_prop_offset=0
   fi

   read_prop_scale=$(cat ${iio_dev_path}/${prop_name}_scale)
   if [ -z "$read_prop_scale" ]
   then
      echo "error: could not read ${prop_name}_scale"
      return 1
   fi

   if [ $DEBUG -eq 1 ]; then echo "debug: read property $prop_name: raw=$read_prop_raw, offset=$read_prop_offset, scale=$read_prop_scale"; fi

   prop_value="$(bc <<< "scale=2; $read_prop_scale * ($read_prop_raw + $read_prop_offset) / 1000")"

   # IF a MIN and a MAX is defined
   if [[ -n $prop_min  && -n $prop_max ]]
   then
      printf "\n$prop_bank - $prop_details ($prop_name), computed value is $prop_value $prop_unit"
      if [ 1 -eq "$(echo "${prop_value} < ${prop_min}" | bc)" ]
      then
         echo -e "\n\terror: Low value $prop_value $prop_unit (< $prop_min)"
         return 1
      fi

      if [ 1 -eq "$(echo "${prop_value} > ${prop_max}" | bc)" ]
      then
         echo -e "\n\terror: High value $prop_value $prop_unit (> $prop_max)"
         return 1
      fi

      printf ", OK (between $prop_min and $prop_max)\n"

   else # No min or Max
      printf "\n$prop_bank - $prop_details ($prop_name), computed value is $prop_value $prop_unit\n"
   fi

   return 0
}

prop_count=0
error_count=0

echo "*** Test SYSMON properties"
echo "***"

get_iio_dev_by_name $SYSMON_NAME
if [ -z "$iio_dev_path" ]
then
   echo "error: could not find iio device '$SYSMON_NAME'"
   exit 1
fi

if [ $DEBUG -eq 1 ]; then echo "debug: found SYSMON device: $iio_dev_path"; fi

while IFS=$'\t' read -r bank name unit details min max
do
   if [[ -n $name ]]
   then
      prop_count=$((prop_count+1))
      status=0
      test_property "$bank" "$name" "$unit" "$details" "$min" "$max"|| status=$?
      if [ $status -ne 0 ]
      then
            echo "error: reading property $name"
            error_count=$((error_count+1))
      fi
   fi
done <<< $(grep -v '#' $CONF_FILE)

echo -e "\n***"

echo "*** Done."
echo "*** Number of tested properties = $prop_count"
echo "*** Number of errors = $error_count"
echo "***"

if [ $prop_count -eq 0 ] || [ $error_count -ne 0 ]
then
   exit 1
fi

exit
