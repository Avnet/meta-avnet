#!/bin/sh

###########################
## Set media graph nodes ##
###########################

MEDIA_CTL_DEV="/dev/media1"
#MEDIA_CTL_DEV=$1

### Set the number of camera streams to 4
#yavta --no-query -w '0x0098c981 4' /dev/v4l-subdev4

### Set the image sensor resolution and format
media-ctl -d $MEDIA_CTL_DEV -V '"AR0231.7-0011":0 [fmt:SGRBG8/1920x1080 field:none colorspace:srgb]'
media-ctl -d $MEDIA_CTL_DEV -V '"AR0231.7-0012":0 [fmt:SGRBG8/1920x1080 field:none colorspace:srgb]'
media-ctl -d $MEDIA_CTL_DEV -V '"AR0231.7-0013":0 [fmt:SGRBG8/1920x1080 field:none colorspace:srgb]'
media-ctl -d $MEDIA_CTL_DEV -V '"AR0231.7-0014":0 [fmt:SGRBG8/1920x1080 field:none colorspace:srgb]'

sleep 1

### Set the SERDES resolution and format
media-ctl -d $MEDIA_CTL_DEV -V '"MAX9286-SERDES.7-0048":0 [fmt:SGRBG8/1920x1080 field:none colorspace:srgb]'
media-ctl -d $MEDIA_CTL_DEV -V '"MAX9286-SERDES.7-0048":1 [fmt:SGRBG8/1920x1080 field:none colorspace:srgb]'
media-ctl -d $MEDIA_CTL_DEV -V '"MAX9286-SERDES.7-0048":2 [fmt:SGRBG8/1920x1080 field:none colorspace:srgb]'
media-ctl -d $MEDIA_CTL_DEV -V '"MAX9286-SERDES.7-0048":3 [fmt:SGRBG8/1920x1080 field:none colorspace:srgb]'
media-ctl -d $MEDIA_CTL_DEV -V '"MAX9286-SERDES.7-0048":4 [fmt:SGRBG8/1920x1080 field:none colorspace:srgb]'

sleep 1

### Set up the CSI Rx subsystem resolution and format
media-ctl -d $MEDIA_CTL_DEV -V '"a0000000.mipi_csi2_rx_subsystem":0 [fmt:SGRBG8/1920x1080 field:none]'
media-ctl -d $MEDIA_CTL_DEV -V '"a0000000.mipi_csi2_rx_subsystem":1 [fmt:SGRBG8/1920x1080 field:none]'

sleep 1

### Setup the AXI Switch resolution and format
media-ctl -d $MEDIA_CTL_DEV -V '"amba_pl@0:axis_switch@0":0 [fmt:SGRBG8/1920x1080 field:none colorspace:srgb]'
media-ctl -d $MEDIA_CTL_DEV -V '"amba_pl@0:axis_switch@0":1 [fmt:SGRBG8/1920x1080 field:none colorspace:srgb]'
media-ctl -d $MEDIA_CTL_DEV -V '"amba_pl@0:axis_switch@0":2 [fmt:SGRBG8/1920x1080 field:none colorspace:srgb]'
media-ctl -d $MEDIA_CTL_DEV -V '"amba_pl@0:axis_switch@0":3 [fmt:SGRBG8/1920x1080 field:none colorspace:srgb]'
media-ctl -d $MEDIA_CTL_DEV -V '"amba_pl@0:axis_switch@0":4 [fmt:SGRBG8/1920x1080 field:none colorspace:srgb]'

sleep 1

### Set Camera 0 capture pipeline properties, resize from 1920x1080 to 1920x1080
media-ctl -d $MEDIA_CTL_DEV -V '"b0040000.v_demosaic":0 [fmt:SGRBG8/1920x1080 field:none]'
media-ctl -d $MEDIA_CTL_DEV -V '"b0040000.v_demosaic":1 [fmt:RBG24/1920x1080 field:none]'
media-ctl -d $MEDIA_CTL_DEV -V '"b0000000.v_proc_ss":0 [fmt:RBG24/1920x1080 field:none]'
media-ctl -d $MEDIA_CTL_DEV -V '"b0000000.v_proc_ss":1 [fmt:RBG24/1920x1080 field:none]'
media-ctl -d $MEDIA_CTL_DEV -V '"b0080000.v_proc_ss":0 [fmt:RBG24/1920x1080 field:none]'
media-ctl -d $MEDIA_CTL_DEV -V '"b0080000.v_proc_ss":1 [fmt:VYYUYY8_1X24/1920x1080 field:none]'

