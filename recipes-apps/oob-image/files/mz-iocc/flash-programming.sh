#!/bin/sh -e

DEBUG=0

prog_flash () {
   PROG_FILE=$1
   FILE_TYPE=$2
   PARTITION=$3
   FLASH_PROGRAMMING_RESULT=-1

   # Program the file to the QSPI partition
   if [ -f $OOB_PATH/$PROG_FILE ]
   then
      echo "***"
      echo "*** Programming $FILE_TYPE file \"$PROG_FILE\" to QSPI partition $PARTITION..."
      echo "***"
      flashcp -v $OOB_PATH/$PROG_FILE $PARTITION
      FLASH_PROGRAMMING_RESULT=$?
   else
      echo "ERROR: File $PROG_FILE not found"
      error_count=$((error_count+1))
   fi 

   # Check Flash programming status
   if [ $FLASH_PROGRAMMING_RESULT -ne 0 ]
   then
      echo "ERROR: Flash programming $PROG_FILE failed!"
      error_count=$((error_count+1))
   else
      if [ $DEBUG -eq 1 ]; then echo -e "DEBUG: Flash programming $PROG_FILE successful"; fi
   fi
}

OOB_PATH=/home/root/oob_image
BOOT_FILE=boot.bin
KERNEL_FILE=uImage
DTB_FILE=devicetree.dtb
ROOTFS_FILE=uramdisk.image.gz
BIT_FILE=system.bit.bin

echo "***"
echo "*** Program the out-of-box Linux OS image to QSPI"
echo "***"

error_count=0

#
# Delete existing QSPI partitions
#
echo "***"
echo "*** Delete the existing QSPI partition table"
echo "***"
#
# Identify how many QSPI partitions there are and delete them
# mtd0 is the "master" QSPI partition and can't be deleted
#
MTD_ARRAY=$(cat /proc/mtd |grep mtd |cut -d ":" -f1 |cut -c4-5)
#echo ${MTD_ARRAY[@]}
# Loop through the array elements
for i in ${MTD_ARRAY[@]}
do
   if [ -e /dev/mtd$i ]
   then 
      #echo "/dev/mtd$i"
      if  [ $i -eq 0 ]
      then
         # do nothing on partition 0
         if [ $DEBUG -eq 1 ]; then echo -e "DEBUG: Cannot delete partition $i"; fi
      else
         if [ $DEBUG -eq 1 ]; then echo -e "DEBUG: Deleting QSPI partition $i"; fi
         mtdpart del /dev/mtd0 $i
      fi
   else
      echo "ERROR: QSPI partition $i not found"
      error_count=$((error_count+1))
   fi
done

# reset the array to empty it
MTD_ARRAY=()

# Print the partition table if DEBUG is enabled
# Partition table should now be empty
if [ $DEBUG -eq 1 ]; then cat /proc/mtd; fi
 
# We need /proc/mtd our Linux system to be configured as follows:
# mtd0 is the "master" partition
# dev:  size     erasesize name
# mtd0: 02000000 00010000  "spi0.0"
# mtd1: 00100000 00010000  "qspi-fsbl-uboot"
# mtd2: 00500000 00010000  "qspi-linux"
# mtd3: 00020000 00010000  "qspi-device-tree"
# mtd4: 005e0000 00010000  "qspi-rootfs"
# mtd5: 00400000 00010000  "qspi-bitstream"

#
# Create new QSPI partitions
# Partition number will auto-increment, so we add them in order
# of how we need the QSPI organized
#
echo "***"
echo "*** Create the new QSPI partition table"
echo "***"
#mtd1
mtdpart add /dev/mtd0 qspi-fsbl-uboot 0 0x100000
#mtd2
mtdpart add /dev/mtd0 qspi-linux 0x100000 0x500000
#mtd3
mtdpart add /dev/mtd0 qspi-device-tree 0x600000 0x20000
#mtd4
mtdpart add /dev/mtd0 qspi-rootfs 0x620000 0x5e0000
#mtd5
mtdpart add /dev/mtd0 qspi-bitstream 0xc00000 0x400000

# Print the partition table if DEBUG is enabled
# Partition table should now have the new partitions
if [ $DEBUG -eq 1 ]; then cat /proc/mtd; fi

#
# Install the boot loader
#
prog_flash $BOOT_FILE "FSBL and u-boot bootloader" /dev/mtd1

#
# Install the Linux kernel
#
prog_flash $KERNEL_FILE "Linux kernel" /dev/mtd2

#
# Install the kernel device tree
#
prog_flash $DTB_FILE "kernel device tree" /dev/mtd3

#
# Install the RAMdisk image
#
prog_flash $ROOTFS_FILE "RAMdisk image" /dev/mtd4

#
# Install the PL bitstream
#
prog_flash $BIT_FILE "PL bitstream" /dev/mtd5

echo "***"
echo "*** Done."
echo "*** Number of errors = $error_count"
echo "***"

if [ $error_count -ne 0 ]
then
   exit 1
fi

exit

