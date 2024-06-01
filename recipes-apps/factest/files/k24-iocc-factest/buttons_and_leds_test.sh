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


echo "*** TEST PS DIP switches and PS LEDs"
echo "***"

# PS LEDs (PCB D13, D14, D16, D17)
PS_LED_0_NB=`get_gpio PS_LED_0`
PS_LED_1_NB=`get_gpio PS_LED_1`
PS_LED_2_NB=`get_gpio PS_LED_2`
PS_LED_3_NB=`get_gpio PS_LED_3`

# PS DIP switches (PCB SW2)
PS_SW_0_NB=`get_gpio PS_SW_0`
PS_SW_1_NB=`get_gpio PS_SW_1`
PS_SW_2_NB=`get_gpio PS_SW_2`
PS_SW_3_NB=`get_gpio PS_SW_3`

process_ps_sw_to_leds() {
   while :
   do
      cat gpio$PS_SW_0_NB/value > gpio$PS_LED_3_NB/value
      cat gpio$PS_SW_1_NB/value > gpio$PS_LED_2_NB/value
      cat gpio$PS_SW_2_NB/value > gpio$PS_LED_1_NB/value
      cat gpio$PS_SW_3_NB/value > gpio$PS_LED_0_NB/value
   done
}

setup_ps_switch_leds_process() {
   process_ps_sw_to_leds &
   PID=$!

   read -p "Do you confirm that each PS_SW dip switch (SW2) turns a PS_LED on and off [Y/n] " -n 1 -r
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
   echo 0 > gpio$PS_LED_0_NB/value
   echo 0 > gpio$PS_LED_1_NB/value
   echo 0 > gpio$PS_LED_2_NB/value
   echo 0 > gpio$PS_LED_3_NB/value
}

process_unattended_ps_leds() {
   # Switch on each LED independently one by one
   echo 1 > gpio$PS_LED_0_NB/value
   sleep 1
   echo 0 > gpio$PS_LED_0_NB/value
   sleep 1
   echo 1 > gpio$PS_LED_1_NB/value
   sleep 1
   echo 0 > gpio$PS_LED_1_NB/value
   echo 1 > gpio$PS_LED_2_NB/value
   sleep 1
   echo 0 > gpio$PS_LED_2_NB/value
   echo 1 > gpio$PS_LED_3_NB/value
   sleep 1
   echo 0 > gpio$PS_LED_3_NB/value
   sleep 1
}

export_gpio $PS_LED_0_NB "out" 0
export_gpio $PS_LED_1_NB "out" 0
export_gpio $PS_LED_2_NB "out" 0
export_gpio $PS_LED_3_NB "out" 0

export_gpio $PS_SW_0_NB "in"
export_gpio $PS_SW_1_NB "in"
export_gpio $PS_SW_2_NB "in"
export_gpio $PS_SW_3_NB "in"

if [[ $unattended -eq 1 ]]
then
   process_unattended_ps_leds
else
   setup_ps_switch_leds_process
fi

# Tidy up by unexporting GPIOs
unexport_gpio $PS_LED_0_NB
unexport_gpio $PS_LED_1_NB
unexport_gpio $PS_LED_2_NB
unexport_gpio $PS_LED_3_NB

unexport_gpio $PS_SW_0_NB
unexport_gpio $PS_SW_1_NB
unexport_gpio $PS_SW_2_NB
unexport_gpio $PS_SW_3_NB

echo "*** TEST PS Push Buttons and PL LEDs"
echo "***"

# PL LEDs (PCB D19, D20)
PL_LED_0_NB=`get_gpio PL_LED_0`
PL_LED_1_NB=`get_gpio PL_LED_1`

# PS PB switchs (PCB PB3, PB4)
PS_PB_0_NB=`get_gpio PS_PB_0`
PS_PB_1_NB=`get_gpio PS_PB_1`

process_ps_pb_to_leds() {
   while :
   do
      cat gpio$PS_PB_0_NB/value > gpio$PL_LED_0_NB/value
      cat gpio$PS_PB_1_NB/value > gpio$PL_LED_1_NB/value
   done
}

setup_ps_pb_leds_process() {
   process_ps_pb_to_leds &
   PID=$!

   read -p "Do you confirm that the PS Push Buttons (PB3, PB4) turn the PL LEDs (D19, D20) on and off [Y/n] " -n 1 -r
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
   echo 0 > gpio$PL_LED_0_NB/value
   echo 0 > gpio$PL_LED_1_NB/value
}

process_unattended_pl_leds() {
   # Switch on each LED independently one by one
   echo 1 > gpio$PL_LED_0_NB/value
   sleep 1
   echo 0 > gpio$PL_LED_0_NB/value
   sleep 1
   echo 1 > gpio$PL_LED_1_NB/value
   sleep 1
   echo 0 > gpio$PL_LED_1_NB/value
   sleep 1
}

