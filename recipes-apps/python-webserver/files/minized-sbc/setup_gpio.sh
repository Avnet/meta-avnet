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
#  Please direct any questions to the UltraZed community support forum:
#     http://www.ultrazed.org/forum
#
#  Product information is available at:
#     http://www.ultrazed.org/product/ultrazed-EG
#
#  Disclaimer:
#     Avnet, Inc. makes no warranty for the use of this code or design.
#     This code is provided  "As Is". Avnet, Inc assumes no responsibility for
#     any errors, which may appear in this code, nor does it make a commitment
#     to update the information contained herein. Avnet, Inc specifically
#     disclaims any implied warranties of fitness for a particular purpose.
#                      Copyright(c) 2016 Avnet, Inc.
#                              All rights reserved.
#
# ----------------------------------------------------------------------------
#
#  Create Date:         Feb 22, 2018
#  Design Name:         GPIO Sysfs Init Script
#  Module Name:         setup_gpio.sh
#  Project Name:        GPIO Sysfs Init Script
#  Target Devices:      Xilinx Zynq and Zynq UltraScale+ MPSoC
#  Hardware Boards:     UltraZed-EG + I/O Carrier
#                       UltraZed-EV + EV Carrier
#
#  Tool versions:       Xilinx Vivado 2017.3
#
#  Description:         GPIO Sysfs Init Script
#
#  Dependencies:
#
#  Revision:            Feb 22, 2018: 1.0 Initial version
#
# ----------------------------------------------------------------------------
#!/bin/sh

# get-gpio-offsets writes gpio offsets to file
GPIO_OFFSETS=/mnt/emmc/gpio_offsets.txt
get-gpio-offsets

# get offsets
IFS="=" read MIO0_KEY MIO0_OFFSET AXI_MAX_KEY AXI_MAX_OFFSET <<< $(cat $GPIO_OFFSETS | tr '\n' '=')

gpios=(
    $((MIO0_OFFSET + 52))   #PS_LED_R
    $((MIO0_OFFSET + 53))   #PS_LED_G
    $((AXI_MAX_OFFSET))     #PL_LED_R
    $((AXI_MAX_OFFSET + 1)) #PL_LED_G
    $((AXI_MAX_OFFSET - 8)) #PL_LED_ENABLE
)

for gpio in ${gpios[@]}; do
    echo ${gpio} > /sys/class/gpio/export
    echo out > /sys/class/gpio/gpio${gpio}/direction
done
