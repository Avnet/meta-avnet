#!/bin/sh

###########################
## Set media graph nodes ##
###########################

MEDIA_CTL_DEV="/dev/media1"
#MEDIA_CTL_DEV=$1

# Set MARS sensor nodes
media-ctl -d $MEDIA_CTL_DEV -V "\"mars 15-0041\":0 [fmt:SGRBG8_1X8/1920x1080 field:none]"
media-ctl -d $MEDIA_CTL_DEV -V "\"mars 16-0042\":0 [fmt:SGRBG8_1X8/1920x1080 field:none]"
media-ctl -d $MEDIA_CTL_DEV -V "\"mars 17-0043\":0 [fmt:SGRBG8_1X8/1920x1080 field:none]"
media-ctl -d $MEDIA_CTL_DEV -V "\"mars 18-0044\":0 [fmt:SGRBG8_1X8/1920x1080 field:none]"

# set Serdes nodes
#media-ctl -d $MEDIA_CTL_DEV -V "\"MAX9286-SERDES.25-0048\":0 [fmt:SGRBG8_1X8/1920x1080 field:none]"
#media-ctl -d $MEDIA_CTL_DEV -V "\"MAX9286-SERDES.25-0048\":1 [fmt:SGRBG8_1X8/1920x1080 field:none]"
#media-ctl -d $MEDIA_CTL_DEV -V "\"MAX9286-SERDES.25-0048\":2 [fmt:SGRBG8_1X8/1920x1080 field:none]"
#media-ctl -d $MEDIA_CTL_DEV -V "\"MAX9286-SERDES.25-0048\":3 [fmt:SGRBG8_1X8/1920x1080 field:none]"
#media-ctl -d $MEDIA_CTL_DEV -V "\"MAX9286-SERDES.25-0048\":4 [fmt:SGRBG8_1X8/1920x1080 field:none]"

# set CSI-2 Rx subsystem nodes
media-ctl -d $MEDIA_CTL_DEV -V "\"a0000000.mipi_csi2_rx_subsystem\":0 [fmt:SGRBG8_1X8/1920x1080 field:none]"
media-ctl -d $MEDIA_CTL_DEV -V "\"a0000000.mipi_csi2_rx_subsystem\":1 [fmt:SGRBG8_1X8/1920x1080 field:none]"

# set AXI switch nodes
media-ctl -d $MEDIA_CTL_DEV -V "\"amba_pl@0:axis_switch_fmc_quad_\":0 [fmt:SGRBG8_1X8/1920x1080 field:none]"
media-ctl -d $MEDIA_CTL_DEV -V "\"amba_pl@0:axis_switch_fmc_quad_\":1 [fmt:SGRBG8_1X8/1920x1080 field:none]"
media-ctl -d $MEDIA_CTL_DEV -V "\"amba_pl@0:axis_switch_fmc_quad_\":2 [fmt:SGRBG8_1X8/1920x1080 field:none]"
media-ctl -d $MEDIA_CTL_DEV -V "\"amba_pl@0:axis_switch_fmc_quad_\":3 [fmt:SGRBG8_1X8/1920x1080 field:none]"
media-ctl -d $MEDIA_CTL_DEV -V "\"amba_pl@0:axis_switch_fmc_quad_\":4 [fmt:SGRBG8_1X8/1920x1080 field:none]"

#set Demosaic 0 node
media-ctl -d $MEDIA_CTL_DEV -V "\"b0040000.v_demosaic\":0 [fmt:SGRBG8_1X8/1920x1080 field:none]"
media-ctl -d $MEDIA_CTL_DEV -V "\"b0040000.v_demosaic\":1 [fmt:RBG888_1X24/1920x1080 field:none]"

#set Demosaic 1 node
media-ctl -d $MEDIA_CTL_DEV -V "\"b0070000.v_demosaic\":0 [fmt:SGRBG8_1X8/1920x1080 field:none]"
media-ctl -d $MEDIA_CTL_DEV -V "\"b0070000.v_demosaic\":1 [fmt:RBG888_1X24/1920x1080 field:none]"

#set Demosaic 2 node
media-ctl -d $MEDIA_CTL_DEV -V "\"b01d0000.v_demosaic\":0 [fmt:SGRBG8_1X8/1920x1080 field:none]"
media-ctl -d $MEDIA_CTL_DEV -V "\"b01d0000.v_demosaic\":1 [fmt:RBG888_1X24/1920x1080 field:none]"

#set Demosaic 3 node
media-ctl -d $MEDIA_CTL_DEV -V "\"b01f0000.v_demosaic\":0 [fmt:SGRBG8_1X8/1920x1080 field:none]"
media-ctl -d $MEDIA_CTL_DEV -V "\"b01f0000.v_demosaic\":1 [fmt:RBG888_1X24/1920x1080 field:none]"

#set scaler 0 node
media-ctl -d $MEDIA_CTL_DEV -V "\"b0000000.v_proc_ss\":0 [fmt:RBG888_1X24/1920x1080 field:none]"
media-ctl -d $MEDIA_CTL_DEV -V "\"b0000000.v_proc_ss\":1 [fmt:RBG888_1X24/960x540 field:none]"

#set scaler 1 node
media-ctl -d $MEDIA_CTL_DEV -V "\"b0010000.v_proc_ss\":0 [fmt:RBG888_1X24/1920x1080 field:none]"
media-ctl -d $MEDIA_CTL_DEV -V "\"b0010000.v_proc_ss\":1 [fmt:RBG888_1X24/960x540 field:none]"

#set scaler 2 node
media-ctl -d $MEDIA_CTL_DEV -V "\"b0020000.v_proc_ss\":0 [fmt:RBG888_1X24/1920x1080 field:none]"
media-ctl -d $MEDIA_CTL_DEV -V "\"b0020000.v_proc_ss\":1 [fmt:RBG888_1X24/960x540 field:none]"

#set scaler 3 node
media-ctl -d $MEDIA_CTL_DEV -V "\"b0030000.v_proc_ss\":0 [fmt:RBG888_1X24/1920x1080 field:none]"
media-ctl -d $MEDIA_CTL_DEV -V "\"b0030000.v_proc_ss\":1 [fmt:RBG888_1X24/960x540 field:none]"

#set csc 0 node
media-ctl -d $MEDIA_CTL_DEV -V "\"b0080000.v_proc_ss\":0 [fmt:RBG888_1X24/960x540 field:none]"
media-ctl -d $MEDIA_CTL_DEV -V "\"b0080000.v_proc_ss\":1 [fmt:UYVY8_1X16/960x540 field:none]"

#set csc 1 node
media-ctl -d $MEDIA_CTL_DEV -V "\"b00c0000.v_proc_ss\":0 [fmt:RBG888_1X24/960x540 field:none]"
media-ctl -d $MEDIA_CTL_DEV -V "\"b00c0000.v_proc_ss\":1 [fmt:UYVY8_1X16/960x540 field:none]"

#set csc 2 node
media-ctl -d $MEDIA_CTL_DEV -V "\"b0100000.v_proc_ss\":0 [fmt:RBG888_1X24/960x540 field:none]"
media-ctl -d $MEDIA_CTL_DEV -V "\"b0100000.v_proc_ss\":1 [fmt:UYVY8_1X16/960x540 field:none]"

#set csc 3 node
media-ctl -d $MEDIA_CTL_DEV -V "\"b0140000.v_proc_ss\":0 [fmt:RBG888_1X24/960x540 field:none]"
media-ctl -d $MEDIA_CTL_DEV -V "\"b0140000.v_proc_ss\":1 [fmt:UYVY8_1X16/960x540 field:none]"
