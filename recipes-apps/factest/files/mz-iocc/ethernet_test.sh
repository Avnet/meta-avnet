#!/bin/sh -e

DEBUG=0

BOARD_IP=192.168.2.10
TEST_COMPUTER_IP=192.168.2.1

error_count=0

echo "*** Verify Ethernet Mac Address"
echo "***"

status=0
ETH_MAC_ADDRESS=$(cat /sys/class/net/eth0/address) || status=$?

if [ $status -ne 0 ]
then
      echo "error: getting Mac Address for Eth0"
      error_count=$((error_count+1))
else
   echo -e "\nMac Address is '$ETH_MAC_ADDRESS'\n"
fi
echo "***"

echo "*** Configure Ethernet (IP $BOARD_IP)"
echo "***"

status=0
ifconfig eth0 $BOARD_IP || status=$?

if [ $status -ne 0 ]
then
      echo "error: configuring eth0 interface with IP $BOARD_IP"
      error_count=$((error_count+1))
else
   echo -e "\nPassed\n"
fi
echo "***"

echo "*** Test Ping to Computer IP $TEST_COMPUTER_IP"
echo "***"

status=0
ping -w 5 $TEST_COMPUTER_IP || status=$?

if [ $status -ne 0 ]
then
      echo "error: command ping to IP $TEST_COMPUTER_IP returned status $status"
      error_count=$((error_count+1))
else
   echo -e "\nPassed\n"
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
