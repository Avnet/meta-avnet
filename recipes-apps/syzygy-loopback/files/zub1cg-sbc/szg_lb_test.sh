#!/bin/sh

# gpiochip269 - MIO GPIO - address 0xff0a_0000
MIO_BASE=269
PS_PB_SW=$(($MIO_BASE+32))
MIO13=$(($MIO_BASE+13))
MIO14=$(($MIO_BASE+14))
MIO15=$(($MIO_BASE+15))
MIO16=$(($MIO_BASE+16))
MIO17=$(($MIO_BASE+17))
MIO18=$(($MIO_BASE+18))
MIO19=$(($MIO_BASE+19))
MIO20=$(($MIO_BASE+20))
MIO21=$(($MIO_BASE+21))
MIO22=$(($MIO_BASE+22))
MIO23=$(($MIO_BASE+23))
MIO35=$(($MIO_BASE+35))
MIO36=$(($MIO_BASE+36))
MIO37=$(($MIO_BASE+37))
MIO27=$(($MIO_BASE+27))
MIO28=$(($MIO_BASE+28))
MIO29=$(($MIO_BASE+29))
MIO30=$(($MIO_BASE+30))

ALL_MIO_LB_O=($MIO13 $MIO17 $MIO21 $MIO23 $MIO36 $MIO27 $MIO29)
ALL_MIO_LB_I=($MIO14 $MIO18 $MIO22 $MIO35 $MIO37 $MIO28 $MIO30)

# gpiochip443 - axi_gpio_7 - address 0xa007_0000 - PCB SW3
PL_PB_SW=443

# gpiochip452 - axi_gpio_4 - Syzygy STD (PL) loopback - address 0xa004_0000
# the first 14 are outputs that are looped back into the next 14
SZG_STD_LB_BASE_O=452
SZG_STD_LB_BASE_I=466

# gpiochip498 - axi_gpio_2 - Syzygy TRX2 (MIO) loopback - address 0xa002_0000
# the first 2 are outputs that are looped back into the next 2
SZG_TRX2_MIO_LB_BASE_O=498
SZG_TRX2_MIO_LB_BASE_I=500

# gpiochip480 - axi_gpio_3 - Syzygy TRX2 (PL) loopback - address 0xa003_0000
# the first 9 are outputs that are looped back into the next 9
SZG_TRX2_PL_LB_BASE_O=480
SZG_TRX2_PL_LB_BASE_I=489

cd /sys/class/gpio

#
# Export the PS PB switch and set the direction
#
echo $PS_PB_SW > export
echo in > gpio$PS_PB_SW/direction

#
# Export the PL PB switch and set the direction
#
echo $PL_PB_SW > export
echo in > gpio$PL_PB_SW/direction

STD_LB_LOOP_CNT=14
TRX2_LB_LOOP_CNT=9

#
# Export the SZG_STD elements and set their direction
#
for (( i=0; i<$STD_LB_LOOP_CNT; i++ ))
do
   echo $(($SZG_STD_LB_BASE_O + $i)) > export
   echo $(($SZG_STD_LB_BASE_I + $i)) > export

   echo out > gpio$(($SZG_STD_LB_BASE_O + $i))/direction
   echo in > gpio$(($SZG_STD_LB_BASE_I + $i))/direction
done

#
# Export the SZG_TRX2_MIO loopback pairs and set their direction
#
for (( i=0; i<$TRX2_LB_LOOP_CNT; i++ ))
do
   if [[ $i -lt 2 ]] 
   then
      echo $(($SZG_TRX2_MIO_LB_BASE_O + $i)) > export
      echo $(($SZG_TRX2_MIO_LB_BASE_I + $i)) > export
   
      echo out > gpio$(($SZG_TRX2_MIO_LB_BASE_O + $i))/direction
      echo in > gpio$(($SZG_TRX2_MIO_LB_BASE_I + $i))/direction
   else
      echo ${ALL_MIO_LB_O[($i-2)]} > export
      echo ${ALL_MIO_LB_I[($i-2)]} > export
   
      echo out > gpio${ALL_MIO_LB_O[($i-2)]}/direction
      echo in > gpio${ALL_MIO_LB_I[($i-2)]}/direction
   fi
done

#
# Export the SZG_TRX2_PL elements and set their direction
#
for (( i=0; i<$TRX2_LB_LOOP_CNT; i++ ))
do
   echo $(($SZG_TRX2_PL_LB_BASE_O + $i)) > export
   echo $(($SZG_TRX2_PL_LB_BASE_I + $i)) > export

   echo out > gpio$(($SZG_TRX2_PL_LB_BASE_O + $i))/direction
   echo in > gpio$(($SZG_TRX2_PL_LB_BASE_I + $i))/direction
done

TEST_BIT=1
WAIT_FOR_START=1
WAIT_FOR_STOP=1

