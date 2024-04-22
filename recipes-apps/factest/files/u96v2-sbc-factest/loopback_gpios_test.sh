#!/bin/sh -e

DEBUG=0

source /usr/local/bin/gpio/gpio_common.sh

cd /sys/class/gpio

error_count=0

echo "*** TEST GPIO LOOPBACK"
echo "***"

process_each_loopback_gpio() {
   INDEX=$1
   status=0

   gpio_out_nb=`get_gpio LOOPBACK_GPIO_OUT_$INDEX` || status=$?
   if [ $status -ne 0 ] || [ -z "${gpio_out_nb}" ]
   then
         echo "error: failed getting gpio number for LOOPBACK_GPIO_OUT_$INDEX"
         return 1
   fi
   
   gpio_in_nb=`get_gpio LOOPBACK_GPIO_IN_$INDEX` || status=$?
   if [ $status -ne 0 ] || [ -z "${gpio_in_nb}" ]
   then
         echo "error: failed getting gpio number for LOOPBACK_GPIO_IN_$INDEX"
         return 1
   fi

   # unexport in case it was left exported previously
   unexport_gpio $gpio_out_nb > /dev/null 2>&1 || true
   unexport_gpio $gpio_in_nb > /dev/null 2>&1 || true


   export_gpio $gpio_out_nb "out" 0 || status=$?
   if [ $status -ne 0 ]
   then
         echo "error: failed exporting $gpio_out_nb"
         return 1
   fi

   export_gpio $gpio_in_nb "in" || status=$?
   if [ $status -ne 0 ]
   then
         echo "error: failed exporting $gpio_out_nb"
         return 1
   fi

   echo 1 > gpio$gpio_out_nb/value

   if [ `cat gpio$gpio_in_nb/value` -ne 1 ]
   then
      echo "ERROR: loopback failed between output gpio $gpio_out_nb and input gpio $gpio_in_nb"
      return 1
   fi

   echo 0 > gpio$gpio_out_nb/value

   if [ `cat gpio$gpio_in_nb/value` -ne 0 ]
   then
      echo "ERROR: loopback failed between output gpio $gpio_out_nb and input gpio $gpio_in_nb"
      return 1
   fi

   unexport_gpio $gpio_out_nb > /dev/null 2>&1
   unexport_gpio $gpio_in_nb > /dev/null 2>&1

   return 0;
}

status=0

for i in $(seq 0 20); do

   process_each_loopback_gpio $i || status=$?
   if [ $status -ne 0 ]
   then
      echo -e "\n Testing GPIO Loopback index $i: FAILED"
      error_count=$((error_count+1))
   else
      echo -e "\n Testing GPIO Loopback index $i: PASSED"
   fi
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

