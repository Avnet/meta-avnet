#!/bin/sh
# ----------------------------------------------------------------------------
#
#        ** **        **          **  ****      **  **********  **********
#       **   **        **        **   ** **     **  **              **
#      **     **        **      **    **  **    **  **              **
#     **       **        **    **     **   **   **  *********       **
#    **         **        **  **      **    **  **  **              **
#   **           **        ****       **     ** **  **              **
#  **  .........  **        **        **      ****  **********      **
#     ...........
#                                     Reach Further
#
# ----------------------------------------------------------------------------
# 
#  This design is the property of Avnet.  Publication of this
#  design is not authorized without written consent from Avnet.
#  
#  Product information is available at:
#     https://avnet.me/
# 
#  Disclaimer:
#     Avnet, Inc. makes no warranty for the use of this code or design.
#     This code is provided  "As Is". Avnet, Inc assumes no responsibility for
#     any errors, which may appear in this code, nor does it make a commitment
#     to update the information contained herein. Avnet, Inc specifically
#     disclaims any implied warranties of fitness for a particular purpose.
#                      Copyright(c) 2024 Avnet, Inc.
#                              All rights reserved.
# 
# ----------------------------------------------------------------------------
# 
#  Create Date:         May 30, 2024
#  Design Name:         Factory Test Launcher Script
#  Module Name:         factest-launcher.sh
#  Project Name:        Factory Test Launcher Script
#  Target Devices:      Xilinx Zynq and Zynq UltraScale+ MPSoC
#  Hardware Boards:     K24C SOM + I/O Carrier
# 
#  Tool versions:       Xilinx Vivado 2023.2
# 
#  Description:         Factory Test Launcher Script
# 
#  Dependencies:        Factory Test (factest.sh)
#
#  Revision:            May 30, 2024: 1.0 Initial version
# 
# ----------------------------------------------------------------------------

FACTORY_TEST_SCRIPT=/home/root/factest.sh
FLASH_PROGRAMMING_SCRIPT=/home/root/flash-programming.sh

sleep 1

while :
do
	# Show the factory test banner.
	echo " "
	echo "*********************************************************************"
	echo "***                                                               ***"
	echo "***    Avnet K24C SOM + I/O Carrier Factory Test Launcher V1.0    ***"
	echo "***                                                               ***"
	echo "*********************************************************************"
	echo "***                                                                ***"
	echo "***    Please Press Key to Perform Desired Function Below:         ***"
	echo "***                                                                ***"
	echo "***    'f' - Factory Test                                          ***"
	echo "***    'i' - Run Unattended Factory Test in Infinite Loop          ***"
	echo "***    's' - Install Software to Flash Memory                      ***"
	echo "***    'x' - Linux Command Prompt                                  ***"
	echo "***                                                                ***"
	echo "***    NOTE: Waiting will AUTO-INITIATE Factory Test               ***"
	echo "***                                                                ***"
	echo "**********************************************************************"
	echo " "

	# clear stdin by reading it
	read -t 0.3 -N 1000

	answer=""
	read -t 10 answer
	if [ "$answer" = "x" ]
	then
		echo " "
		echo "******************************************************************"
		echo "*** Exiting to Linux Command Prompt                            ***"
		echo "******************************************************************"
		echo " "
		break
	elif [ "$answer" = "f" ]
	then
		echo " "
		echo "******************************************************************"
		echo "*** Initiating Factory Test Suite                              ***"
		echo "******************************************************************"
		echo " "
		bash ${FACTORY_TEST_SCRIPT}
	elif [ "$answer" = "i" ]
	then
		echo " "
		echo "******************************************************************"
		echo "*** Initiating Unattended Looped Factory Test Suite            ***"
		echo "******************************************************************"
		echo " "
		while true;
		do
			bash ${FACTORY_TEST_SCRIPT} -u
		done
	elif [ "$answer" = "s" ]
	then
		echo " "
		echo "******************************************************************"
		echo "*** Initiating Software Install to Flash Memory                ***"
		echo "******************************************************************"
		echo " "
		source ${FLASH_PROGRAMMING_SCRIPT}
	else
		echo " "
		echo "******************************************************************"
		echo "*** Auto-Initiating Factory Test Suite                         ***"
		echo "******************************************************************"
		echo " "
		bash ${FACTORY_TEST_SCRIPT}
	fi
done

sleep 1