echo "***"
echo "***"
echo "*** Press PS PB switch (SW1 - MIO_PB) to START"
echo "*** Press PL PB switch (SW3 - PL_PB) to STOP"
echo "***"
echo "***"

# Stay in this loop until the PS PB switch is pressed
# The switch is active low (pressed = '0')
#~ while [ $WAIT_FOR_START -eq 1 ]
#~ do
   #~ WAIT_FOR_START=$(cat gpio$PS_PB_SW/value)
#~ done

#
# Fill the STD_ARRAY before performing the tests
#
for (( i=0; i<$STD_LB_LOOP_CNT; i++ ))
do
   STD_ARRAY[$i]=$(cat gpio$((SZG_STD_LB_BASE_I + $i))/value)
done
#echo "*** Loopback input is: ${STD_ARRAY[*]}"

#
# Fill the TRX2_MIO_ARRAY before performing the tests
#
for (( i=0; i<$TRX2_LB_LOOP_CNT; i++ ))
do
   if [[ $i -lt 2 ]] 
   then
      TRX2_MIO_ARRAY[$i]=$(cat gpio$((SZG_TRX2_MIO_LB_BASE_I + $i))/value)
   else
      TRX2_MIO_ARRAY[$i]=$(cat gpio${ALL_MIO_LB_I[($i-2)]}/value)
   fi
done
#echo "*** Loopback input is: ${TRX2_MIO_ARRAY[*]}"

#
# Fill the TRX2_PL_ARRAY before performing the tests
#
for (( i=0; i<$TRX2_LB_LOOP_CNT; i++ ))
do
   TRX2_PL_ARRAY[$i]=$(cat gpio$((SZG_TRX2_PL_LB_BASE_I + $i))/value)
done
#echo "*** Loopback input is: ${TRX2_PL_ARRAY[*]}"


#
# Main while loop
#
echo "*** Write a '1' to each loopback output"
echo "*** and read it back on the input."
echo "***"

