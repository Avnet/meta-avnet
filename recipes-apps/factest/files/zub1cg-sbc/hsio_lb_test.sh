#!/bin/sh -e

DEBUG=0

source /usr/local/bin/gpio/gpio_common.sh

#Base addresses, copied from gpio_map.sh

# axi_gpio_0 rgb_led_0
BASE_RGB_LED_0=$(get_gpiochip_base a0000000)
# axi_gpio_1 rgb_led_1
BASE_RGB_LED_1=$(get_gpiochip_base a0010000)
# axi_gpio_2 hsio_trx2_mio_lb
BASE_HSIO_TRX2_MIO_LB=$(get_gpiochip_base a0020000)
# axi_gpio_3 hsio_trx2_pl_lb
BASE_HSIO_TRX2_PL_LB=$(get_gpiochip_base a0030000)
# axi_gpio_4 hsio_std_lb
BASE_HSIO_STD_LB=$(get_gpiochip_base a0040000)
# axi_gpio_5 hsio_trx2_pl_pwr
BASE_HSIO_TRX2_PL_PWR=$(get_gpiochip_base a0050000)
# axi_gpio_6 hsio_std_pwr
BASE_HSIO_STD_PWR=$(get_gpiochip_base a0060000)
# axi_gpio_7 pl_pb
BASE_PL_PB=$(get_gpiochip_base a0070000)
# axi_gpio_8 click_test_leds
BASE_CLICK_TEST_LEDS=$(get_gpiochip_base a0080000)

# MIO GPIO
BASE_ZYNQMP_GPIO=$(get_gpiochip_base zynqmp_gpio)

MIO13=$(($BASE_ZYNQMP_GPIO+13))
MIO14=$(($BASE_ZYNQMP_GPIO+14))
MIO15=$(($BASE_ZYNQMP_GPIO+15))
MIO16=$(($BASE_ZYNQMP_GPIO+16))
MIO17=$(($BASE_ZYNQMP_GPIO+17))
MIO18=$(($BASE_ZYNQMP_GPIO+18))
MIO19=$(($BASE_ZYNQMP_GPIO+19))
MIO20=$(($BASE_ZYNQMP_GPIO+20))
MIO21=$(($BASE_ZYNQMP_GPIO+21))
MIO22=$(($BASE_ZYNQMP_GPIO+22))
MIO23=$(($BASE_ZYNQMP_GPIO+23))
MIO35=$(($BASE_ZYNQMP_GPIO+35))
MIO36=$(($BASE_ZYNQMP_GPIO+36))
MIO37=$(($BASE_ZYNQMP_GPIO+37))
MIO27=$(($BASE_ZYNQMP_GPIO+27))
MIO28=$(($BASE_ZYNQMP_GPIO+28))
MIO29=$(($BASE_ZYNQMP_GPIO+29))
MIO30=$(($BASE_ZYNQMP_GPIO+30))


STD_LB_LOOP_CNT=14
TRX2_LB_LOOP_CNT=9

# gpiochip452 - axi_gpio_4 - HSIO STD (PL) loopback - address 0xa004_0000
# the first 14 are outputs that are looped back into the next 14
HSIO_STD_LB_BASE_O=$BASE_HSIO_STD_LB
HSIO_STD_LB_BASE_I=$(($BASE_HSIO_STD_LB+$STD_LB_LOOP_CNT))

# gpiochip498 - axi_gpio_2 - HSIO TRX2 (MIO) loopback - address 0xa002_0000
# the first 2 are outputs that are looped back into the next 2
HSIO_TRX2_MIO_LB_BASE_O=$BASE_HSIO_TRX2_MIO_LB
HSIO_TRX2_MIO_LB_BASE_I=$(($BASE_HSIO_TRX2_MIO_LB+2))

# gpiochip480 - axi_gpio_3 - HSIO TRX2 (PL) loopback - address 0xa003_0000
# the first 9 are outputs that are looped back into the next 9
HSIO_TRX2_PL_LB_BASE_O=$BASE_HSIO_TRX2_PL_LB
HSIO_TRX2_PL_LB_BASE_I=$(($BASE_HSIO_TRX2_PL_LB+$TRX2_LB_LOOP_CNT))

ALL_MIO_LB_O=($HSIO_TRX2_MIO_LB_BASE_O $(($HSIO_TRX2_MIO_LB_BASE_O + 1)) $MIO13 $MIO17 $MIO21 $MIO23 $MIO36 $MIO27 $MIO29)
ALL_MIO_LB_I=($HSIO_TRX2_MIO_LB_BASE_I $(($HSIO_TRX2_MIO_LB_BASE_I + 1)) $MIO14 $MIO18 $MIO22 $MIO35 $MIO37 $MIO28 $MIO30)

cd /sys/class/gpio

#
# Export the HSIO_STD elements and set their direction
#
for (( i=0; i<$STD_LB_LOOP_CNT; i++ ))
do
   export_gpio $(($HSIO_STD_LB_BASE_O + $i)) "out" 0
   export_gpio $(($HSIO_STD_LB_BASE_I + $i)) "in"
done

#
# Export the HSIO_TRX2_MIO loopback pairs and set their direction
#
for (( i=0; i<$TRX2_LB_LOOP_CNT; i++ ))
do
      export_gpio ${ALL_MIO_LB_O[($i)]} "out" 0
      export_gpio ${ALL_MIO_LB_I[($i)]} "in"
done

