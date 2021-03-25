#!/bin/sh

source /etc/profile

# Adjust alpha instead of killing x11
modetest-hdmi -w 42:alpha:0

        
 gst-launch-1.0 \
     v4l2src device=/dev/video2 io-mode=4 ! \
     video/x-raw, width=1920, height=1080, format=UYVY, framerate=30/1 ! \
     fpsdisplaysink video-sink="kmssink bus-id=b0050000.v_mix plane-id=34 \
     render-rectangle=\"<0,0,1920,1080>\"" sync=false can-scale=false  \
     \
     v4l2src device=/dev/video3 io-mode=4 ! \
     video/x-raw, width=1920, height=1080, format=UYVY, framerate=30/1 ! \
     fpsdisplaysink video-sink="kmssink bus-id=b0050000.v_mix plane-id=35 \
     render-rectangle=\"<1920,0,1920,1080>\"" sync=false can-scale=false  \
     \
     v4l2src device=/dev/video4 io-mode=4 ! \
     video/x-raw, width=1920, height=1080, format=UYVY, framerate=30/1 ! \
     fpsdisplaysink video-sink="kmssink bus-id=b0050000.v_mix plane-id=36 \
     render-rectangle=\"<0,1080,1920,1080>\"" sync=false can-scale=false  \
     \
     v4l2src device=/dev/video5 io-mode=4 ! \
     video/x-raw, width=1920, height=1080, format=UYVY, framerate=30/1 ! \
     fpsdisplaysink video-sink="kmssink bus-id=b0050000.v_mix plane-id=37 \
     render-rectangle=\"<1920,1080,1920,1080>\"" sync=false can-scale=false \
     \
     -v
    
modetest-hdmi -w 42:alpha:256
