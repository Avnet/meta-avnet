#!/bin/sh -e

DEBUG=0

error_count=0

sd_rootfs_read_write_test () {
   return_code=0

   TEST_FILE="test_file.txt"
   TEST_PATTERN="ABCD0123"

   status=0
   echo $TEST_PATTERN > /home/root/${TEST_FILE} || status=$?

   if [ $status -ne 0 ]
   then
         echo "error: writing file /home/root/${TEST_FILE}"
         return 1
   fi

   text_read=$(cat /home/root/${TEST_FILE})

   if [[ $text_read && "$text_read" == "$TEST_PATTERN" ]]; then
      echo -e "\nPassed\n"
   else
      echo "error: The data read from the file differs from the test pattern"
      return_code=1
   fi

   rm /home/root/${TEST_FILE} > /dev/null 2>&1 || true

   return $return_code
}


echo "*** SD ROOTFS READ/WRITE TEST "
echo "***"

status=0
sd_rootfs_read_write_test || status=$?

if [ $status -ne 0 ]
then
      echo "error: Read/Write Verification failed on SD ROOTFS"
      error_count=$((error_count+1))
fi

echo "***"

echo "***"
echo "*** Done."
echo "*** Number of errors = $error_count"
echo "***"

if [ $error_count -ne 0 ]
then
   exit 1
fi

exit
