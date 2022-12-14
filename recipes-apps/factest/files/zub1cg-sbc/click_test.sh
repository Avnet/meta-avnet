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

test_gpio () {
   gpio_name=$1

   status=0

   gpio_nb=`get_gpio $gpio_name`

   if [ $DEBUG -eq 1 ]; then echo "debug: $gpio_name = gpio$gpio_nb"; fi

   export_gpio $gpio_nb "out" 1
   if [[ $unattended -eq 1 ]]
   then
         echo 1 > gpio$gpio_nb/value
         sleep 1.0
   else
      read -p "Do you confirm gpio $gpio_name is ON [Y/n] " -n 1 -r
      if [[ $REPLY =~ ^[Yy]$ ]]  || [[ -z $REPLY ]]
      then
         echo -e "\n\tyes\n"
      else
         echo -e "\n\tno\n"
         status=1
      fi
   fi

   echo 0 > gpio$gpio_nb/value

   unexport_gpio $gpio_nb
   return $status
}

echo "*** Turn on each LED on the Click Module"
echo "***"

CLICK_TEST_GPIO_NAMES=(`grep ^CLICK_TEST_LED_ $GPIO_CONF | awk -F: '{print $1}'`)

if [ $DEBUG -eq 1 ]; then echo "debug: gpios = ${CLICK_TEST_GPIO_NAMES[@]}"; fi

nb_gpios=${#CLICK_TEST_GPIO_NAMES[@]}

if [ $nb_gpios -ne 11 ]
then
   echo "error: wrong number of retrieved gpios from conf ($nb_gpios, should be 11)"
   exit 1
fi

error_count=0

for gpio_name in ${CLICK_TEST_GPIO_NAMES[@]}; do
   test_gpio $gpio_name || status=$?

   if [ $status -ne 0 ]
   then
         echo "error: turning LED $gpio_name ON"
         error_count=$((error_count+1))
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
