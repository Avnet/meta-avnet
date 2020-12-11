require recipes-core/images/petalinux-image-common.inc

# append what's already defined by petalinux (build/conf/plnxtool.conf)
IMAGE_INSTALL_append_zynq = "\
        haveged \
        opencl-clhpp-dev \
        opencl-headers-dev \
        packagegroup-core-boot \
        xrt \
        xrt-dev \
        zocl \
"

IMAGE_INSTALL_append_zynqmp = "\
        bc \
        bonnie++ \
        coreutils \
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
        kernel-modules \
        mtd-utils \
        nano \
        packagegroup-core-boot \
        packagegroup-core-ssh-dropbear \
        packagegroup-petalinux-lmsensors \
        parted \
        pmic-prog \
        run-postinsts \
        tcf-agent \
        udev-extraconf \
        usbutils \
        util-linux-mkfs \
        watchdog-init \
"

IMAGE_INSTALL_append_ultra96v2 = "\
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

IMAGE_INSTALL_append_minized = "\
        e2fsprogs \
        e2fsprogs-resize2fs \
        e2fsprogs-e2fsck \
        e2fsprogs-mke2fs \
        parted \
        util-linux-mkfs \
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
        i2c-tools \
        i2c-tools-misc \
        parted \
        pciutils \
        run-postinsts \
        tcf-agent \
        udev-extraconf \
        util-linux-mkfs \
"

COMMON_FEATURES_append_zynqmp = "\
        debug-tweaks \
        hwcodecs \
        package-management \
        ssh-server-dropbear \
"

COMMON_FEATURES_append_zynq = "\
        hwcodecs \
        ssh-server-dropbear \
"

