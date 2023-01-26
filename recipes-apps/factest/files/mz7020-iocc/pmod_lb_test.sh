#!/bin/sh -e

DEBUG=0

source /usr/local/bin/gpio/gpio_common.sh

pmod_lb() {
   PMOD=$1
   COUNT=$2
   TEST_BIT=$3
   SYSFS_BASE=BASE_$PMOD
   echo "***"
   echo "*** Walking '${TEST_BIT}'s loopback test for ${PMOD} "
   #echo "*** Loop count is $COUNT"
   echo "*** Pmod $PMOD is at sysfs base ${!SYSFS_BASE}"
   #
   # Fill the PMOD_ARRAY loopback inputs before performing the test
   #
   for (( i=0; i<$COUNT; i++ ))
   do
      PMOD_ARRAY[$i]=$(cat gpio$((${PMOD}_LB_I + $i))/value)
   done

   printf "*** Loopback input is: ${PMOD_ARRAY[*]}\r"
   if [ $DEBUG -eq 1 ]; then printf "\n"; fi

   for (( i=0; i<$COUNT; i++ ))
   do
      if [ $DEBUG -eq 1 ]; then echo -e "DEBUG: Writing $TEST_BIT to output gpio $i (number $((${PMOD}_LB_O + $i)))"; fi
      # write the test bit to the gpio
      echo $TEST_BIT > gpio$((${PMOD}_LB_O + $i))/value

      # for each loop through the loopback loop, this loop runs to read the loopbacked GPIOs
      # we are looking to make sure that only the current bit matches the test bit
      for (( j=0; j<$COUNT; j++ ))
      do
         # read the bit under test
         BIT_UNDER_TEST=$(cat gpio$((${PMOD}_LB_I + $j))/value) || BIT_UNDER_TEST=-1
         if [ $DEBUG -eq 1 ]; then echo "DEBUG: Reading $BIT_UNDER_TEST from input gpio $j (number $((${PMOD}_LB_I + $j)))"; fi

         # add the bit under test ot the array we display
         PMOD_ARRAY[$j]=$BIT_UNDER_TEST

         # when the loop count from the outer loop matches the count from the inner loop
         # check to verify the read bit matches the test bit
         if [ $i -eq $j ]
         then
            if [ $BIT_UNDER_TEST -ne $TEST_BIT ]
            then
               echo "ERROR: bit $j of ${PMOD}_LB_I should be $TEST_BIT"
               error_count=$((error_count+1))
            fi

         # when the loop count from the outer loop does not match match the count from the inner loop
         # check to verify the read bit does not match the test bit
         else
            if [ $BIT_UNDER_TEST -ne $(($TEST_BIT-1)) ]
            then
               echo "ERROR: bit $j of ${PMOD}_LB_I should be $(($TEST_BIT-1))"
               error_count=$((error_count+1))
            fi
         fi
      done

      printf "*** Loopback input is: ${PMOD_ARRAY[*]}\r"
      if [ $DEBUG -eq 1 ]; then printf "\n"; fi

      # invert the current bit under test
      TEST_BIT=$((1 - $TEST_BIT))
      echo $TEST_BIT > gpio$((${PMOD}_LB_O + $i))/value

      # reset the test bit back to original state
      TEST_BIT=$((1 - $TEST_BIT))

      # Sleep for 500ms 
      sleep 0.5
      
   done
   
   # reset the array of loopback inputs to empty it
   PMOD_ARRAY=()

   # add a new line after the last printf
   printf "\n"
}

#
#Base addresses, copied from gpio_map.sh
#
# axi_gpio_0 pmod_ja
BASE_PMOD_JA=$(get_gpiochip_base 41200000)

# axi_gpio_1 pmod_jb
BASE_PMOD_JB=$(get_gpiochip_base 41210000)

# axi_gpio_2 pmod_jc
BASE_PMOD_JC=$(get_gpiochip_base 41220000)

# axi_gpio_3 pmod_jd
BASE_PMOD_JD=$(get_gpiochip_base 41230000)

