require recipes-core/images/avnet-image-common.inc

# append what's already defined by petalinux (build/conf/plnxtool.conf)

IMAGE_INSTALL_append_zynq = "\
        bc \
        bridge-utils \
        coreutils \
        haveged \
        i2c-tools \
        i2c-tools-misc \
        i2csensor \
        iperf3 \
        iw \
        kernel-modules \
        mtd-utils \
        nano \
        openssh \
        openssh-scp \
        openssh-sftp-server \
        openssh-sshd \
        packagegroup-core-boot \
        run-postinsts \
        sbc \
        tcf-agent \
        udev-extraconf \
        usbutils \
"

IMAGE_INSTALL_append_minized = "\
        bluez5 \
        bluez5-doc \
        bluez5-obex \
        bridge-utils \
        dialog-control \
        get-gpio-offsets \
        glibc \
        hostapd \
        libogg \
        libpulse \
        libpulsecommon \
        libpulsecore \
        libvorbis \
        lis2ds \
        minized-misc \
        minized-wireless \
        pulseaudio-misc \
        pulseaudio-module-bluetooth-discover \
        pulseaudio-module-bluetooth-policy \
        pulseaudio-module-bluez5-device \
        pulseaudio-module-bluez5-discover \
        pulseaudio-module-switch-on-connect \
        pulseaudio-server \
        pulseaudio \
        wpa-supplicant \
"

IMAGE_INSTALL_append_mz = "\
        bonnie++ \
        ethtool \
        hdparm \
"

IMAGE_INSTALL_append_pz = "\
        blinky-init \
        blinky \
        bonnie++ \
        ethtool \
        hdparm \
        mac-eeprom-config-init \
        mac-eeprom-config \
        pciutils \
        performance-tests \
        python-webserver-init \
        python-webserver \
        python3 \
        python3-core \
        python3-dbus \
        python3-pygobject \
"

COMMON_FEATURES_append_zynq = "\
        hwcodecs \
        ssh-server-openssh \
"

