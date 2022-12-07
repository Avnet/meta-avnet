#!/bin/sh -e

DEBUG=0

source /usr/local/bin/gpio/gpio_common.sh

cd /sys/class/gpio

error_count=0

# axi_gpio_9 dip_sw_4bits & pb_sw_4bits
BASE_SW_8BITS=$(get_gpiochip_base 41290000)
#echo $BASE_SW_8BITS

# axi_gpio_10 leds_8bits
BASE_LEDS_8BITS=$(get_gpiochip_base 412a0000)
#echo $BASE_LEDS_8BITS

SW_LOOP_CNT=8

process_sw_to_leds() {
   echo "***"
   echo "*** Turn on a LED for each slide and pushbutton switch"
   while :
   do
      for (( i=0; i<SW_LOOP_CNT; i++ ))
      do
         # read the switch state and write the value to the LED to turn on or off
         echo $(cat gpio$(($BASE_SW_8BITS + i))/value) > gpio$(($BASE_LEDS_8BITS + $i))/value
      done
   done
}

for (( i=0; i<$SW_LOOP_CNT; i++ ))
do
   export_gpio $(($BASE_LEDS_8BITS + $i)) "out" 0
   export_gpio $(($BASE_SW_8BITS + $i)) "in"
done

echo "***"
echo "*** Test GPIO Switches and LEDS"
echo "*** Press each pushbutton switch and toggle each slide switch to"
echo "*** turn each LED on/off"
echo "***"

# start the function to loop reading the switches in the background
process_sw_to_leds &

# capture the process ID of the background process so we can easily kill it later
PID=$!

# short delay to allow the process_sw_to_leds process to start and display
# its user messages
sleep 1

echo "*** Do you confirm that each DIP switch (SW1) and PB switch (BTN[1:4]) "
echo "*** turns a LED (LED[1:8]) on and off [Y/n] "
read -p "" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]  || [[ -z $REPLY ]]
then
   echo -e "\n\tYes\n"
else
   echo -e "\n\tNo\n"
   error_count=$((error_count+1))
fi

kill $PID
sleep 0.5

# turn off the LEDs
for (( i=0; i<SW_LOOP_CNT; i++ ))
do
   echo 0 > gpio$(($BASE_LEDS_8BITS + $i))/value
done

# unexport the switches and LEDs GPIOs
echo "***"
echo "*** Unexporting the sysfs GPIOs..."
for (( i=0; i<$SW_LOOP_CNT; i++ ))
do
   unexport_gpio $(($BASE_LEDS_8BITS + $i))
   unexport_gpio $(($BASE_SW_8BITS + $i))
done

echo "***"
echo "*** Done."
echo "*** Number of errors = $error_count"
echo "***"

if [ $error_count -ne 0 ]
then
   exit 1
fi

exit

