#!/bin/sh -e

DEBUG=0


source /usr/local/bin/gpio/gpio_common.sh

cd /sys/class/gpio

error_count=0


echo "*** TEST MIO_PS_LEDS AND GPIO_PB"
echo "***"

# MIO PS LEDs (PCB D3, D4, D6, D7)
MIO_PS_LED_0_NB=`get_gpio MIO_PS_LED_0`
MIO_PS_LED_1_NB=`get_gpio MIO_PS_LED_1`
MIO_PS_LED_2_NB=`get_gpio MIO_PS_LED_2`
MIO_PS_LED_3_NB=`get_gpio MIO_PS_LED_3`

process_mio_leds() {
   while :
   do
      # Switch on each LED independently one by one
      echo 1 > gpio$MIO_PS_LED_0_NB/value
      sleep 0.5
      echo 0 > gpio$MIO_PS_LED_0_NB/value

      echo 1 > gpio$MIO_PS_LED_1_NB/value
      sleep 0.5
      echo 0 > gpio$MIO_PS_LED_1_NB/value

      echo 1 > gpio$MIO_PS_LED_2_NB/value
      sleep 0.5
      echo 0 > gpio$MIO_PS_LED_2_NB/value

      echo 1 > gpio$MIO_PS_LED_3_NB/value
      sleep 0.5
      echo 0 > gpio$MIO_PS_LED_3_NB/value
   done
}

# Function for setting up the LEDs and running the process for controlling
# the LEDs using a button
setup_gpio_pb_to_leds_process()
{
   process_mio_leds &
   PID=$!

   read -p "Do you confirm that the 4 MIO_PS_LEDs turn on and off [Y/n] " -n 1 -r
   if [[ $REPLY =~ ^[Yy]$ ]]  || [[ -z $REPLY ]]
   then
      echo -e "\n\tyes\n"
   else
      echo -e "\n\tno\n"
      error_count=$((error_count+1))
   fi

   kill $PID
   sleep 0.5

   echo 0 > gpio$MIO_PS_LED_0_NB/value
   echo 0 > gpio$MIO_PS_LED_1_NB/value
   echo 0 > gpio$MIO_PS_LED_2_NB/value
   echo 0 > gpio$MIO_PS_LED_3_NB/value
}

export_gpio $MIO_PS_LED_0_NB "out" 0
export_gpio $MIO_PS_LED_1_NB "out" 0
export_gpio $MIO_PS_LED_2_NB "out" 0
export_gpio $MIO_PS_LED_3_NB "out" 0

setup_gpio_pb_to_leds_process

# Tidy up by unexporting GPIOs
unexport_gpio $MIO_PS_LED_0_NB
unexport_gpio $MIO_PS_LED_1_NB
unexport_gpio $MIO_PS_LED_2_NB
unexport_gpio $MIO_PS_LED_3_NB

echo "***"
echo "***"
echo "*** TEST WIFI AND BT LEDS"

# MIO PS LEDs (PCB D3, D4, D6, D7)
WIFI_LED_NB=`get_gpio WIFI_LED`
BT_LED_NB=`get_gpio BT_LED`

process_wifi_bt_leds() {
   while :
   do
      echo 1 > gpio$WIFI_LED_NB/value
      sleep 0.5
      echo 0 > gpio$WIFI_LED_NB/value

      echo 1 > gpio$BT_LED_NB/value
      sleep 0.5
      echo 0 > gpio$BT_LED_NB/value
   done
}


setup_wifi_bt_leds_process() {
   process_wifi_bt_leds &
   PID=$!

   read -p "Do you confirm that the WIFI_LED and BT_LED turn on and off [Y/n] " -n 1 -r
   if [[ $REPLY =~ ^[Yy]$ ]]  || [[ -z $REPLY ]]
   then
      echo -e "\n\tyes\n"
   else
      echo -e "\n\tno\n"
      error_count=$((error_count+1))
   fi

   kill $PID
   sleep 0.5

   # turn off LEDs
   echo 0 > gpio$WIFI_LED_NB/value
   echo 0 > gpio$BT_LED_NB/value
}

export_gpio $WIFI_LED_NB "out" 0
export_gpio $BT_LED_NB "out" 0

setup_wifi_bt_leds_process

# Tidy up by unexporting GPIOs
unexport_gpio $WIFI_LED_NB
unexport_gpio $BT_LED_NB


echo "***"
echo "*** Done."
echo "*** Number of errors = $error_count"
echo "***"

if [ $error_count -ne 0 ]
then
   exit 1
fi

exit

