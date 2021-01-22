#!/bin/sh
#*******************************************************************************
#
# Copyright (C) 2019 Xilinx, Inc.  All rights reserved.
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
# of the Software, and to permit persons to whom the Software is furnished to do
# so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all 
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
# AUTHORS OR COPYRIGHT HOLDERS  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
# SOFTWARE.
#
# Author:     Bhargava Sreekantappa Gayathri <bsreekan@xilinx.com>
#
# ******************************************************************************

#Load the kernel module for the WILC3000 WiFi 
modprobe wilc-sdio

#The WILC3000 supports 2 interfaces
#--p2p0 for use as an access point
#--wlan0 for use as an WLAN node

cd /usr/share/wpa_ap

while ! ip a show wlan0 > /dev/null 2>&1
do
	sleep 1
done

#Create a new managed mode interface p2p0 to run AP
iw phy phy0 interface add p2p0 type managed

# To retrieve the mac address, we have to turn the interface up
ifconfig p2p0 up

hid=$(ifconfig -a | grep p2p0 | sed "s,p2p0.*HWaddr \(.*\),\1," | tr -d ": ")

ip=192.168.2.1

sed "s,Ultra96,Ultra96-V2_$hid," wpa_ap.conf > wpa_ap_actual.conf

ifconfig p2p0 down

sleep 2

wpa_supplicant -c ./wpa_ap_actual.conf  -ip2p0 &

ifconfig p2p0 $ip

touch /var/lib/misc/udhcpd.leases
udhcpd ./udhcpd.conf
