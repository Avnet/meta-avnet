#!/bin/sh -e

DEBUG=0

error_count=0

mass_storage_setup () {
   status=0

   # remove file if existing
   rm /mass_storage > /dev/null 2>&1 || true

   dd if=/dev/zero of=/mass_storage bs=1M seek=1024 count=0 || status=$?
   if [ $status -ne 0 ]
   then
         echo "error: creating mass_storage volume"
         return 1
   fi

   format=$(cat <<EOF | sfdisk -L -uS /mass_storage
   ,,c
EOF
   ) || status=$?
   if [ $status -ne 0 ]
   then
         echo "error: partitionning mass_storage volume"
         return 1
   fi

   losetup -o1048576 /dev/loop0 /mass_storage || status=$?
   #(1048576 is the start offset for the partition: 2048*512)
   if [ $status -ne 0 ]
   then
         echo "error: setup loop device"
         return 1
   fi

   mkdosfs /dev/loop0  || status=$?
   if [ $status -ne 0 ]
   then
         echo "error: formating mass_storage volume"
         return 1
   fi

   mount -t vfat /dev/loop0 /mnt/  || status=$?
   if [ $status -ne 0 ]
   then
         echo "error: mounting the mass_storage volume"
         return 1
   fi

   echo hello > /mnt/test || status=$?
   if [ $status -ne 0 ]
   then
         echo "error: creating a file on mass_storage volume"
         return 1
   fi

   umount /mnt/ || status=$?
   if [ $status -ne 0 ]
   then
         echo "error: unmounting the mass_storage volume"
         return 1
   fi

   losetup -d /dev/loop0 || status=$?
   if [ $status -ne 0 ]
   then
         echo "error: removing the loop device"
         return 1
   fi

   modprobe g_mass_storage file=/mass_storage  || status=$?
   if [ $status -ne 0 ]
   then
         echo "error: loading the mass storage driver"
         return 1
   fi

   return 0
}

mass_storage_verification () {

   echo "Connect a USB cable from the USB3 device port to your computer"
   read -p "Do you confirm that you can mount the mass storage volume on your computer
   and read 'hello' in the 'test' file ? [Y/n]" -n 1 -r
   if [[ $REPLY =~ ^[Yy]$ ]]  || [[ -z $REPLY ]]
   then
      echo -e "\n\tyes\n"
   else
      echo -e "\n\tno\n"
      return 1
   fi

   return 0
}

mass_storage_cleanup () {
   status=0

   rmmod g_mass_storage || status=$?
   if [ $status -ne 0 ]
   then
         echo "error: unloading the mass storage driver"
         return 1
   fi

   rm /mass_storage || status=$?
   if [ $status -ne 0 ]
   then
         echo "error: removing the mass storage volume"
         return 1
   fi

   return 0
}

echo "*** Setup Mass Storage Test"
echo "***"

status=0
mass_storage_setup || status=$?

if [ $status -ne 0 ]
then
      echo "error: Setup Mass Storage Test failed"
      error_count=$((error_count+1))
fi

echo "***"

echo "*** Mass Storage Verification Test "
echo "***"

status=0
mass_storage_verification || status=$?

if [ $status -ne 0 ]
then
      echo "error: Mass Storage Verification Test failed"
      error_count=$((error_count+1))
fi

echo "***"


echo "*** Clean-up Mass Storage Test"
echo "***"

status=0
mass_storage_cleanup || status=$?

if [ $status -ne 0 ]
then
      echo "error: Mass Storage Clean-up Test failed"
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
