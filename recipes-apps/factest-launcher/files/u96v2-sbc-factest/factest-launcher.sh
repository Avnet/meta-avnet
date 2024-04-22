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
#     http://avnet.me/ultra96-v2
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
#  Create Date:         Mar 21, 2024
#  Design Name:         Factory Test Launcher Script
#  Module Name:         factest-launcher.sh
#  Project Name:        Factory Test Launcher Script
#  Target Devices:      Xilinx Zynq UltraScale+ 3EG
#  Hardware Boards:     Ultra96v2 Board
# 
#  Tool versions:       Xilinx Vivado 2023.1
# 
#  Description:         Factory Test Launcher Script
# 
#  Dependencies:        Factory Test (factest.sh)
#
# ----------------------------------------------------------------------------

FACTORY_TEST_SCRIPT=/home/root/factest.sh

sleep 1

while :
do
	# Show the factory test banner.
	echo " "
	echo "******************************************************************"
	echo "***                                                            ***"
	echo "***    Avnet Ultra96v2 Factory Test Launcher V1.0              ***"
	echo "***                                                            ***"
	echo "******************************************************************"
	echo "***                                                            ***"
	echo "***    Please Press Key to Perform Desired Function Below:     ***"
	echo "***                                                            ***"
	echo "***    'f' - Factory Test                                      ***"
	echo "***    'x' - Linux Command Prompt                              ***"
	echo "***                                                            ***"
	echo "***    NOTE: Waiting will AUTO-INITIATE Factory Test           ***"
	echo "***                                                            ***"
	echo "******************************************************************"
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
