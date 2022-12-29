#!/bin/sh -e

DEBUG=0

# Check if there are any switches such unattended mode
unattended=0

if [[ $# -gt 0 ]]
then
      for var in "$@"
      do
         if [[ $var -eq "-u" ]]
         then
            unattended=1
         fi
      done
fi


source /usr/local/bin/gpio/gpio_common.sh

cd /sys/class/gpio

error_count=0


echo "*** TEST MIO_SWS and MIO_LEDS"
echo "***"

# MIO LEDs (PCB D9, D8, D7, D6)
MIO_LED_1_NB=`get_gpio MIO_LED_1`
MIO_LED_2_NB=`get_gpio MIO_LED_2`
MIO_LED_3_NB=`get_gpio MIO_LED_3`
MIO_LED_4_NB=`get_gpio MIO_LED_4`

# PS DIP switches (PCB SW4)
MIO_SW_1_NB=`get_gpio MIO_SW_1`
MIO_SW_2_NB=`get_gpio MIO_SW_2`
MIO_SW_3_NB=`get_gpio MIO_SW_3`
MIO_SW_4_NB=`get_gpio MIO_SW_4`

process_mio_sw_to_leds() {
   while :
   do
      cat gpio$MIO_SW_1_NB/value > gpio$MIO_LED_1_NB/value
      cat gpio$MIO_SW_2_NB/value > gpio$MIO_LED_2_NB/value
      cat gpio$MIO_SW_3_NB/value > gpio$MIO_LED_3_NB/value
      cat gpio$MIO_SW_4_NB/value > gpio$MIO_LED_4_NB/value
   done
}

setup_mio_switch_leds_process() {
   process_mio_sw_to_leds &
   PID=$!

   read -p "Do you confirm that each MIO_SW dip switch (SW4) turns a MIO_LED on and off [Y/n] " -n 1 -r
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
   echo 0 > gpio$MIO_LED_1_NB/value
   echo 0 > gpio$MIO_LED_2_NB/value
   echo 0 > gpio$MIO_LED_3_NB/value
   echo 0 > gpio$MIO_LED_4_NB/value
}

process_unattended_mio_leds() {
   # Switch on each LED independently one by one
   echo 1 > gpio$MIO_LED_1_NB/value
   sleep 1
   echo 0 > gpio$MIO_LED_1_NB/value
   echo 1 > gpio$MIO_LED_2_NB/value
   sleep 1
   echo 0 > gpio$MIO_LED_2_NB/value
   echo 1 > gpio$MIO_LED_3_NB/value
   sleep 1
   echo 0 > gpio$MIO_LED_3_NB/value
   echo 1 > gpio$MIO_LED_4_NB/value
   sleep 1
   echo 1 > gpio$MIO_LED_4_NB/value
   sleep 1
   echo 0 > gpio$MIO_LED_4_NB/value
}

export_gpio $MIO_LED_1_NB "out" 0
export_gpio $MIO_LED_2_NB "out" 0
export_gpio $MIO_LED_3_NB "out" 0
export_gpio $MIO_LED_4_NB "out" 0

export_gpio $MIO_SW_1_NB "in"
export_gpio $MIO_SW_2_NB "in"
export_gpio $MIO_SW_3_NB "in"
export_gpio $MIO_SW_4_NB "in"

if [[ $unattended -eq 1 ]]
then
   process_unattended_mio_leds
else
   setup_mio_switch_leds_process
fi

# Tidy up by unexporting GPIOs
unexport_gpio $MIO_LED_1_NB
unexport_gpio $MIO_LED_2_NB
unexport_gpio $MIO_LED_3_NB
unexport_gpio $MIO_LED_4_NB

unexport_gpio $MIO_SW_1_NB
unexport_gpio $MIO_SW_2_NB
unexport_gpio $MIO_SW_3_NB
unexport_gpio $MIO_SW_4_NB

# Function for setting up RGB LED in PL
setup_pl_rgb() {
   pl_led=$1

   rgb_led_nb=${RGB_LED_0_NB[@]}
   nb_gpios=0
   # Determine the correct set of pins to toggle depending on the LED requested
   if [[ pl_led -eq 1 ]]
   then
      rgb_led_nb=${RGB_LED_1_NB[@]}
      nb_gpios=${#RGB_LED_1_NB[@]}
   elif [[ pl_led -eq 0 ]]
   then
      rgb_led_nb=${RGB_LED_0_NB[@]}
      nb_gpios=${#RGB_LED_0_NB[@]}
   else
      echo "error: Invalid RGB_LED addressed. Can be either 0 or 1"
      exit 1
   fi

   if [ ${nb_gpios} -ne 3 ]
   then
      echo "error: wrong number of retrieved RGB_LED_${pl_led} from conf (${rgb_led_nb}, should be 3)"
      exit 1
   fi

   for gpio_nb in ${rgb_led_nb}; do
      export_gpio ${gpio_nb} "out" 0
   done
}

# Function for cleaning up RGB LED in PL
cleanup_pl_rgb() {
   pl_led=$1

   rgb_led_nb=${RGB_LED_0_NB[@]}
   # Determine the correct set of pins to toggle depending on the LED requested
   if [[ pl_led -eq 1 ]]
   then
      rgb_led_nb=${RGB_LED_1_NB[@]}
   elif [[ pl_led -eq 0 ]]
   then
      rgb_led_nb=${RGB_LED_0_NB[@]}
   else
      echo "error: Invalid RGB_LED addressed. Can be either 0 or 1"
      exit 1
   fi

   # turn off LEDs and unexport GPIO pins used to switch LEDs on
   for gpio_nb in ${rgb_led_nb}; do
      echo 0 > gpio${gpio_nb}/value
      unexport_gpio $gpio_nb
   done
}

# Process functions to switch the LED between colors when user
# presses associated button
process_pl_pb_to_rgb()
{
   pl_led=$1

   rgb_led_nb=${RGB_LED_0_NB[@]}
   pl_switch=`get_gpio MIO_PL`
   # Determine the correct set of pins to toggle/read input from depending on the 
   # LED requested
   if [[ pl_led -eq 1 ]]
   then
      rgb_led_nb=${RGB_LED_1_NB[@]}
      pl_switch=`get_gpio MIO_PB`
   elif [[ pl_led -eq 0 ]]
   then
      rgb_led_nb=${RGB_LED_0_NB[@]}
      pl_switch=`get_gpio PL_PB`
   else
      echo "error: Invalid RGB_LED addressed. Can be either 0 or 1"
      exit 1
   fi

   # Export PL PB switch for reading bbutton input
   export_gpio ${pl_switch} "in"

   i=0
   while :
   do
      while [ $(cat gpio${pl_switch}/value) -eq 1 ]; do :; done
      # button pressed
      if [ $DEBUG -eq 1 ]; then echo "debug: PL_PB button pressed"; fi
      i=$(((i+1)%3))
      j=0

      # Only turn on one LED at a time
      for gpio_nb in ${rgb_led_nb}; do
         if [ $j -eq $i ]
         then
            echo 1 > gpio$gpio_nb/value
         else
            echo 0 > gpio$gpio_nb/value
         fi
         j=$((j+1))
      done

      while [ $(cat gpio${pl_switch}/value) -eq 0 ]; do :; done
      # button released
   done

   # Unexport button GPIO
   unexport_gpio ${pl_switch}
}

# Function for setting up the LED and running the process for controlling
# the LED using a button
setup_pl_pb_to_rgb_process()
{
   pl_led=$1

   process_pl_pb_to_rgb ${pl_led} &
   PID=$!

   if [[ pl_led -eq 0 ]]
   then 
      read -p "Do you confirm that pushing PL_PB (SW3) button switch the color of the RGB_LED_0 (D4) [Y/n] " -n 1 -r
   elif [[ pl_led -eq 1 ]]
   then
      read -p "Do you confirm that pushing MIO_PB (SW1) button switch the color of the RGB_LED_1 (D5) [Y/n] " -n 1 -r
   else
      echo "error: Invalid RGB_LED addressed. Can be either 0 or 1"
      exit 1
   fi

   if [[ $REPLY =~ ^[Yy]$ ]]  || [[ -z $REPLY ]]
   then
      echo -e "\n\tyes\n"
   else
      echo -e "\n\tno\n"
      error_count=$((error_count+1))
   fi

   kill $PID
   sleep 0.5
}

# Function which toggles through all colors of LED specified every 1s
process_unattended_pl_rgb()
{
   pl_led=$1

   rgb_led_nb=${RGB_LED_0_NB[@]}

   if [[ pl_led -eq 1 ]]
   then
      rgb_led_nb=${RGB_LED_1_NB[@]}
   elif [[ pl_led -eq 0 ]]
   then
      rgb_led_nb=${RGB_LED_0_NB[@]}
   else
      echo "error: Invalid RGB_LED addressed. Can be either 0 or 1"
      exit 1
   fi

   for gpio_nb in ${rgb_led_nb}; do
      echo 1 > gpio$gpio_nb/value
      sleep 1.0
   done

   for gpio_nb in ${rgb_led_nb}; do
      echo 0 > gpio$gpio_nb/value
      sleep 1.0
   done
}

echo "***"
echo "***"
echo "*** TEST PL_PB push button and RGB_LED_0"

# PL RGB 0 LEDs (PCB D4)

RGB_LED_0_NB=(`grep ^RGB_LED_0_ $GPIO_CONF | awk -F: '{print $2}'`)

if [ $DEBUG -eq 1 ]; then echo "debug: gpios = ${RGB_LED_0_NB[@]}"; fi

setup_pl_rgb 0

if [[ $unattended -eq 1 ]]
then
   process_unattended_pl_rgb 0

else 
   setup_pl_pb_to_rgb_process 0
fi

cleanup_pl_rgb 0

echo "***"
echo "***"
echo "*** TEST MIO_PB push button and RGB_LED_1"

# PL RGB 1 LEDs (PCB D4)
RGB_LED_1_NB=(`grep ^RGB_LED_1_ $GPIO_CONF | awk -F: '{print $2}'`)

if [ $DEBUG -eq 1 ]; then echo "debug: gpios = ${RGB_LED_1_NB[@]}"; fi

nb_gpios=${#RGB_LED_1_NB[@]}

setup_pl_rgb 1

if [[ $unattended -eq 1 ]]
then
   process_unattended_pl_rgb 1
else
   setup_pl_pb_to_rgb_process 1
fi

cleanup_pl_rgb 1


echo "***"
echo "*** Done."
echo "*** Number of errors = $error_count"
echo "***"

if [ $error_count -ne 0 ]
then
   exit 1
fi

exit

