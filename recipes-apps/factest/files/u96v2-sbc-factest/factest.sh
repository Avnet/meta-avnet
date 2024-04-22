#!/bin/bash

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

FACTEST_SCRIPTS_DIR=/home/root/factest_scripts
LOCAL_RESULTS_FILE=/home/root/last_factest_results.log

# In unattended mode we don't write the results to local file system
# to prevent prevent this from filling up the disk
if [[ $unattended -eq 1 ]]
then
   LOCAL_RESULTS_FILE=/dev/null
fi

nb_passed=0
nb_failed=0

cecho(){
    RED="\033[0;31m"
    GREEN="\033[0;32m"  # <-- [0 means not bold
    YELLOW="\033[1;33m" # <-- [1 means bold
    CYAN="\033[1;36m"
    # ... Add more colors if you like

    NC="\033[0m" # No Color

    # printf "${(P)1}${2} ${NC}\n" # <-- zsh
    printf "${!1}${2} ${NC}\n" # <-- bash
}
execute_command_test () {
   desc=$1
   command=$2

   cecho "CYAN" "\n--------- $desc ---------\n"
   $command
   status=$?

   if [ $status -ne 0 ]
   then
      nb_failed=$((nb_failed+1))
      cecho "RED" "\n--------- $desc - FAIL ---------"
   else
      nb_passed=$((nb_passed+1))
      cecho "GREEN" "\n--------- $desc - PASS ---------"
   fi

   return $status
}

execute_script_test () {
   desc=$1
   script=$2

   cecho "CYAN" "\n--------- $desc ---------\n"
   if [[ $unattended -eq 1 ]]
   then
      /bin/sh $script -u
   else
      /bin/sh $script
   fi

   status=$?

   if [ $status -ne 0 ]
   then
      nb_failed=$((nb_failed+1))
      cecho "RED" "\n--------- $desc - FAIL ---------"
   else
      nb_passed=$((nb_passed+1))
      cecho "GREEN" "\n--------- $desc - PASS ---------"
   fi

   return $status
}

print_results () {
   nb_test=$((nb_passed + nb_failed))
      echo -e "\n\n-----------------------------------"
      echo -e "------------- RESULTS -------------"
      cecho "CYAN" " Ran:    $nb_test tests"
      cecho "GREEN" " Passed: $nb_passed tests"
      cecho "RED" " Failed: $nb_failed tests"
      echo -e "-----------------------------------\n"
}


{
   execute_script_test "Test Buttons and LEDs" $FACTEST_SCRIPTS_DIR/buttons_and_leds_test.sh
   execute_script_test "Test Loopback GPIOs" $FACTEST_SCRIPTS_DIR/loopback_gpios_test.sh
   execute_script_test "Test SD interface" $FACTEST_SCRIPTS_DIR/sd_test.sh
   execute_script_test "Test Display Port interface" $FACTEST_SCRIPTS_DIR/dp_test.sh
   execute_script_test "Test USB Host interface" $FACTEST_SCRIPTS_DIR/usb_host_test.sh
   execute_script_test "Test USB Device interface" $FACTEST_SCRIPTS_DIR/usb_device_test.sh
   execute_script_test "Test Sensors" $FACTEST_SCRIPTS_DIR/sensors_test.sh
   execute_script_test "Test WiFi" $FACTEST_SCRIPTS_DIR/wifi_test.sh
   execute_script_test "Test Bluetooth" $FACTEST_SCRIPTS_DIR/bt_test.sh

   print_results
} > >(tee "$LOCAL_RESULTS_FILE") 2>&1

sync