# axi_gpio_4 pmod_je
BASE_PMOD_JE=$(get_gpiochip_base 41240000)

# axi_gpio_5 pmod_jf
BASE_PMOD_JF=$(get_gpiochip_base 41250000)

# axi_gpio_6 pmod_jg
BASE_PMOD_JG=$(get_gpiochip_base 41260000)

# axi_gpio_7 pmod_jh
BASE_PMOD_JH=$(get_gpiochip_base 41270000)

# axi_gpio_8 pmod_jk
BASE_PMOD_JK=$(get_gpiochip_base 41280000)

# axi_gpio_11 pmod_jy
BASE_PMOD_JY=$(get_gpiochip_base 412b0000)

# axi_gpio_12 pmod_jz
BASE_PMOD_JZ=$(get_gpiochip_base 412c0000)

# MIO GPIO
BASE_ZYNQ_GPIO=$(get_gpiochip_base zynq_gpio)

# PS Pmod D4
MIO0=$(($BASE_ZYNQ_GPIO+0))
# PS Pmod D5
MIO9=$(($BASE_ZYNQ_GPIO+9))
# PS Pmod D1
MIO10=$(($BASE_ZYNQ_GPIO+10))
# PS Pmod D2
MIO11=$(($BASE_ZYNQ_GPIO+11))
# PS Pmod D3
MIO12=$(($BASE_ZYNQ_GPIO+12))
# PS Pmod D0
MIO13=$(($BASE_ZYNQ_GPIO+13))
# PS Pmod D6
MIO14=$(($BASE_ZYNQ_GPIO+14))
# PS Pmod D7
MIO15=$(($BASE_ZYNQ_GPIO+15))

PMOD_LOOP_CNT=4
PMOD_JZ_LOOP_CNT=3

# axi_gpio_0 - Pmod JA (PL) loopback - address 0x4120_0000
# the first 4 are outputs that are looped back into the next 4
PMOD_JA_LB_O=$BASE_PMOD_JA
PMOD_JA_LB_I=$(($BASE_PMOD_JA+$PMOD_LOOP_CNT))

# axi_gpio_1 - Pmod JB (PL) loopback - address 0x4121_0000
# the first 4 are outputs that are looped back into the next 4
PMOD_JB_LB_O=$BASE_PMOD_JB
PMOD_JB_LB_I=$(($BASE_PMOD_JB+$PMOD_LOOP_CNT))

# axi_gpio_2 - Pmod JC (PL) loopback - address 0x4122_0000
# the first 4 are outputs that are looped back into the next 4
PMOD_JC_LB_O=$BASE_PMOD_JC
PMOD_JC_LB_I=$(($BASE_PMOD_JC+$PMOD_LOOP_CNT))

# axi_gpio_3 - Pmod JD (PL) loopback - address 0x4123_0000
# the first 4 are outputs that are looped back into the next 4
PMOD_JD_LB_O=$BASE_PMOD_JD
PMOD_JD_LB_I=$(($BASE_PMOD_JD+$PMOD_LOOP_CNT))

# axi_gpio_4 - Pmod JE (PL) loopback - address 0x4124_0000
# the first 4 are outputs that are looped back into the next 4
PMOD_JE_LB_O=$BASE_PMOD_JE
PMOD_JE_LB_I=$(($BASE_PMOD_JE+$PMOD_LOOP_CNT))

# axi_gpio_5 - Pmod JF (PL) loopback - address 0x4125_0000
# the first 4 are outputs that are looped back into the next 4
PMOD_JF_LB_O=$BASE_PMOD_JF
PMOD_JF_LB_I=$(($BASE_PMOD_JF+$PMOD_LOOP_CNT))

# axi_gpio_6 - Pmod JG (PL) loopback - address 0x4126_0000
# the first 4 are outputs that are looped back into the next 4
PMOD_JG_LB_O=$BASE_PMOD_JG
PMOD_JG_LB_I=$(($BASE_PMOD_JG+$PMOD_LOOP_CNT))

