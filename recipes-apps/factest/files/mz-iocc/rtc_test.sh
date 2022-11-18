#!/bin/sh -e

DEBUG=0

REF_TIME=1660741291 #Wed Aug 17 13:01:31 UTC 2022
ACCEPTABLE_DELAY=10 # Shouldn't take more than 10 seconds to set the time to the RTC and get it back

error_count=0

echo "***"
echo "*** Set system time (Reference time = $REF_TIME secondes, $(date -d @$REF_TIME))"
echo "***"

status=0
date -s @$REF_TIME || status=$?

if [ $status -ne 0 ]
then
      echo "error: setting the system time"
      exit 1
else
   echo -e "\nDone\n"
fi

echo "***"
echo "*** Write to RTC"
echo "***"

status=0
hwclock -w || status=$?

if [ $status -ne 0 ]
then
      echo "error: writing system time to RTC"
      exit 1
else
   echo -e "\nDone\n"
fi


echo "***"
echo "*** Get the time from RTC"
echo "***"

status=0
rtc_time_str=$(hwclock -v | grep "Hw clock time") || status=$?

if [ $status -ne 0 ]
then
   echo "error: getting RTC time: command hwclock returned status $status"
   exit 1
else
   echo -e "\n$rtc_time_str\n"
fi

status=0
rtc_time=$(echo $rtc_time_str | sed "s/.* = \([0-9]\+\) seconds .*/\1/") || status=$?

if [ $status -ne 0 ]
then
   echo "error: getting RTC time: converting to timestamp returned status $status"
   exit 1
fi

echo "***"
echo "*** Compare RTC time and Reference time"
echo "***"

delta=$((rtc_time-REF_TIME))
echo -e "\nDifference between RTC time and Reference time is $delta seconds\n"

if [ $delta -lt 0 ]
then
   echo "error: comparing RTC time: RTC time should be bigger than Reference time"
   exit 1
fi

if [ $delta -ge $ACCEPTABLE_DELAY ]
then
   echo "error: comparing RTC time: took too long to set the RTC time (more than $ACCEPTABLE_DELAY seconds)"
   exit 1
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
