#!/bin/sh -e

DEBUG=0

error_count=0

echo "*** Verify i2c Mux probed properly"
echo "***"

I2C_MUX_CHANNELS=4
status=0
nb_channels=$(i2cdetect -l  2>/dev/null | grep i2c-0-mux | wc -l)

if [ $nb_channels -ne $I2C_MUX_CHANNELS ]
then
      echo "error: incorrect number of i2c Mux channels (detected: $nb_channels, should be 4)"
      error_count=$((error_count+1))
else
   echo -e "\ni2c Mux has 4 channels\n"
fi

echo -e  "\n***"

echo "*** Scan i2c buses"
echo "***"

for i in $(seq 0 $I2C_MUX_CHANNELS); do
   status=0
   i2cdetect -r -y 0 > /dev/null 2>&1  || status=$?

   if [ $status -ne 0 ]
   then
         echo "error: scanning i2c bus $i"
         error_count=$((error_count+1))
   else
      echo -e "\nScan on bus $i successful"
   fi
done

echo -e  "\n***"

echo "*** Done."
echo "*** Number of errors = $error_count"
echo "***"

if [ $error_count -ne 0 ]
then
   exit 1
fi

exit