# axi_gpio_7 - Pmod JH (PL) loopback - address 0x4127_0000
# the first 4 are outputs that are looped back into the next 4
PMOD_JH_LB_O=$BASE_PMOD_JH
PMOD_JH_LB_I=$(($BASE_PMOD_JH+$PMOD_LOOP_CNT))

# axi_gpio_8 - Pmod JK (PL) loopback - address 0x4128_0000
# the first 4 are outputs that are looped back into the next 4
PMOD_JK_LB_O=$BASE_PMOD_JK
PMOD_JK_LB_I=$(($BASE_PMOD_JK+$PMOD_LOOP_CNT))

# axi_gpio_11 - Pmod JY (PL) loopback - address 0x412B_0000
# the first 4 are outputs that are looped back into the next 4
PMOD_JY_LB_O=$BASE_PMOD_JY
PMOD_JY_LB_I=$(($BASE_PMOD_JY+$PMOD_LOOP_CNT))

# axi_gpio_12 - Pmod JZ (PL) loopback - address 0x412C_0000
# the first 3 are outputs that are looped back into the next 3
PMOD_JZ_LB_O=$BASE_PMOD_JZ
PMOD_JZ_LB_I=$(($BASE_PMOD_JZ+$PMOD_JZ_LOOP_CNT))

# PS MIO - SOM Pmod J5 loopback
BASE_PMOD_MIO=$BASE_ZYNQ_GPIO
# PMOD_D0 PMOD_D1 PMOD_D2 PMOD_D3
PMOD_MIO_LB_O=($MIO13 $MIO10 $MIO11 $MIO12)
# PMOD_D4 PMOD_D5 PMOD_D6 PMOD_D7
PMOD_MIO_LB_I=($MIO0 $MIO9 $MIO14 $MIO15)

cd /sys/class/gpio

#
# Export the PMOD_J<A-H>, PMOD_JK, PMOD_JY, and PMOD_MIO elements and set their direction
#
for (( i=0; i<$PMOD_LOOP_CNT; i++ ))
do
   export_gpio $(($PMOD_JA_LB_O + $i)) "out" 0
   export_gpio $(($PMOD_JA_LB_I + $i)) "in"

   export_gpio $(($PMOD_JB_LB_O + $i)) "out" 0
   export_gpio $(($PMOD_JB_LB_I + $i)) "in"

   export_gpio $(($PMOD_JC_LB_O + $i)) "out" 0
   export_gpio $(($PMOD_JC_LB_I + $i)) "in"

   export_gpio $(($PMOD_JD_LB_O + $i)) "out" 0
   export_gpio $(($PMOD_JD_LB_I + $i)) "in"

   export_gpio $(($PMOD_JE_LB_O + $i)) "out" 0
   export_gpio $(($PMOD_JE_LB_I + $i)) "in"

   export_gpio $(($PMOD_JF_LB_O + $i)) "out" 0
   export_gpio $(($PMOD_JF_LB_I + $i)) "in"

   export_gpio $(($PMOD_JG_LB_O + $i)) "out" 0
   export_gpio $(($PMOD_JG_LB_I + $i)) "in"

   export_gpio $(($PMOD_JH_LB_O + $i)) "out" 0
   export_gpio $(($PMOD_JH_LB_I + $i)) "in"

   export_gpio $(($PMOD_JK_LB_O + $i)) "out" 0
   export_gpio $(($PMOD_JK_LB_I + $i)) "in"

   export_gpio $(($PMOD_JY_LB_O + $i)) "out" 0
   export_gpio $(($PMOD_JY_LB_I + $i)) "in"
done

#
# Export the PMOD_JZ loopback pairs and set their direction
#
for (( i=0; i<$PMOD_JZ_LOOP_CNT; i++ ))
do
   export_gpio $(($PMOD_JZ_LB_O + $i)) "out" 0
   export_gpio $(($PMOD_JZ_LB_I + $i)) "in"
done

