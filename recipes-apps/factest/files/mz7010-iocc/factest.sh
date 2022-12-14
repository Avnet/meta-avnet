#!/bin/bash

FACTEST_SCRIPTS_DIR=/home/root/factest_scripts

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
    printf "${!1}${2} ${NC}" # <-- bash
}

execute_script_test () {
   desc=$1
   script=$2

   cecho "CYAN" "\n--------- $desc ---------\n"
   /bin/sh $script
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
   echo " "
   echo "******************************************************************"
   echo "***                                                            ***"
   echo "***        MicroZed 7010 Factory Test V2.0 Complete            ***"
   echo "***                                                            ***"

   printf "*** GPIO LEDs and Switches Test: "
   if [ $BUTTONS_AND_LEDS_RESULT -eq 0 ]; then cecho "GREEN" "PASS"; else cecho "RED" "FAIL"; fi
   printf "                         ***\n"

   printf "*** Pmod Loopback Test: "
   if [ $PMOD_LB_RESULT -eq 0 ]; then cecho "GREEN" "PASS"; else cecho "RED" "FAIL"; fi
   printf "                                  ***\n"
   
   printf "*** Zynq SysMon Test: "
   if [ $SYSMON_RESULT -eq 0 ]; then cecho "GREEN" "PASS"; else cecho "RED" "FAIL"; fi
   printf "                                    ***\n"
   
   printf "*** Ethernet Ping Test: "
   if [ $ETHERNET_RESULT -eq 0 ]; then cecho "GREEN" "PASS"; else cecho "RED" "FAIL"; fi
   printf "                                  ***\n"
   
   printf "*** USB Device File Write & Read Test: "
   if [ $USB_RESULT -eq 0 ]; then cecho "GREEN" "PASS"; else cecho "RED" "FAIL"; fi
   printf "                   ***\n"

   echo "***                                                            ***"
   printf "*** "
   cecho "YELLOW" "--- RESULTS SUMMARY ---"
   printf "                                   ***\n"
   printf "*** "
   cecho "CYAN" "Ran: $nb_test tests, "
   cecho "GREEN" "Passed: $nb_passed tests, "
   cecho "RED" "Failed: $nb_failed tests"
   printf "          ***\n"
   echo "***                                                            ***"
   echo "******************************************************************"
   echo " "
}

{
   execute_script_test "Test Buttons and LEDs" $FACTEST_SCRIPTS_DIR/buttons_and_leds_test.sh
   BUTTONS_AND_LEDS_RESULT=$?
   
   execute_script_test "Test Pmod interfaces" $FACTEST_SCRIPTS_DIR/pmod_lb_test.sh
   PMOD_LB_RESULT=$?
   
   execute_script_test "Test SYSMON" $FACTEST_SCRIPTS_DIR/sysmon_test.sh
   SYSMON_RESULT=$?
   
   execute_script_test "Test Ethernet Interface" $FACTEST_SCRIPTS_DIR/ethernet_test.sh
   ETHERNET_RESULT=$?
   
   execute_script_test "Test USB Interface" $FACTEST_SCRIPTS_DIR/usb_test.sh
   USB_RESULT=$?

   print_results
}

sync

