#!/bin/sh -e

DEBUG=0

error_count=0

echo "***"
echo "*** USB test."
echo "*** Write a file to USB Flash drive then read it back and compare."
echo "***"

status=0

echo "***"
echo "*** Get USB mount point"
echo "***"
USB_MOUNT_POINTS=(`df | grep ^/dev/sd  | awk  '{print $6}'`)

if [ $DEBUG -eq 1 ]; then echo "DEBUG: USB_MOUNT_POINTS = ${USB_MOUNT_POINTS[@]}"; fi

nb_points=${#USB_MOUNT_POINTS[@]}

if [ $nb_points -ne 1 ]
then
   echo "ERROR: incorrect number of USB_MOUNT_POINTS from df command ($nb_points)"
   exit 1
fi

USB_DIR=${USB_MOUNT_POINTS[0]}
echo -e "\nPassed (USB mount point is $USB_DIR)\n"

echo "***"
echo "*** Test writing and reading file"
echo "***"

TEST_FILE=$USB_DIR/test_file
TEST_VALUE="This is a test"

# remove file if existing
rm $TEST_FILE > /dev/null 2>&1 || true

if [ $DEBUG -eq 1 ]; then echo "DEBUG: writing '$TEST_VALUE' to test file ($TEST_FILE)"; fi
echo $TEST_VALUE > $TEST_FILE

sync

if [ $DEBUG -eq 1 ]; then echo "DEBUG: reading '$(cat $TEST_FILE)'' from test file ($TEST_FILE)"; fi

if [[ $(cat $TEST_FILE) == "$TEST_VALUE" ]];
then
   echo -e "\nPassed\n"
else
   echo "ERROR: reading incorrect value in file"
   error_count=$((error_count+1))
fi

# remove file if existing
rm $TEST_FILE > /dev/null 2>&1 || true

echo "***"
echo "*** Done."
echo "*** Number of errors = $error_count"
echo "***"

if [ $error_count -ne 0 ]
then
   exit 1
fi

exit