#
# Export the Pmod MIO outputs and set their direction
#
for i in ${!PMOD_MIO_LB_O[@]}
do
   #echo ${PMOD_MIO_LB_O[$i]}
   export_gpio ${PMOD_MIO_LB_O[$i]} "out" 0 
done

#
# Export the Pmod MIO inputs and set their direction
#
for i in ${!PMOD_MIO_LB_I[@]}
do
   #echo ${PMOD_MIO_LB_I[$i]}
   export_gpio ${PMOD_MIO_LB_I[$i]} "in"
done

#
# Main while loop
#
echo "***"
echo "*** Test Pmod GPIO loopback"
echo "*** Write a '1' to each loopback output"
echo "*** and read it back on the input."
echo "***"

error_count=0

#
# Walking '1's loopback tests for Pmod I/O
#
TEST_BIT=1
# PMOD_JA
pmod_lb PMOD_JA $PMOD_LOOP_CNT $TEST_BIT
   
# PMOD_JB
pmod_lb PMOD_JB $PMOD_LOOP_CNT $TEST_BIT

# PMOD_JC
pmod_lb PMOD_JC $PMOD_LOOP_CNT $TEST_BIT

# PMOD_JD
pmod_lb PMOD_JD $PMOD_LOOP_CNT $TEST_BIT

# PMOD_JE
pmod_lb PMOD_JE $PMOD_LOOP_CNT $TEST_BIT

# PMOD_JF
pmod_lb PMOD_JF $PMOD_LOOP_CNT $TEST_BIT

# PMOD_JG
pmod_lb PMOD_JG $PMOD_LOOP_CNT $TEST_BIT

# PMOD_JH
pmod_lb PMOD_JH $PMOD_LOOP_CNT $TEST_BIT

# PMOD_JK
pmod_lb PMOD_JK $PMOD_LOOP_CNT $TEST_BIT

# PMOD_JY
pmod_lb PMOD_JY $PMOD_LOOP_CNT $TEST_BIT

# PMOD_JZ
pmod_lb PMOD_JZ $PMOD_JZ_LOOP_CNT $TEST_BIT

#
# Walking '1's loopback test for PS Pmod MIO I/O
# This is a different process because the PMOD_MIO GPIOs are not sequential
# like the PMOD_J<A-H>, PMOD_JK, PMOD_JY, PMOD_JZ GPIOs are
#
TEST_BIT=1
echo "***"
echo "*** Walking '${TEST_BIT}'s loopback test for PMOD_MIO"
#echo "*** Loop count is $PMOD_LOOP_CNT"
echo "*** Pmod PMOD_MIO is at sysfs base $BASE_PMOD_MIO"
#
# Fill the PMOD_ARRAY loopback inputs before performing the test
#
for (( i=0; i<$PMOD_LOOP_CNT; i++ ))
do
   PMOD_ARRAY[$i]=$(cat gpio${PMOD_MIO_LB_I[$i]}/value)
done

printf "*** Loopback input is: ${PMOD_ARRAY[*]}\r"
if [ $DEBUG -eq 1 ]; then printf "\n"; fi

