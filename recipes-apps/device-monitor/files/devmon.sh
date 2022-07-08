#!/bin/sh

# Run commands within the (...) below in a subshell and trap when <ctrl>-c is pressed.
# This will allow the script to keep running and statements after the subshell to 
# execute after <ctrl>-c is pressed.
# https://stackoverflow.com/questions/46816904/bash-break-out-of-loop-with-ctrl-c-but-continue-with-script
(
   trap printout SIGINT
   printout() {
      echo ""
      #echo "***"
      #printf "*** Stop detected with <ctrl>-c.  "
      exit
   }
   
   IIO_PATH=/sys/bus/iio/devices
   
   # grep for the device name and parse to grab the iio:device<> number
   ZU_DEV=$(grep -H "ams" ${IIO_PATH}/*/name |cut -d "/" -f 6)

   ZU_DEV_PATH=${IIO_PATH}/${ZU_DEV}

   OFFSET=$(cat ${ZU_DEV_PATH}/in_temp0_ps_temp_offset)
   SCALE=$(cat ${ZU_DEV_PATH}/in_temp0_ps_temp_scale)
   
   echo "***"
   echo "*** Continuous loop to read device temperature.  Press <ctrl>-c to exit."
   echo "***"
   
   # Stay in this subshell, in this loop, until <ctrl>-c is pressed 
   while :
   do
   
      RAW=$(cat ${ZU_DEV_PATH}/in_temp0_ps_temp_raw)
      DEV_TEMP=$(echo - | awk "{print ($SCALE * ($RAW + $OFFSET))/1000}")
      printf "*** Device temperature is: %.2fC\r" "${DEV_TEMP}"
      sleep 2
   done
)   
#printf "Exit...\n\r"
echo "***"

exit


