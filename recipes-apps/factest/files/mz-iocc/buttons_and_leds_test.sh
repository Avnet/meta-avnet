#!/bin/sh -e

DEBUG=0

source /usr/local/bin/gpio/gpio_common.sh

cd /sys/class/gpio

error_count=0

# axi_gpio_9 dip_sw_4bits & pb_sw_4bits
BASE_SW_8BITS=$(get_gpiochip_base 41290000)
# axi_gpio_10 leds_8bits
BASE_LEDS_8BITS=$(get_gpiochip_base 412A0000)

SW_LOOP_CNT=8

echo "*** TEST GPIO Switches and LEDS"
echo "***"

process_sw_to_leds() {
   echo "***"
   echo "***"
   echo "*** Turn on a LED for each DIP and PB switch"
   while :
   do
      for (( i=0; i<SW_LOOP_CNT; i++ ))
      do
         # read the switch state and write the value to the LED to turn on or off
         echo $(cat gpio$(($BASE_SW_8BITS + i))/value) > gpio$(($BASE_LEDS_8BITS + $i))/value
      done
   done
}

#~ # MIO LEDs (PCB D9, D8, D7, D6)
#~ MIO_LED_1_NB=`get_gpio MIO_LED_1`
#~ MIO_LED_2_NB=`get_gpio MIO_LED_2`
#~ MIO_LED_3_NB=`get_gpio MIO_LED_3`
#~ MIO_LED_4_NB=`get_gpio MIO_LED_4`

#~ # PS DIP switches (PCB SW4)
#~ MIO_SW_1_NB=`get_gpio MIO_SW_1`
#~ MIO_SW_2_NB=`get_gpio MIO_SW_2`
#~ MIO_SW_3_NB=`get_gpio MIO_SW_3`
#~ MIO_SW_4_NB=`get_gpio MIO_SW_4`

#~ process_mio_sw_to_leds() {
   #~ while :
   #~ do
      #~ echo $(cat gpio$MIO_SW_1_NB/value) > gpio$MIO_LED_1_NB/value
      #~ echo $(cat gpio$MIO_SW_2_NB/value) > gpio$MIO_LED_2_NB/value
      #~ echo $(cat gpio$MIO_SW_3_NB/value) > gpio$MIO_LED_3_NB/value
      #~ echo $(cat gpio$MIO_SW_4_NB/value) > gpio$MIO_LED_4_NB/value
   #~ done
#~ }


for (( i=0; i<$SW_LOOP_CNT; i++ ))
do
   export_gpio $(($BASE_LEDS_8BITS + $i)) "out" 0
   export_gpio $(($BASE_SW_8BITS + $i)) "in"
done

#export_gpio $MIO_LED_1_NB "out" 0
#export_gpio $MIO_LED_2_NB "out" 0
#export_gpio $MIO_LED_3_NB "out" 0
#export_gpio $MIO_LED_4_NB "out" 0

#export_gpio $MIO_SW_1_NB "in"
#export_gpio $MIO_SW_2_NB "in"
#export_gpio $MIO_SW_3_NB "in"
#export_gpio $MIO_SW_4_NB "in"

# process_mio_sw_to_leds &

process_sw_to_leds &

PID=$!

echo "Do you confirm that each DIP switch (SW1) and PB switch (PB[0:3]) "
echo "turns a LED (LED[1:8]) on and off [Y/n] "
read -p -n 1 -r
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
#~ echo 0 > gpio$MIO_LED_1_NB/value
#~ echo 0 > gpio$MIO_LED_2_NB/value
#~ echo 0 > gpio$MIO_LED_3_NB/value
#~ echo 0 > gpio$MIO_LED_4_NB/value

for (( i=0; i<SW_LOOP_CNT; i++ ))
do
   echo 0 > gpio$(($BASE_LEDS_8BITS + $i))/value
done



#~ unexport_gpio $MIO_LED_1_NB
#~ unexport_gpio $MIO_LED_2_NB
#~ unexport_gpio $MIO_LED_3_NB
#~ unexport_gpio $MIO_LED_4_NB

#~ unexport_gpio $MIO_SW_1_NB
#~ unexport_gpio $MIO_SW_2_NB
#~ unexport_gpio $MIO_SW_3_NB
#~ unexport_gpio $MIO_SW_4_NB


for (( i=0; i<$SW_LOOP_CNT; i++ ))
do
   unexport_gpio $(($BASE_LEDS_8BITS + $i))
   unexport_gpio $(($BASE_SW_8BITS + $i))
done

#~ echo "***"
#~ echo "***"
#~ echo "*** TEST PL_PB push button and RGB_LED_0"

#~ # PL RGB 0 LEDs (PCB D4)

#~ RGB_LED_0_NB=(`grep ^RGB_LED_0_ $GPIO_CONF | awk -F: '{print $2}'`)

#~ if [ $DEBUG -eq 1 ]; then echo "debug: gpios = ${RGB_LED_0_NB[@]}"; fi

#~ nb_gpios=${#RGB_LED_0_NB[@]}

#~ if [ $nb_gpios -ne 3 ]
#~ then
   #~ echo "error: wrong number of retrieved RGB_LED_0 from conf ($nb_gpios, should be 3)"
   #~ exit 1
