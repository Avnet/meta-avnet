#!/bin/sh -e

error_count=0

dp_detect () {
   status=0
   xrandr -d :0 || status=$?

   if [ $status -ne 0 ]
   then
         echo "error: Display not found"
         return 1
   fi

   xrandr -d :0 | grep "DP-1 connected" > /dev/null 2>&1 || status=$?

   if [ $status -ne 0 ]
   then
         echo "error: Monitor not connected"
         return 1
   fi

   return 0
}

dp_visual_test () {

   read -p "Do you confirm that Matchbox Desktop is displayed on the monitor? [Y/n]" -n 1 -r
   if [[ $REPLY =~ ^[Yy]$ ]]  || [[ -z $REPLY ]]
   then
      echo -e "\n\tyes\n"
   else
      echo -e "\n\tno\n"
      return 1
   fi

   return 0
}

echo "*** Display Port Detection Test"
echo "***"

status=0
dp_detect || status=$?

if [ $status -ne 0 ]
then
      echo "error: Display Port Detection Test failed"
      error_count=$((error_count+1))
fi

echo "***"

echo "*** Display Port Visual Test "
echo "***"

status=0
dp_visual_test || status=$?

if [ $status -ne 0 ]
then
      echo "error: Display Port Visual Test failed"
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