export_gpio $PL_LED_0_NB "out" 0
export_gpio $PL_LED_1_NB "out" 0

export_gpio $PS_PB_0_NB "in"
export_gpio $PS_PB_1_NB "in"

if [[ $unattended -eq 1 ]]
then
   process_unattended_pl_leds
else
   setup_ps_pb_leds_process
fi

# Tidy up by unexporting GPIOs
unexport_gpio $PL_LED_0_NB
unexport_gpio $PL_LED_1_NB

unexport_gpio $PS_PB_0_NB
unexport_gpio $PS_PB_1_NB


# Function for setting up RGB LED
setup_rgb() {
   led_id=$1

   rgb_led_nb=${RGB_LED_0_NB[@]}
   nb_gpios=0
   # Determine the correct set of pins to toggle depending on the LED requested
   if [[ led_id -eq 1 ]]
   then
      rgb_led_nb=${RGB_LED_1_NB[@]}
      nb_gpios=${#RGB_LED_1_NB[@]}
   elif [[ led_id -eq 0 ]]
   then
      rgb_led_nb=${RGB_LED_0_NB[@]}
      nb_gpios=${#RGB_LED_0_NB[@]}
   else
      echo "error: Invalid RGB_LED addressed. Can be either 0 or 1"
      exit 1
   fi

   if [ ${nb_gpios} -ne 3 ]
   then
      echo "error: wrong number of retrieved RGB_LED_${led_id} from conf (${rgb_led_nb}, should be 3)"
      exit 1
   fi

   for gpio_nb in ${rgb_led_nb}; do
      export_gpio ${gpio_nb} "out" 0
   done
}

# Function for cleaning up RGB LED
cleanup_rgb() {
   led_id=$1

   rgb_led_nb=${RGB_LED_0_NB[@]}
   # Determine the correct set of pins to toggle depending on the LED requested
   if [[ led_id -eq 1 ]]
   then
      rgb_led_nb=${RGB_LED_1_NB[@]}
   elif [[ led_id -eq 0 ]]
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
   led_id=$1

   rgb_led_nb=${RGB_LED_0_NB[@]}

   # Determine the correct set of pins to toggle/read input from depending on the 
   # LED requested
   if [[ led_id -eq 1 ]]
   then
      rgb_led_nb=${RGB_LED_1_NB[@]}
      pl_switch=`get_gpio PL_PB_1`
   elif [[ led_id -eq 0 ]]
   then
      rgb_led_nb=${RGB_LED_0_NB[@]}
      pl_switch=`get_gpio PL_PB_0`
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
   led_id=$1

   process_pl_pb_to_rgb ${led_id} &
   PID=$!

   if [[ led_id -eq 0 ]]
   then 
      read -p "Do you confirm that pushing PL_PB_0 (PB5) button switch the color of the PL RGB LEDs (D15) [Y/n] " -n 1 -r
   elif [[ led_id -eq 1 ]]
   then
      read -p "Do you confirm that pushing PL_PB_1 (PB6) button switch the color of the PS RGB LEDs (D18) [Y/n] " -n 1 -r
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
process_unattended_rgb()
{
   led_id=$1

   rgb_led_nb=${RGB_LED_0_NB[@]}

   if [[ led_id -eq 1 ]]
   then
      rgb_led_nb=${RGB_LED_1_NB[@]}
   elif [[ led_id -eq 0 ]]
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
echo "*** TEST PL_PB_0 push button and PL_RGB_LED"

# PL RGB LEDs (PCB D15)

RGB_LED_0_NB=(`grep ^PL_RGB_LED_ $GPIO_CONF | awk -F: '{print $2}'`)

if [ $DEBUG -eq 1 ]; then echo "debug: gpios = ${RGB_LED_0_NB[@]}"; fi

setup_rgb 0

if [[ $unattended -eq 1 ]]
then
   process_unattended_rgb 0

else 
   setup_pl_pb_to_rgb_process 0
fi

cleanup_rgb 0

echo "***"
echo "***"
echo "*** TEST PL_PB_1 push button and PS_RGB_LED"

# PL RGB LEDs (PCB D15)
RGB_LED_1_NB=(`grep ^PS_RGB_LED_ $GPIO_CONF | awk -F: '{print $2}'`)

if [ $DEBUG -eq 1 ]; then echo "debug: gpios = ${RGB_LED_1_NB[@]}"; fi

nb_gpios=${#RGB_LED_1_NB[@]}

setup_rgb 1

if [[ $unattended -eq 1 ]]
then
   process_unattended_rgb 1
else
   setup_pl_pb_to_rgb_process 1
fi

cleanup_rgb 1


echo "***"
echo "*** Done."
echo "*** Number of errors = $error_count"
echo "***"

if [ $error_count -ne 0 ]
then
   exit 1
fi

exit