for (( i=0; i<$PMOD_LOOP_CNT; i++ ))
do
   if [ $DEBUG -eq 1 ]; then echo -e "DEBUG: Writing $TEST_BIT to output gpio $i (number ${PMOD_MIO_LB_O[$i]})"; fi
   # write the test bit to the gpio
   echo $TEST_BIT > gpio${PMOD_MIO_LB_O[$i]}/value

   # for each loop through the loopback loop, this loop runs to read the loopbacked GPIOs
   # we are looking to make sure that only the current bit matches the test bit
   for (( j=0; j<$PMOD_LOOP_CNT; j++ ))
   do
      # read the bit under test
      BIT_UNDER_TEST=$(cat gpio${PMOD_MIO_LB_I[$j]}/value) || BIT_UNDER_TEST=-1
      if [ $DEBUG -eq 1 ]; then echo "DEBUG: Reading $BIT_UNDER_TEST from input gpio $j (number ${PMOD_MIO_LB_I[$j]})"; fi

      # add the bit under test ot the array we display
      PMOD_ARRAY[$j]=$BIT_UNDER_TEST

      # when the loop count from the outer loop matches the count from the inner loop
      # check to verify the read bit matches the test bit
      if [ $i -eq $j ]
      then
         if [ $BIT_UNDER_TEST -ne $TEST_BIT ]
         then
            #~ if [ $error_count -gt 0 ]; then printf "\n"; fi
            echo "ERROR: bit $j of PMOD_MIO_LB_I should be $TEST_BIT"
            error_count=$((error_count+1))
         fi

      # when the loop count from the outer loop does not match match the count from the inner loop
      # check to verify the read bit does not match the test bit
      else
         if [ $BIT_UNDER_TEST -ne $(($TEST_BIT-1)) ]
         then
            #~ if [ $error_count -gt 0 ]; then printf "\n"; fi
            echo "ERROR: bit $j of PMOD_MIO_LB_I should be $(($TEST_BIT-1))"
            error_count=$((error_count+1))
         fi
      fi
   done

   printf "*** Loopback input is: ${PMOD_ARRAY[*]}\r"
   if [ $DEBUG -eq 1 ]; then printf "\n"; fi

   # invert the current bit under test
   TEST_BIT=$((1 - $TEST_BIT))
   echo $TEST_BIT > gpio${PMOD_MIO_LB_O[$i]}/value

   # reset the test bit back to original state
   TEST_BIT=$((1 - $TEST_BIT))

   # Sleep for 500ms 
   sleep 0.5
done

# reset the array of loopback inputs to empty it
PMOD_ARRAY=()

# add a new line after the last printf
printf "\n"

#
# Unexport the loopback I/Os
#
echo "***"
echo "***"
echo "*** Unexporting the sysfs GPIOs..."

for (( i=0; i<$PMOD_LOOP_CNT; i++ ))
do
   unexport_gpio $(($PMOD_JA_LB_O + $i))
   unexport_gpio $(($PMOD_JA_LB_I + $i))
   unexport_gpio $(($PMOD_JB_LB_O + $i))
   unexport_gpio $(($PMOD_JB_LB_I + $i))
   unexport_gpio $(($PMOD_JC_LB_O + $i))
   unexport_gpio $(($PMOD_JC_LB_I + $i))
   unexport_gpio $(($PMOD_JD_LB_O + $i))
   unexport_gpio $(($PMOD_JD_LB_I + $i))
   unexport_gpio $(($PMOD_JE_LB_O + $i))
   unexport_gpio $(($PMOD_JE_LB_I + $i))
   unexport_gpio $(($PMOD_JF_LB_O + $i))
   unexport_gpio $(($PMOD_JF_LB_I + $i))
   unexport_gpio $(($PMOD_JG_LB_O + $i))
   unexport_gpio $(($PMOD_JG_LB_I + $i))
   unexport_gpio $(($PMOD_JH_LB_O + $i))
   unexport_gpio $(($PMOD_JH_LB_I + $i))
   unexport_gpio $(($PMOD_JK_LB_O + $i))
   unexport_gpio $(($PMOD_JK_LB_I + $i))
   unexport_gpio $(($PMOD_JY_LB_O + $i))
   unexport_gpio $(($PMOD_JY_LB_I + $i))
done

for (( i=0; i<$PMOD_JZ_LOOP_CNT; i++ ))
do
   unexport_gpio $(($PMOD_JZ_LB_O + $i))
   unexport_gpio $(($PMOD_JZ_LB_I + $i))
done

for i in ${!PMOD_MIO_LB_O[@]}
do
   #echo ${PMOD_MIO_LB_O[$i]}
   unexport_gpio ${PMOD_MIO_LB_O[$i]}
done

for i in ${!PMOD_MIO_LB_I[@]}
do
   #echo ${PMOD_MIO_LB_I[$i]}
   unexport_gpio ${PMOD_MIO_LB_I[$i]}
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