# Stay in this loop until the PL PB switch is pressed for at least 500ms
# The switch is active low (pressed = '0')
while [[ $WAIT_FOR_STOP -eq 1 ]]
do
   WAIT_FOR_STOP=$(cat gpio$PL_PB_SW/value)

   #
   # Walking '1's loopback test for SYZYGY STD I/O
   #
   echo "*** Walking '1's loopback test for SYZYGY STD "
   for (( i=0; i<$STD_LB_LOOP_CNT; i++ ))
   do
      echo $TEST_BIT > gpio$((SZG_STD_LB_BASE_O + $i))/value
      
      STD_ARRAY[$i]=$(cat gpio$((SZG_STD_LB_BASE_I + $i))/value)
      READ_BIT=$(cat gpio$((SZG_STD_LB_BASE_I + $i))/value)

      printf "*** Loopback input is: ${STD_ARRAY[*]}\r"
      
      if [[ $i -eq 0 ]] 
      then
         echo 0 > gpio$((SZG_STD_LB_BASE_O + ($i+($STD_LB_LOOP_CNT-1))))/value
         STD_ARRAY[$i+($STD_LB_LOOP_CNT-1)]=$(cat gpio$((SZG_STD_LB_BASE_I + ($i+($STD_LB_LOOP_CNT-1))))/value)
      else
         echo 0 > gpio$((SZG_STD_LB_BASE_O + ($i-1)))/value
         STD_ARRAY[$i-1]=$(cat gpio$((SZG_STD_LB_BASE_I + ($i-1)))/value)
      fi

      printf "*** Loopback input is: ${STD_ARRAY[*]}\r"

      # If the stop PB switch is pressed exit the for loop gracefully
      WAIT_FOR_STOP=$(cat gpio$PL_PB_SW/value)
      if [[ $WAIT_FOR_STOP -eq 0 ]] 
      then
         # Reset the GPIO under test back to '0'
         echo ""
         echo "***"
         echo "*** Stop button pressed."
         echo "*** Resetting the GPIO under test back to '0'."
         echo 0 > gpio$((SZG_STD_LB_BASE_O + $i))/value
         STD_ARRAY[$i]=$(cat gpio$((SZG_STD_LB_BASE_I + $i))/value)
         #printf "*** Loopback input is: ${STD_ARRAY[*]}\r"
         echo "***"
         # Force the loop count to the exit condition
         i=$STD_LB_LOOP_CNT
      fi

      if [[ $TEST_BIT -ne $READ_BIT ]]
      then
         echo ""
         echo "*** ERROR!  Write bit does not match read bit!  Loopback test FAIL!"
         echo "***"
         # Force the loop count push button press to the exit condition
         i=$STD_LB_LOOP_CNT
         WAIT_FOR_STOP=0
      fi

      # Sleep for 500ms 
      sleep 0.5

   done








   #
   # Walking '1's loopback test for SYZYGY TRX2 MIO I/O
   #
   echo "***"
   echo "***"
   echo "*** Walking '1's loopback test for SYZYGY TRX2 MIO"
   for (( i=0; i<$TRX2_LB_LOOP_CNT; i++ ))
   do
      if [[ $i -lt 2 ]] 
      then
         echo $TEST_BIT > gpio$((SZG_TRX2_MIO_LB_BASE_O + $i))/value
         
         TRX2_MIO_ARRAY[$i]=$(cat gpio$((SZG_TRX2_MIO_LB_BASE_I + $i))/value)
         READ_BIT=$(cat gpio$((SZG_TRX2_MIO_LB_BASE_I + $i))/value)
      else
         echo $TEST_BIT > gpio${ALL_MIO_LB_O[($i-2)]}/value
         
         TRX2_MIO_ARRAY[$i]=$(cat gpio${ALL_MIO_LB_I[($i-2)]}/value)
         READ_BIT=$(cat gpio${ALL_MIO_LB_I[($i-2)]}/value)
         
      fi

      printf "*** Loopback input is: ${TRX2_MIO_ARRAY[*]}\r"
      
      if [[ $i -eq 0 ]] 
      then
         echo 0 > gpio${ALL_MIO_LB_O[($i+($TRX2_LB_LOOP_CNT-3))]}/value
         TRX2_MIO_ARRAY[$i+($TRX2_LB_LOOP_CNT-1)]=$(cat gpio${ALL_MIO_LB_I[($i+($TRX2_LB_LOOP_CNT-3))]}/value)
         #printf "*** Loopback input is: ${TRX2_MIO_ARRAY[*]}\r"
      fi
      
      if [[ $i -eq 1 ]] 
      then
         echo 0 > gpio$((SZG_TRX2_MIO_LB_BASE_O + ($i-1)))/value
         TRX2_MIO_ARRAY[$i-1]=$(cat gpio$((SZG_TRX2_MIO_LB_BASE_I + ($i-1)))/value)
         #printf "*** Loopback input is: ${TRX2_MIO_ARRAY[*]}\r"
      fi

      if [[ $i -gt 1 ]] 
      then
         #echo $((1-TOGGLE)) > gpio$((SZG_TRX2_MIO_LB_BASE_O + ($i-1)))/value
         echo 0 > gpio${ALL_MIO_LB_O[($i-3)]}/value
         TRX2_MIO_ARRAY[$i-1]=$(cat gpio${ALL_MIO_LB_I[($i-3)]}/value)
         #printf "*** Loopback input is: ${TRX2_MIO_ARRAY[*]}\r"
      fi

      printf "*** Loopback input is: ${TRX2_MIO_ARRAY[*]}\r"

      # If the stop PB switch is pressed exit the for loop gracefully
      WAIT_FOR_STOP=$(cat gpio$PL_PB_SW/value)
      if [[ $WAIT_FOR_STOP -eq 0 ]] 
      then
         # Reset the GPIO under test back to '0'
         echo ""
         echo "***"
         echo "*** Stop button pressed."
         echo "*** Resetting the GPIO under test back to '0'."
         echo "***"

         if [[ $i -lt 2 ]] 
         then
            echo 0 > gpio$((SZG_TRX2_MIO_LB_BASE_O + $i))/value
            TRX2_MIO_ARRAY[$i]=$(cat gpio$((SZG_TRX2_MIO_LB_BASE_I + $i))/value)
         else
            echo 0 > gpio${ALL_MIO_LB_O[($i-2)]}/value
            TRX2_MIO_ARRAY[$i]=$(cat gpio${ALL_MIO_LB_I[($i-2)]}/value)
         fi
         
         #printf "*** Loopback input is: ${TRX2_MIO_ARRAY[*]}\r"
         echo "***"
         # Force the loop count to the exit condition
         i=$TRX2_LB_LOOP_CNT
      fi

      if [[ $TEST_BIT -ne $READ_BIT ]]
      then
         echo ""
         echo "***"
         echo "*** ERROR!  Write bit does not match read bit!  Loopback test FAIL!"
         echo "***"
         # Force the loop count and push button press to the exit condition
         i=$TRX2_LB_LOOP_CNT
         WAIT_FOR_STOP=0
      fi

      # Sleep for 500ms 
      sleep 0.5

   done











   #
   # Walking '1's loopback test for SYZYGY TRX2 PL I/O
   #
   echo "***"
   echo "***"
   echo "*** Walking '1's loopback test for SYZYGY TRX2 PL"
   for (( i=0; i<$TRX2_LB_LOOP_CNT; i++ ))
   do
      echo $TEST_BIT > gpio$((SZG_TRX2_PL_LB_BASE_O + $i))/value
      
      TRX2_PL_ARRAY[$i]=$(cat gpio$((SZG_TRX2_PL_LB_BASE_I + $i))/value)
      READ_BIT=$(cat gpio$((SZG_TRX2_PL_LB_BASE_I + $i))/value)

      printf "*** Loopback input is: ${TRX2_PL_ARRAY[*]}\r"
      
      if [[ $i -eq 0 ]] 
      then
         echo 0 > gpio$((SZG_TRX2_PL_LB_BASE_O + ($i+($TRX2_LB_LOOP_CNT-1))))/value
         TRX2_PL_ARRAY[$i+($TRX2_LB_LOOP_CNT-1)]=$(cat gpio$((SZG_TRX2_PL_LB_BASE_I + ($i+($TRX2_LB_LOOP_CNT-1))))/value)
      else
         echo 0 > gpio$((SZG_TRX2_PL_LB_BASE_O + ($i-1)))/value
         TRX2_PL_ARRAY[$i-1]=$(cat gpio$((SZG_TRX2_PL_LB_BASE_I + ($i-1)))/value)
      fi

      printf "*** Loopback input is: ${TRX2_PL_ARRAY[*]}\r"

      # If the stop PB switch is pressed exit the for loop gracefully
      WAIT_FOR_STOP=$(cat gpio$PL_PB_SW/value)
      if [[ $WAIT_FOR_STOP -eq 0 ]] 
      then
         # Reset the GPIO under test back to '0'
         echo ""
         echo "***"
         echo "*** Stop button pressed."
         echo "*** Resetting the GPIO under test back to '0'."
         echo "***"
         echo 0 > gpio$((SZG_TRX2_PL_LB_BASE_O + $i))/value
         TRX2_PL_ARRAY[$i]=$(cat gpio$((SZG_TRX2_PL_LB_BASE_I + $i))/value)
         #printf "*** Loopback input is: ${TRX2_PL_ARRAY[*]}\r"
         echo "***"
         # Force the loop count to the exit condition
         i=$TRX2_LB_LOOP_CNT
      fi

      if [[ $TEST_BIT -ne $READ_BIT ]]
      then
         echo ""
         echo "*** ERROR!  Write bit does not match read bit!  Loopback test FAIL!"
         echo "***"
         # Force the loop count and push button press to the exit condition
         i=$TRX2_LB_LOOP_CNT
         WAIT_FOR_STOP=0
      fi

      # Sleep for 500ms 
      sleep 0.5

   done
   echo "***"
   echo "***"












   WAIT_FOR_STOP=0

