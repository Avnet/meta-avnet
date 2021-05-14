require recipes-core/images/avnet-image-common.inc

# append what's already defined by petalinux (build/conf/plnxtool.conf)

IMAGE_INSTALL_append_zynq = "\
        bc \
        bonnie++ \
        bridge-utils \
        coreutils \
        ethtool \
        haveged \
        hdparm \
        i2c-tools \
        i2c-tools-misc \
        i2csensor \
        iperf3 \
        iw \
        kernel-modules \
        mtd-utils \
        nano \
        opencl-clhpp-dev \
        opencl-headers-dev \
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
        xrt \
        xrt-dev \
        zocl \
"

IMAGE_INSTALL_append_zynqmp = "\
        bc \
        bonnie++ \
        bridge-utils \
        cmake \
        coreutils \
        dnf \
        e2fsprogs \
        e2fsprogs-resize2fs \
        e2fsprogs-e2fsck \
        e2fsprogs-mke2fs \
        ethtool \
        fpga-manager-script \
        haveged \
        hdparm \
        hellopm \
        i2c-tools \
        i2c-tools-misc \
        iperf3 \
        json-c \
        kernel-modules \
        libpython3 \
        lmsensors-sensorsdetect \
        mesa-megadriver \
        mtd-utils \
        nano \
        opencl-clhpp-dev \
        opencl-headers-dev \
        openssh \
        openssh-scp \
        openssh-sftp-server \
        openssh-sshd \
        packagegroup-petalinux-gstreamer \
        packagegroup-petalinux-lmsensors \
        packagegroup-petalinux-matchbox \
        packagegroup-petalinux-opencv \
        packagegroup-petalinux-opencv-dev \
        packagegroup-petalinux-python-modules \
        packagegroup-petalinux-self-hosted \
        packagegroup-petalinux-v4lutils \
        packagegroup-petalinux-vitisai \
        packagegroup-petalinux-vitisai-dev \
        packagegroup-petalinux-x11 \
        parted \
        pciutils \
        pmic-prog \
        python3 \
        python3-pip \
        python-pyserial \
        run-postinsts \
        tcf-agent \
        udev-extraconf \
        usbutils \
        util-linux-mkfs \
        watchdog-init \
        xrt \
        xrt-dev \
        zocl \
"

IMAGE_INSTALL_append_u96v2-sbc = "\
        bluez5 \
        git \
        iw \
        libftdi \
        openamp-fw-echo-testd \
        openamp-fw-mat-muld \
        openamp-fw-rpc-demo \
        packagegroup-base-extended \
        packagegroup-petalinux \
        packagegroup-petalinux-96boards-sensors \
        packagegroup-petalinux-benchmarks \
        packagegroup-petalinux-openamp \
        packagegroup-petalinux-ultra96-webapp \
        packagegroup-petalinux-utils \
        ultra96-ap-setup \
        ultra96-misc \
        ultra96-radio-leds \
        ultra96-wpa \
        usb-gadget-ethernet \
        wilc3000-fw \
        wilc \
"

IMAGE_INSTALL_append_uz = "\
        blinky \
        blinky-init \
        libdrm \
        libdrm-kms \
        libdrm-tests \
        libstdc++ \
        libv4l \
        mac-eeprom-config \
        mac-eeprom-config-init \
        media-ctl \
        pciutils \
        performance-tests \
        python-webserver \
        python-webserver-init \
        python3 \
        python3-core \
        python3-dbus \
        python3-pygobject \
        yavta \
"

IMAGE_INSTALL_append_uz7ev-evcc = "\
        user-led-test \
        user-switch-test \
"

IMAGE_INSTALL_remove_uz7ev-evcc-hdmi = "\
        blinky \
        blinky-init \
        python-webserver \
        python-webserver-init \
        user-led-test \
        user-switch-test \
"

IMAGE_INSTALL_append_uz7ev-evcc-hdmi = "\
    hdmi-utils \
    kernel-module-hdmi \
"

IMAGE_INSTALL_append_minized-sbc = "\
        bluez5 \
        bluez5-doc \
        bluez5-obex \
        bridge-utils \
        dialog-control \
        e2fsprogs \
        e2fsprogs-resize2fs \
        e2fsprogs-e2fsck \
        e2fsprogs-mke2fs \
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
        parted \
        pulseaudio-misc \
        pulseaudio-module-bluetooth-discover \
        pulseaudio-module-bluetooth-policy \
        pulseaudio-module-bluez5-device \
        pulseaudio-module-bluez5-discover \
        pulseaudio-module-switch-on-connect \
        pulseaudio-server \
        pulseaudio \
        util-linux-mkfs \
        wpa-supplicant \
"

IMAGE_INSTALL_append_mz = "\
"

IMAGE_INSTALL_append_pz = "\
        blinky-init \
        blinky \
        mac-eeprom-config-init \
        mac-eeprom-config \
        mtd-utils \
        e2fsprogs \
        e2fsprogs-resize2fs \
        e2fsprogs-e2fsck \
        e2fsprogs-mke2fs \
        parted \
        pciutils \
        performance-tests \
        python-webserver-init \
        python-webserver \
        python3 \
        python3-core \
        python3-dbus \
        python3-pygobject \
        run-postinsts \
        tcf-agent \
        udev-extraconf \
        util-linux-mkfs \
"

COMMON_FEATURES_append_zynqmp = "\
        debug-tweaks \
        hwcodecs \
        package-management \
        ssh-server-openssh \
"

COMMON_FEATURES_append_zynq = "\
        debug-tweaks \
        hwcodecs \
        ssh-server-openssh \
"

