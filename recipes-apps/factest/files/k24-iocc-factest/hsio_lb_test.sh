#!/bin/sh -e

DEBUG=0

source /usr/local/bin/gpio/gpio_common.sh

#Base addresses, copied from gpio_map.sh

# hsio_txr2_in1
BASE_HSIO_TXR2_IN1=$(get_gpiochip_base a0040000)
# hsio_txr2_in2
BASE_HSIO_TXR2_IN2=$(get_gpiochip_base a0050000)
# hsio_txr2_out1
BASE_HSIO_TXR2_OUT1=$(get_gpiochip_base a0060000)
# hsio_txr2_out2
BASE_HSIO_TXR2_OUT2=$(get_gpiochip_base a0070000)

TRX2_LB_LOOP_CNT=9

cd /sys/class/gpio

#
# Export the HSIO_TRX2_PL elements and set their direction
#
for (( i=0; i<$TRX2_LB_LOOP_CNT; i++ ))
do
   export_gpio $(($BASE_HSIO_TXR2_OUT1 + $i)) "out" 0
   export_gpio $(($BASE_HSIO_TXR2_IN1 + $i)) "in"
   export_gpio $(($BASE_HSIO_TXR2_OUT2 + $i)) "out" 0
   export_gpio $(($BASE_HSIO_TXR2_IN2 + $i)) "in"
done

#
# Main while loop
#
echo "*** Write a '1' to each loopback output"
echo "*** and read it back on the input."
echo "***"

error_count=0

#
# Walking '1's loopback test for HSIO TXR2 PL 1
#
echo "*** Walking '1's loopback test for HSIO TXR2 PL 1"

for (( i=0; i<$TRX2_LB_LOOP_CNT; i++ ))
do
   echo 1 > gpio$((BASE_HSIO_TXR2_OUT1 + $i))/value

   if [ $DEBUG -eq 1 ]; then echo -e "\ndebug: writing 1 to output gpio $i (number $((BASE_HSIO_TXR2_OUT1 + $i)))"; fi

   for (( j=0; j<$TRX2_LB_LOOP_CNT; j++ ))
   do
      read_bit=$(cat gpio$((BASE_HSIO_TXR2_IN1 + $j))/value) || read_bit=-1

      if [ $DEBUG -eq 1 ]; then echo "debug: reading $read_bit from input gpio $j (number $((BASE_HSIO_TXR2_IN1 + $j)))"; fi

      if [ $i -eq $j ]
      then
         if [ $read_bit -ne 1 ]
         then
            echo "error: bit $j of BASE_HSIO_TXR2_IN1 should be set"
            error_count=$((error_count+1))
         fi
      else
         if [ $read_bit -ne 0 ]
         then
            echo "error: bit $j of BASE_HSIO_TXR2_IN1 should not be set"
            error_count=$((error_count+1))
         fi
      fi
   done

   echo 0 > gpio$((BASE_HSIO_TXR2_OUT1 + $i))/value
done

#
# Walking '1's loopback test for HSIO TXR2 PL 2
#
echo "***"
echo "***"
echo "*** Walking '1's loopback test for HSIO TXR2 PL 2"

for (( i=0; i<$TRX2_LB_LOOP_CNT; i++ ))
do
   echo 1 > gpio$((BASE_HSIO_TXR2_OUT2 + $i))/value

   if [ $DEBUG -eq 1 ]; then echo -e "\ndebug: writing 1 to output gpio $i (number $((BASE_HSIO_TXR2_OUT2 + $i)))"; fi

   for (( j=0; j<$TRX2_LB_LOOP_CNT; j++ ))
   do
      read_bit=$(cat gpio$((BASE_HSIO_TXR2_IN2 + $j))/value) || read_bit=-1

      if [ $DEBUG -eq 1 ]; then echo "debug: reading $read_bit from input gpio $j (number $((BASE_HSIO_TXR2_IN2 + $j)))"; fi

      if [ $i -eq $j ]
      then
         if [ $read_bit -ne 1 ]
         then
            echo "error: bit $j of BASE_HSIO_TXR2_IN2 should be set"
            error_count=$((error_count+1))
         fi
      else
         if [ $read_bit -ne 0 ]
         then
            echo "error: bit $j of BASE_HSIO_TXR2_IN2 should not be set"
            error_count=$((error_count+1))
         fi
      fi
   done

   echo 0 > gpio$((BASE_HSIO_TXR2_OUT2 + $i))/value
done


echo "***"
echo "***"


#
# Unexport the loopback I/Os
#
echo "*** Unexporting the sysfs GPIOs..."

for (( i=0; i<$TRX2_LB_LOOP_CNT; i++ ))
do
   unexport_gpio $(($BASE_HSIO_TXR2_OUT1 + $i))
   unexport_gpio $(($BASE_HSIO_TXR2_IN1 + $i))
   unexport_gpio $(($BASE_HSIO_TXR2_OUT2 + $i))
   unexport_gpio $(($BASE_HSIO_TXR2_IN2 + $i))
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
