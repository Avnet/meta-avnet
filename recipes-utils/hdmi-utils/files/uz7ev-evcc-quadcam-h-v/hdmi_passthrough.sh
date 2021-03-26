#!/bin/sh

source /etc/profile

MEDIA_CTL_DEV="/dev/media2"
VIDEO_DEV="/dev/video6"

media-ctl -d $MEDIA_CTL_DEV -V '"b0180000.v_proc_ss":0 [fmt:RBG888_1X24/3840x2160 field:none]'
media-ctl -d $MEDIA_CTL_DEV -V '"b0180000.v_proc_ss":1 [fmt:VYYUYY8_1X24/3840x2160 field:none]'

sleep 1

gst-launch-1.0 -v  v4l2src device="${VIDEO_DEV}" ! "video/x-raw, framerate=60/1" ! kmssink bus-id="b0050000.v_mix" plane-id=34 sync=false can-scale=false