done

#
# Write a couple of blank lines
#
echo "***"
echo "*** Exiting gracefully..."

#
# Return the loopback I/Os to their default state ('0')
#
echo "*** Returning the loopback I/Os to their default state ('0')..."
for (( i=0; i<$STD_LB_LOOP_CNT; i++ ))
do
   echo 0 > gpio$((SZG_STD_LB_BASE_O + $i))/value
done

for (( i=0; i<$TRX2_LB_LOOP_CNT; i++ ))
do
   if [[ $i -lt 2 ]] 
   then
      echo 0 > gpio$((SZG_TRX2_MIO_LB_BASE_O + $i))/value
   else
      echo 0 > gpio${ALL_MIO_LB_O[($i-2)]}/value
   fi
done

for (( i=0; i<$TRX2_LB_LOOP_CNT; i++ ))
do
      echo 0 > gpio$((SZG_TRX2_PL_LB_BASE_O + $i))/value
done


#
# Unexport the loopback I/Os
#
echo "*** Unexporting the sysfs GPIOs..."
for (( i=0; i<$STD_LB_LOOP_CNT; i++ ))
do
   echo $(($SZG_STD_LB_BASE_O + $i)) > unexport
   echo $(($SZG_STD_LB_BASE_I + $i)) > unexport
done

for (( i=0; i<$TRX2_LB_LOOP_CNT; i++ ))
do
   if [[ $i -lt 2 ]] 
   then
      echo $(($SZG_TRX2_MIO_LB_BASE_O + $i)) > unexport
      echo $(($SZG_TRX2_MIO_LB_BASE_I + $i)) > unexport
   else
      echo ${ALL_MIO_LB_O[($i-2)]} > unexport
      echo ${ALL_MIO_LB_I[($i-2)]} > unexport
   fi
done

for (( i=0; i<$TRX2_LB_LOOP_CNT; i++ ))
do
   echo $(($SZG_TRX2_PL_LB_BASE_O + $i)) > unexport
   echo $(($SZG_TRX2_PL_LB_BASE_I + $i)) > unexport
done

#
# Unexport the PS PB switch GPIO 
#
echo $PS_PB_SW > unexport

#
# Export the PL PB switch GPIO
#
echo $PL_PB_SW > unexport

echo "***"
echo "*** Done."
echo "***"

exit


