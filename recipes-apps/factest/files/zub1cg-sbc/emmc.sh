#!/bin/sh -e

DEBUG=0

error_count=0

EMMC="mmcblk1"
EMMC_DEV="/dev/${EMMC}"


emmc_umount_all_parts () {
   umount ${EMMC_DEV}p*  > /dev/null 2>&1 || true
}

emmc_mount_all_parts() {
   for partition in $(ls ${EMMC_DEV}p* | grep -Eo '[0-9]+$'); do
      mount_point="/run/media/${EMMC}p${partition}"
      mkdir -p ${mount_point}
      mount ${EMMC_DEV}p${partition} ${mount_point}
   done
}

emmc_read_write_test () {
   PART_NUMBER=$1

   return_code=0

   MOUNT_POINT=/run/media/${EMMC}p${PART_NUMBER}

   TEST_FILE="test_file"
   RESULT_FILE="read_test_file"

   echo "ABCD0123" > /home/root/${TEST_FILE}

   dd if=/home/root/${TEST_FILE} of=${MOUNT_POINT}/${TEST_FILE} oflag=direct
   dd if=${MOUNT_POINT}/${TEST_FILE} of=/home/root/${RESULT_FILE} iflag=direct

   hash1=$(sha512sum /home/root/"${TEST_FILE}" | awk '{print $1}')
   hash2=$(sha512sum /home/root/"${RESULT_FILE}" | awk '{print $1}')

   if [[ $hash1 && "$hash1" == "$hash2" ]]; then
      echo -e "\nPassed\n"
   else
      echo "error: The file read from the emmc differs from the test file"
      return_code=1
   fi

   rm /home/root/${TEST_FILE} > /dev/null 2>&1 || true
   rm ${MOUNT_POINT}/$TEST_FILE > /dev/null 2>&1 || true
   rm /home/root/${RESULT_FILE} > /dev/null 2>&1 || true

   return $return_code
}

echo "*** EMMC Detection"
echo "***"

ls ${EMMC_DEV}

echo "***"

echo "*** Prepare and partition the EMMC"
echo "***"

SFDISK_FILE="/home/root/factest_scripts/emmc_mmcblk1.sfdisk"

emmc_umount_all_parts

# Wipe existing partitions
if ! ls ${EMMC_DEV}p* > /dev/null 2>&1; then
   wipefs -a ${EMMC_DEV}p*
fi

sfdisk ${EMMC_DEV} < $SFDISK_FILE

mkfs.vfat -n boot ${EMMC_DEV}p1
mkfs.ext4 -L user ${EMMC_DEV}p2

emmc_umount_all_parts
emmc_mount_all_parts

echo "***"


echo "*** Read/Write Verification on EMMC part1 "
echo "***"

status=0
emmc_read_write_test 1 || status=$?

if [ $status -ne 0 ]
then
      echo "error: Read/Write Verification failed on EMMC part1 "
      error_count=$((error_count+1))
fi

echo "***"

echo "*** Read/Write Verification on EMMC part2 "
echo "***"

status=0
emmc_read_write_test 2 || status=$?

if [ $status -ne 0 ]
then
      echo "error: Read/Write Verification failed on EMMC part2 "
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
