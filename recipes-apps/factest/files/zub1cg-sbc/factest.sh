#!/bin/sh

FACTEST_SCRIPTS_DIR=/home/root/factest_scripts

nb_passed=0
nb_failed=0

execute_script_test () {
   desc=$1
   script=$2

   echo -e "\n--------- $desc ---------\n"
   /bin/sh $script
   status=$?

   if [ $status -ne 0 ]
   then
      nb_failed=$((nb_failed+1))
      echo -e "\n--------- $desc - FAIL ---------"
   else
      nb_passed=$((nb_passed+1))
      echo -e "\n--------- $desc - PASS ---------"
   fi

   return $status
}

print_results () {
   nb_test=$((nb_passed + nb_failed))
      echo -e "\n\n-----------------------------------"
      echo -e "------------- RESULTS -------------"
      echo -e " Ran:    $nb_test tests"
      echo -e " Passed: $nb_passed tests"
      echo -e " Failed: $nb_failed tests"
      echo -e "-----------------------------------\n"
}

execute_script_test "Test Buttons and LEDs" $FACTEST_SCRIPTS_DIR/buttons_and_leds_test.sh
execute_script_test "Test Click Module interface" $FACTEST_SCRIPTS_DIR/click_test.sh
execute_script_test "Test SyZyGY interfaces" $FACTEST_SCRIPTS_DIR/szg_lb_test.sh
execute_script_test "Test Internal Sensors" $FACTEST_SCRIPTS_DIR/internal_sensors_test.sh
execute_script_test "Test SYSMON" $FACTEST_SCRIPTS_DIR/sysmon_test.sh
execute_script_test "Test Ethernet Interface" $FACTEST_SCRIPTS_DIR/ethernet_test.sh
execute_script_test "Test USB Interface" $FACTEST_SCRIPTS_DIR/usb_test.sh
execute_script_test "Test RTC" $FACTEST_SCRIPTS_DIR/rtc_test.sh


print_results