sleep 1

### Set Camera 1 capture pipeline properties, resize from 1920x1080 to 1920x1080
media-ctl -d $MEDIA_CTL_DEV -V '"b0070000.v_demosaic":0 [fmt:SGRBG8/1920x1080 field:none]'
media-ctl -d $MEDIA_CTL_DEV -V '"b0070000.v_demosaic":1 [fmt:RBG24/1920x1080 field:none]'
media-ctl -d $MEDIA_CTL_DEV -V '"b0010000.v_proc_ss":0 [fmt:RBG24/1920x1080 field:none]'
media-ctl -d $MEDIA_CTL_DEV -V '"b0010000.v_proc_ss":1 [fmt:RBG24/1920x1080 field:none]'
media-ctl -d $MEDIA_CTL_DEV -V '"b00c0000.v_proc_ss":0 [fmt:RBG24/1920x1080 field:none]'
media-ctl -d $MEDIA_CTL_DEV -V '"b00c0000.v_proc_ss":1 [fmt:VYYUYY8_1X24/1920x1080 field:none]'

sleep 1

### Set Camera 2 capture pipeline properties, resize from 1920x1080 to 1920x1080
media-ctl -d $MEDIA_CTL_DEV -V '"b01d0000.v_demosaic":0 [fmt:SGRBG8/1920x1080 field:none]'
media-ctl -d $MEDIA_CTL_DEV -V '"b01d0000.v_demosaic":1 [fmt:RBG24/1920x1080 field:none]'
media-ctl -d $MEDIA_CTL_DEV -V '"b0020000.v_proc_ss":0 [fmt:RBG24/1920x1080 field:none]'
media-ctl -d $MEDIA_CTL_DEV -V '"b0020000.v_proc_ss":1 [fmt:RBG24/1920x1080 field:none]'
media-ctl -d $MEDIA_CTL_DEV -V '"b0100000.v_proc_ss":0 [fmt:RBG24/1920x1080 field:none]'
media-ctl -d $MEDIA_CTL_DEV -V '"b0100000.v_proc_ss":1 [fmt:VYYUYY8_1X24/1920x1080 field:none]'

sleep 1

### Set Camera 3 capture pipeline properties, resize from 1920x1080 to 1920x1080
media-ctl -d $MEDIA_CTL_DEV -V '"b01f0000.v_demosaic":0 [fmt:SGRBG8/1920x1080 field:none]'
media-ctl -d $MEDIA_CTL_DEV -V '"b01f0000.v_demosaic":1 [fmt:RBG24/1920x1080 field:none]'
media-ctl -d $MEDIA_CTL_DEV -V '"b0030000.v_proc_ss":0 [fmt:RBG24/1920x1080 field:none]'
media-ctl -d $MEDIA_CTL_DEV -V '"b0030000.v_proc_ss":1 [fmt:RBG24/1920x1080 field:none]'
media-ctl -d $MEDIA_CTL_DEV -V '"b0140000.v_proc_ss":0 [fmt:RBG24/1920x1080 field:none]'
media-ctl -d $MEDIA_CTL_DEV -V '"b0140000.v_proc_ss":1 [fmt:VYYUYY8_1X24/1920x1080 field:none]'

# ### Set Brightness of CSC to 100%
yavta --no-query -w '0x0098c9a1 100' /dev/v4l-subdev10
yavta --no-query -w '0x0098c9a1 100' /dev/v4l-subdev11
yavta --no-query -w '0x0098c9a1 100' /dev/v4l-subdev12
yavta --no-query -w '0x0098c9a1 100' /dev/v4l-subdev13
