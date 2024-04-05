#!/bin/sh -e

error_count=0

dmesg_check () {
   if dmesg | grep -q "WLAN initialization FAILED"; then
      echo "WLAN initialization FAILED detected!"
      return 1
   fi

   return 0
}

lsmod_check () {

   if ! lsmod | grep -q "wilc_sdio"; then
      echo "wilc_sdio module not loaded"
      return 1
   fi

   return 0
}

interface_check () {
   interface_name=$1

   if ! iw dev |  grep -q $interface_name; then
      echo "$interface_name not found"
      return 1
   fi

   return 0
}

wifi_scan () {
   status=0

   wpa_cli scan || status=$?
   if [ $status -ne 0 ]
   then
      echo "error: starting WiFi scan"
      return 1
   fi

   wpa_cli scan_r  > /dev/null  || status=$?
   if [ $status -ne 0 ]
   then
      echo "error: getting WiFi scan results"
      return 1
   fi

   return 0
}

echo "***"

echo "*** DMESG Check Test"
echo "***"

status=0
dmesg_check || status=$?

if [ $status -ne 0 ]
then
   echo "error: DMESG Check Test failed"
   error_count=$((error_count+1))
else
   echo "DMESG Check Test passed"
fi

echo "***"

echo "*** LSMOD Check Test"
echo "***"

status=0
lsmod_check || status=$?

if [ $status -ne 0 ]
then
   echo "error: LSMOD Check Test failed"
   error_count=$((error_count+1))
else
   echo "LSMOD Check Test passed"
fi

echo "***"

echo "*** WiFi interfaces Test "
echo "***"

status=0
interface_check "wlan0" || status=$?

if [ $status -ne 0 ]
then
   echo "error: WiFi interfaces Test failed: wlan0 not found"
   error_count=$((error_count+1))
else
   echo "wlan0 interface detected"
fi

echo "***"

echo "*** WiFi Scan Test "
echo "***"

status=0
wifi_scan || status=$?

if [ $status -ne 0 ]
then
   echo "error: WiFi Scan Test failed: wlan0 not found"
   error_count=$((error_count+1))
else
   echo "wlan0 interface detected"
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