#
# Export the HSIO_TRX2_PL elements and set their direction
#
for (( i=0; i<$TRX2_LB_LOOP_CNT; i++ ))
do
   export_gpio $(($HSIO_TRX2_PL_LB_BASE_O + $i)) "out" 0
   export_gpio $(($HSIO_TRX2_PL_LB_BASE_I + $i)) "in"
done


#
# Main while loop
#
echo "*** Write a '1' to each loopback output"
echo "*** and read it back on the input."
echo "***"

error_count=0

#
# Walking '1's loopback test for HSIO STD I/O
#
echo "*** Walking '1's loopback test for HSIO STD "
for (( i=0; i<$STD_LB_LOOP_CNT; i++ ))
do
   echo 1 > gpio$((HSIO_STD_LB_BASE_O + $i))/value

   if [ $DEBUG -eq 1 ]; then echo -e "\ndebug: writing 1 to output gpio $i (number $((HSIO_STD_LB_BASE_O + $i)))"; fi

   for (( j=0; j<$STD_LB_LOOP_CNT; j++ ))
   do
      read_bit=$(cat gpio$((HSIO_STD_LB_BASE_I + $j))/value) || read_bit=-1

      if [ $DEBUG -eq 1 ]; then echo "debug: reading $read_bit from input gpio $j (number $((HSIO_STD_LB_BASE_I + $j)))"; fi

      if [ $i -eq $j ]
      then
         if [ $read_bit -ne 1 ]
         then
            echo "error: bit $j of HSIO_STD_LB_BASE_I should be set"
            error_count=$((error_count+1))
         fi
      else
         if [ $read_bit -ne 0 ]
         then
            echo "error: bit $j of HSIO_STD_LB_BASE_I should not be set"
            error_count=$((error_count+1))
         fi
      fi
   done

   echo 0 > gpio$((HSIO_STD_LB_BASE_O + $i))/value
done

#
# Walking '1's loopback test for HSIO TRX2 MIO I/O
#
echo "***"
echo "***"
echo "*** Walking '1's loopback test for HSIO TRX2 MIO"
for (( i=0; i<$TRX2_LB_LOOP_CNT; i++ ))
do
   echo 1 > gpio${ALL_MIO_LB_O[($i)]}/value

   if [ $DEBUG -eq 1 ]; then echo -e "\ndebug: writing 1 to output gpio $i (number ${ALL_MIO_LB_O[($i)]})"; fi

   for (( j=0; j<$TRX2_LB_LOOP_CNT; j++ ))
   do
      read_bit=$(cat gpio${ALL_MIO_LB_I[($j)]}/value) || read_bit=-1

      if [ $DEBUG -eq 1 ]; then echo "debug: reading $read_bit from input gpio $j (number ${ALL_MIO_LB_I[($j)]})"; fi

      if [ $i -eq $j ]
      then
         if [ $read_bit -ne 1 ]
         then
            echo "error: bit $j of ALL_MIO_LB_I should be set"
            error_count=$((error_count+1))
         fi
      else
         if [ $read_bit -ne 0 ]
         then
            echo "error: bit $j of ALL_MIO_LB_I should not be set"
            error_count=$((error_count+1))
         fi
      fi
   done

   echo 0 > gpio${ALL_MIO_LB_O[($i)]}/value
done

#
# Walking '1's loopback test for HSIO TRX2 PL I/O
#
echo "***"
echo "***"
echo "*** Walking '1's loopback test for HSIO TRX2 PL"

for (( i=0; i<$TRX2_LB_LOOP_CNT; i++ ))
do
   echo 1 > gpio$((HSIO_TRX2_PL_LB_BASE_O + $i))/value

   if [ $DEBUG -eq 1 ]; then echo -e "\ndebug: writing 1 to output gpio $i (number $((HSIO_TRX2_PL_LB_BASE_O + $i)))"; fi

   for (( j=0; j<$TRX2_LB_LOOP_CNT; j++ ))
   do
      read_bit=$(cat gpio$((HSIO_TRX2_PL_LB_BASE_I + $j))/value) || read_bit=-1

      if [ $DEBUG -eq 1 ]; then echo "debug: reading $read_bit from input gpio $j (number $((HSIO_TRX2_PL_LB_BASE_I + $j)))"; fi

      if [ $i -eq $j ]
      then
         if [ $read_bit -ne 1 ]
         then
            echo "error: bit $j of HSIO_TRX2_PL_LB_BASE_I should be set"
            error_count=$((error_count+1))
         fi
      else
         if [ $read_bit -ne 0 ]
         then
            echo "error: bit $j of HSIO_TRX2_PL_LB_BASE_I should not be set"
            error_count=$((error_count+1))
         fi
      fi
   done

   echo 0 > gpio$((HSIO_TRX2_PL_LB_BASE_O + $i))/value
done


echo "***"
echo "***"


#
# Unexport the loopback I/Os
#
echo "*** Unexporting the sysfs GPIOs..."

for (( i=0; i<$STD_LB_LOOP_CNT; i++ ))
do
   unexport_gpio $(($HSIO_STD_LB_BASE_O + $i))
   unexport_gpio $(($HSIO_STD_LB_BASE_I + $i))
done

for (( i=0; i<$TRX2_LB_LOOP_CNT; i++ ))
do
   unexport_gpio ${ALL_MIO_LB_O[($i)]}
   unexport_gpio ${ALL_MIO_LB_I[($i)]}
done

for (( i=0; i<$TRX2_LB_LOOP_CNT; i++ ))
do
   unexport_gpio $(($HSIO_TRX2_PL_LB_BASE_O + $i))
   unexport_gpio $(($HSIO_TRX2_PL_LB_BASE_I + $i))
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
