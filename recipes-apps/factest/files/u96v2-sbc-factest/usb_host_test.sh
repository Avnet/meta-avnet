#!/bin/sh -e

DEBUG=0

error_count=0

echo "*** Detect USB keys"
echo "***"

status=0
USB_MOUNT_POINTS=(`df | grep ^/dev/sd  | awk  '{print $6}'`)

if [ $DEBUG -eq 1 ]; then echo "debug: USB_MOUNT_POINTS = ${USB_MOUNT_POINTS[@]}"; fi

nb_points=${#USB_MOUNT_POINTS[@]}

if [ $nb_points -ne 2 ]
then
   echo "error: incorrect number of detected USB keys from df command (= $nb_points, should be 2)"
   exit 1
fi

echo -e "\nPassed (2 USB keys)\n"

echo "***"

usb_read_write_test () {
   USB_NB=$1
   return_code=0

   USB_DIR=${USB_MOUNT_POINTS[USB_NB]}

   TEST_FILE=$USB_DIR/test_file.txt
   TEST_VALUE="This is a Test"

   # remove file if existing
   rm $TEST_FILE > /dev/null 2>&1 || true

   if [ $DEBUG -eq 1 ]; then echo "debug: writing '$TEST_VALUE' to test file ($TEST_FILE)"; fi
   echo $TEST_VALUE > $TEST_FILE

   sync

   if [ $DEBUG -eq 1 ]; then echo "debug: reading '$(cat $TEST_FILE)'' from test file ($TEST_FILE)"; fi

   if [[ $(cat $TEST_FILE) == "$TEST_VALUE" ]];
   then
      echo -e "\nPassed\n"
   else
      echo "error: reading incorrect value in file"
      return_code=1
   fi

   # remove file if existing
   rm $TEST_FILE > /dev/null 2>&1 || true
   return $return_code
}

echo "*** Test Writing and reading file on USB3 Host 1"
echo "***"

status=0
usb_read_write_test 0 || status=$?

if [ $status -ne 0 ]
then
      echo "error: Read/Write Verification failed on USB3 Host 1"
      error_count=$((error_count+1))
fi

echo "***"

echo "*** Test Writing and reading file on USB3 Host 2"
echo "***"

status=0
usb_read_write_test 1 || status=$?

if [ $status -ne 0 ]
then
      echo "error: Read/Write Verification failed on USB3 Host 2"
      error_count=$((error_count+1))
fi

echo "***"


echo "*** Done."
echo "*** Number of errors = $error_count"
echo "***"

if [ $error_count -ne 0 ]
then
   exit 1
fi

exit
