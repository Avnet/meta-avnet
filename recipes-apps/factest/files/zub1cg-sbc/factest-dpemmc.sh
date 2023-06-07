#!/bin/bash

# Check if there are any switches such unattended mode
unattended=0

if [[ $# -gt 0 ]]
then
      for var in "$@"
      do
         if [[ $var -eq "-u" ]]
         then
            echo -e "No unattended mode for DP-EMMC factory tests \n"
            exit 1
         fi
      done
fi

FACTEST_SCRIPTS_DIR=/home/root/factest_scripts
LOCAL_RESULTS_FILE=/home/root/last_factest_results.log
LOCAL_RESULTS_FILE_HTML=/home/root/last_factest_results.html

# In unattended mode we don't write the results to local file system
# to prevent prevent this from filling up the disk
if [[ $unattended -eq 1 ]]
then
   LOCAL_RESULTS_FILE=/dev/null
fi

source $FACTEST_SCRIPTS_DIR/qspi_utils.sh

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
      $script -u
   else
      $script
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
   if [[ $unattended -eq 1 ]]
   then
      # In unattended mode, we don't write the results to the QSPI
      cecho "CYAN" "\n--------- Running test suite in unattended mode ---------\n"
   else
      QSPI_STATUS=0
      execute_command_test "QSPI TEST (check user partition)" "qspi_check_user_part"
      if [[ $? -ne 0 ]]
      then
         QSPI_STATUS=1
      fi
   fi


   execute_script_test "Test EMMC" $FACTEST_SCRIPTS_DIR/emmc.sh
   execute_script_test "Test Display Port Interface" $FACTEST_SCRIPTS_DIR/dp.sh

   print_results
} > >(tee "$LOCAL_RESULTS_FILE") 2>&1

sync

# Only copy the results to the QSPI if test is running in unattended mode
if [[ $unattended -eq 0 ]]
then
   if [[ $QSPI_STATUS -eq 0 ]]
   then
      echo "Copying Test Results to QSPI"
      cat $LOCAL_RESULTS_FILE | ansi2html > $LOCAL_RESULTS_FILE_HTML
      copy_log_file_to_qspi $LOCAL_RESULTS_FILE_HTML
   else
      echo "QSPI TEST Failed, log file can be found on the sd card: $LOCAL_RESULTS_FILE"
   fi
fi
