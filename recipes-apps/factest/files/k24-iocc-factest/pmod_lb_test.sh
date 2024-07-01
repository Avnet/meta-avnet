#!/bin/sh -e

DEBUG=0

source /usr/local/bin/gpio/gpio_common.sh

PMOD_LB_LOOP_CNT=4

cd /sys/class/gpio

#
# Export the PMOD elements and set their direction
#
for (( i=0; i<$PMOD_LB_LOOP_CNT; i++ ))
do
   export_gpio `get_gpio PMOD_IN_$i` "in"
   export_gpio `get_gpio PMOD_OUT_$i` "out" 0
done

#
# Main while loop
#
echo "*** Write a '1' to each loopback output"
echo "*** and read it back on the input."
echo "***"

error_count=0

#
# Walking '1's loopback test for PMOD
#
echo "*** Walking '1's loopback test for PMOD"

for (( i=0; i<$PMOD_LB_LOOP_CNT; i++ ))
do
   gpio_number_out=`get_gpio PMOD_OUT_$i`
   echo 1 > gpio$gpio_number_out/value

   if [ $DEBUG -eq 1 ]; then echo -e "\ndebug: writing 1 to output gpio $i (number $gpio_number_out)"; fi

   for (( j=0; j<$PMOD_LB_LOOP_CNT; j++ ))
   do
      gpio_number_in=`get_gpio PMOD_IN_$j`
      read_bit=$(cat gpio$gpio_number_in/value) || read_bit=-1

      if [ $DEBUG -eq 1 ]; then echo "debug: reading $read_bit from input gpio $j (number $gpio_number_in)"; fi

      if [ $i -eq $j ]
      then
         if [ $read_bit -ne 1 ]
         then
            echo "error: bit $j of PMOD_IN should be set"
            error_count=$((error_count+1))
         fi
      else
         if [ $read_bit -ne 0 ]
         then
            echo "error: bit $j of PMOD_IN should not be set"
            error_count=$((error_count+1))
         fi
      fi
   done

   echo 0 > gpio$gpio_number_out/value
done

echo "***"
echo "***"


#
# Unexport the loopback I/Os
#
echo "*** Unexporting the sysfs GPIOs..."

for (( i=0; i<$PMOD_LB_LOOP_CNT; i++ ))
do
   unexport_gpio `get_gpio PMOD_IN_$i`
   unexport_gpio `get_gpio PMOD_OUT_$i`
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
