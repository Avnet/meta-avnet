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
   
   # ANSI escape codes to change text color
   # https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
   GREEN='\033[0;32m'
   YELLOW='\033[1;33m'
   BLUE='\033[0;34m'
   LTBLUE='\033[1;34m'
   RED='\033[0;31m'
   NC='\033[0m'
   
   # Acceleration due to gravity is 9.8 m/s^2
   GRAVITY=9.8

   IIO_PATH=/sys/bus/iio/devices

   # grep for the device name and parse to grab the iio:device<> number
   ACCEL_DEV=$(grep -H "icm42688-accel" ${IIO_PATH}/*/name |cut -d "/" -f 6)
   GYRO_DEV=$(grep -H "icm42688-gyro" ${IIO_PATH}/*/name |cut -d "/" -f 6)
   ZU_DEV=$(grep -H "ams" ${IIO_PATH}/*/name |cut -d "/" -f 6)
   
   ACCEL_DEV_PATH=${IIO_PATH}/${ACCEL_DEV}
   GYRO_DEV_PATH=${IIO_PATH}/${GYRO_DEV}
   ZU_DEV_PATH=${IIO_PATH}/${ZU_DEV}
   
   ACCEL_SCALE=$(cat ${ACCEL_DEV_PATH}/in_accel_scale)
   GYRO_SCALE=$(cat ${GYRO_DEV_PATH}/in_anglvel_scale)

   ZU_TEMP_OFFSET=$(cat ${ZU_DEV_PATH}/in_temp0_ps_temp_offset)
   ZU_TEMP_SCALE=$(cat ${ZU_DEV_PATH}/in_temp0_ps_temp_scale)

   clear
   echo "***"
   echo -e "*** ${GREEN}Welcome to the TDK IMU sensor demo for the Avnet ZUBoard 1CG!!! ${NC}"
   echo "***"
   echo "*** This script fetches accelerometer, gyroscope, and temperature data"
   echo -e "*** from a ${LTBLUE}TDK Invensense ICM42688-P 6DOF IMU${NC} sensor installed on"
   echo -e "*** a ${YELLOW}MikroE Click board (part #MIKROE-4237)${NC} using a SPI"
   echo -e "*** interface to the processing system in the ${RED}AMD-Xilinx ZU+${NC} device"
   echo -e "*** on the new ${GREEN}Avnet ZUBoard 1CG${NC} development board."
   echo "***"
   echo "*** Data is read from the sensor in Linux using the sysfs subsystem."
   echo "***"
   echo -e "*** Continuous loop.  Press ${RED}<ctrl>-c${NC} to exit."
   echo "***"
   
   # Stay in this subshell, in this loop, until <ctrl>-c is pressed 
   while :
   do

      ACCEL_X_RAW=$(cat ${ACCEL_DEV_PATH}/in_accel_x_raw)
      ACCEL_Y_RAW=$(cat ${ACCEL_DEV_PATH}/in_accel_y_raw)
      ACCEL_Z_RAW=$(cat ${ACCEL_DEV_PATH}/in_accel_z_raw)
      
      GYRO_X_RAW=$(cat ${GYRO_DEV_PATH}/in_anglvel_x_raw)
      GYRO_Y_RAW=$(cat ${GYRO_DEV_PATH}/in_anglvel_y_raw)
      GYRO_Z_RAW=$(cat ${GYRO_DEV_PATH}/in_anglvel_z_raw)
      
      IMU_TEMP_RAW=$(cat ${ACCEL_DEV_PATH}/in_temp_raw)
      ZU_TEMP_RAW=$(cat ${ZU_DEV_PATH}/in_temp0_ps_temp_raw)
      
      ACCEL_X_SCALED=$(echo - | awk "{print ($ACCEL_SCALE * $ACCEL_X_RAW)/$GRAVITY}")
      ACCEL_Y_SCALED=$(echo - | awk "{print ($ACCEL_SCALE * $ACCEL_Y_RAW)/$GRAVITY}")
      ACCEL_Z_SCALED=$(echo - | awk "{print ($ACCEL_SCALE * $ACCEL_Z_RAW)/$GRAVITY}")

      GYRO_X_SCALED=$(echo - | awk "{print ($GYRO_SCALE * $GYRO_X_RAW)}")
      GYRO_Y_SCALED=$(echo - | awk "{print ($GYRO_SCALE * $GYRO_Y_RAW)}")
      GYRO_Z_SCALED=$(echo - | awk "{print ($GYRO_SCALE * $GYRO_Z_RAW)}")
      
      IMU_TEMP_SCALED=$(echo - | awk "{print ($IMU_TEMP_RAW/132.48)+25}")
      ZU_TEMP_SCALED=$(echo - | awk "{print ($ZU_TEMP_SCALE * ($ZU_TEMP_RAW + $ZU_TEMP_OFFSET))/1000}")
      
      printf "*** Accelerometer (m/s^2): X: %5.2f, Y: %5.2f, Z: %5.2f\r\n" "${ACCEL_X_SCALED}" "${ACCEL_Y_SCALED}" "${ACCEL_Z_SCALED}"
      printf "*** Gyroscope (rad/s): X: %5.2f, Y: %5.2f, Z: %5.2f\r\n" "${GYRO_X_SCALED}" "${GYRO_Y_SCALED}" "${GYRO_Z_SCALED}"
      printf "*** Temperature (C): IMU: %5.2f, ZU+: %5.2f\r\n" "${IMU_TEMP_SCALED}" "${ZU_TEMP_SCALED}"
      echo "***"
      
      sleep 1
      
      tput cuu1
      tput cuu1
      tput cuu1
      tput cuu1
      #~ tput el
         
   done
)   
#printf "Exit...\n\r"
#echo "***"
echo ""

exit