#~ fi

#~ for gpio_nb in ${RGB_LED_0_NB[@]}; do
   #~ export_gpio $gpio_nb "out" 0
#~ done

#~ # PL PB switch (PCB SW3)
#~ PL_PB_NB=`get_gpio PL_PB`
#~ export_gpio $PL_PB_NB "in"

#~ process_pl_pb_to_rgb0 ()
#~ {
   #~ i=0
   #~ while :
   #~ do
      #~ while [ $(cat gpio$PL_PB_NB/value) -eq 1 ]; do :; done
      #~ # button pressed
      #~ if [ $DEBUG -eq 1 ]; then echo "debug: PL_PB button pressed"; fi
      #~ i=$(((i+1)%3))
      #~ j=0

      #~ # Only turn on one LED at a time
      #~ for gpio_nb in ${RGB_LED_0_NB[@]}; do
         #~ if [ $j -eq $i ]
         #~ then
            #~ echo 1 > gpio$gpio_nb/value
         #~ else
            #~ echo 0 > gpio$gpio_nb/value
         #~ fi
         #~ j=$((j+1))
      #~ done

      #~ while [ $(cat gpio$PL_PB_NB/value) -eq 0 ]; do :; done
      #~ # button released
   #~ done

#~ }

#~ process_pl_pb_to_rgb0 &
#~ PID=$!

#~ read -p "Do you confirm that pushing PL_PB (SW3) button switch the color of the RGB_LED_0 (D4) [Y/n] " -n 1 -r
#~ if [[ $REPLY =~ ^[Yy]$ ]]  || [[ -z $REPLY ]]
#~ then
   #~ echo -e "\n\tyes\n"
#~ else
   #~ echo -e "\n\tno\n"
   #~ error_count=$((error_count+1))
#~ fi

#~ kill $PID
#~ sleep 0.5

#~ # turn off LEDs
#~ for gpio_nb in ${RGB_LED_0_NB[@]}; do
   #~ echo 0 > gpio$gpio_nb/value
   #~ unexport_gpio $gpio_nb
#~ done

#~ unexport_gpio $PL_PB_NB


#~ echo "***"
#~ echo "***"
#~ echo "*** TEST MIO_PB push button and RGB_LED_1"

#~ # PL RGB 1 LEDs (PCB D4)
#~ RGB_LED_1_NB=(`grep ^RGB_LED_1_ $GPIO_CONF | awk -F: '{print $2}'`)

#~ if [ $DEBUG -eq 1 ]; then echo "debug: gpios = ${RGB_LED_1_NB[@]}"; fi

#~ nb_gpios=${#RGB_LED_1_NB[@]}

#~ if [ $nb_gpios -ne 3 ]
#~ then
   #~ echo "error: wrong number of retrieved RGB_LED_1 from conf ($nb_gpios, should be 3)"
   #~ exit 1
#~ fi

#~ for gpio_nb in ${RGB_LED_1_NB[@]}; do
   #~ export_gpio $gpio_nb "out" 0
#~ done

#~ # PS PB switch (PCB SW1)
#~ MIO_PB_NB=`get_gpio MIO_PB`
#~ export_gpio $MIO_PB_NB "in"

#~ process_mio_pb_to_rgb1 ()
#~ {
   #~ i=0
   #~ while :
   #~ do
      #~ while [ $(cat gpio$MIO_PB_NB/value) -eq 1 ]; do :; done
      #~ # button pressed
      #~ if [ $DEBUG -eq 1 ]; then echo "debug: MIO_PB button pressed"; fi
      #~ i=$(((i+1)%3))
      #~ j=0

      #~ # Only turn on one LED at a time
      #~ for gpio_nb in ${RGB_LED_1_NB[@]}; do
         #~ if [ $j -eq $i ]
         #~ then
            #~ echo 1 > gpio$gpio_nb/value
         #~ else
            #~ echo 0 > gpio$gpio_nb/value
         #~ fi
         #~ j=$((j+1))
      #~ done

      #~ while [ $(cat gpio$MIO_PB_NB/value) -eq 0 ]; do :; done
   #~ done

#~ }

#~ process_mio_pb_to_rgb1 &
#~ PID=$!

#~ read -p "Do you confirm that pushing MIO_PB (SW1) button switch the color of the RGB_LED_1 (D5) [Y/n] " -n 1 -r
#~ if [[ $REPLY =~ ^[Yy]$ ]]  || [[ -z $REPLY ]]
#~ then
   #~ echo -e "\n\tyes\n"
#~ else
   #~ echo -e "\n\tno\n"
   #~ error_count=$((error_count+1))
#~ fi

#~ kill $PID
#~ sleep 0.5

#~ for gpio_nb in ${RGB_LED_1_NB[@]}; do
   #~ echo 0 > gpio$gpio_nb/value
   #~ unexport_gpio $gpio_nb
#~ done

#~ unexport_gpio $MIO_PB_NB


echo "***"
echo "*** Done."
echo "*** Number of errors = $error_count"
echo "***"

if [ $error_count -ne 0 ]
then
   exit 1
fi

exit

