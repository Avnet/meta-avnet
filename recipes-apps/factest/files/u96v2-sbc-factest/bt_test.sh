#!/bin/sh -e

error_count=0

bt_setup () {
   status=0
   DEV="/dev/"`ls /sys/devices/platform/axi/ff000000.serial/tty/`

   if [ -z "${DEV}" ]
   then
         echo "error: failed getting serial port"
         return 1
   fi

   echo BT_POWER_UP > /dev/wilc_bt || status=$?
   if [ $status -ne 0 ]
   then
      echo "error: turning BT_POWER_UP failed"
      return 1
   fi

   echo BT_DOWNLOAD_FW > /dev/wilc_bt || status=$?
   if [ $status -ne 0 ]
   then
      echo "error: loading BT_DOWNLOAD_FW failed"
      return 1
   fi

   sleep 1

   stty -F $DEV 115200 crtscts || status=$?
   if [ $status -ne 0 ]
   then
      echo "error: setting serial parameters"
      return 1
   fi

   # Initialize the device:
   hciattach $DEV -t 10 any 115200 noflow nosleep || status=$?
   if [ $status -ne 0 ]
   then
      echo "error: attaching bt to serial port"
      return 1
   fi

   sleep 1

   #Configure the right BT device:
   hciconfig hci0 up || status=$?
   if [ $status -ne 0 ]
   then
      echo "error: turning on hci0 interface"
      return 1
   fi

   bluetoothctl power on || status=$?
   if [ $status -ne 0 ]
   then
      echo "error: scanning for BLE devices"
      return 1
   fi

   return 0
}

bt_scan () {
   status=0

   timeout --preserve-status 2s  bluetoothctl scan on > /dev/null || status=$?
   if [ $status -ne 0 ]
   then
      echo "error: scanning for BLE devices"
      return 1
   fi

   return 0
}

bt_teardown () {
   pkill bluetoothd > /dev/null 2>&1 || true
   pkill hciattach > /dev/null 2>&1 || true
   hciconfig hci0 down > /dev/null 2>&1 || true
}


echo "*** BT Setup"
echo "***"

status=0
bt_setup || status=$?

if [ $status -ne 0 ]
then
   echo "error: BT Setup Test failed"
   error_count=$((error_count+1))
else
   echo "BT Setup Test passed"
fi

echo "***"

echo "*** BT SCAN Test"
echo "***"

status=0
bt_scan || status=$?

if [ $status -ne 0 ]
then
   echo "error: BT Scan Test failed"
   error_count=$((error_count+1))
else
   echo "BT Scan Test passed"
fi

echo "***"

bt_teardown

echo "*** Done."
echo "*** Number of errors = $error_count"
echo "***"

if [ $error_count -ne 0 ]
then
   exit 1
fi

exit

