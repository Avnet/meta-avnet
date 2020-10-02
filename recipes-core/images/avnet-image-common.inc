require recipes-core/images/petalinux-image-common.inc

# append what's already defined by petalinux (build/conf/plnxtool.conf)
IMAGE_INSTALL_append_zynqmp = "\
        bc \
        bonnie++ \
        bridge-utils \
        can-utils \
        coreutils \
        ethtool \
        fpga-manager-script \
        haveged \
        hellopm \
        i2c-tools \
        iperf3 \
        json-c \
        kernel-modules \
        lmsensors-sensorsdetect \
        mtd-utils \
        nano \
        openssh-sftp-server \
        packagegroup-core-boot \
        packagegroup-core-ssh-dropbear \
        packagegroup-petalinux-gstreamer \
        packagegroup-petalinux-lmsensors \
        packagegroup-petalinux-matchbox \
        packagegroup-petalinux-opencv \
        packagegroup-petalinux-v4lutils \
        packagegroup-petalinux-x11 \
        pciutils \
        pmic-prog \
        run-postinsts \
        sds-lib \
        tcf-agent \
        udev-extraconf \
        usbutils \
        watchdog-init \
        xrt \
        xrt-dev \
        zocl \
"

IMAGE_INSTALL_append_ultra96v2 = "\
        bluez5 \
        cmake \
        git \
        iw \
        libftdi \
        libpython3 \
        openamp-fw-echo-testd \
        openamp-fw-mat-muld \
        openamp-fw-rpc-demo \
        opencl-clhpp-dev \
        opencl-headers-dev \
        packagegroup-base-extended \
        packagegroup-petalinux \
        packagegroup-petalinux-96boards-sensors \
        packagegroup-petalinux-benchmarks \
        packagegroup-petalinux-openamp \
        packagegroup-petalinux-python-modules \
        packagegroup-petalinux-self-hosted \
        packagegroup-petalinux-ultra96-webapp \
        packagegroup-petalinux-utils \
        python3-pip \
        python-pyserial \
        ultra96-ap-setup \
        ultra96-misc \
        ultra96-radio-leds \
        ultra96-wpa \
        usb-gadget-ethernet \
        usb-gadget-ethernet-init \
        wilc3000-fw \
        wilc \
"

IMAGE_INSTALL_append_uz = "\
        blinky \
        blinky-init \
        e2fsprogs-resize2fs \
        hdparm \
        i2c-tools-misc \
        libdrm \
        libdrm-kms \
        libdrm-tests \
        libstdc++ \
        libv4l \
        mac-eeprom-config \
        mac-eeprom-config-init \
        media-ctl \
        parted \
        performance-tests \
        python3 \
        python3-core \
        python3-dbus \
        python3-pygobject \
        python-webserver \
        python-webserver-init \
        yavta \
"

IMAGE_INSTALL_append_uz7ev-evcc = "\
        user-led-test \
        user-switch-test \
"

COMMON_FEATURES_append_ultra96v2 = "\
        package-management \
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
        bonnie++ \
        bridge-utils \
        can-utils \
        haveged \
        iperf3 \
        kernel-modules \
        mtd-utils \
        openssh-sftp-server \
        packagegroup-core-boot \
        packagegroup-core-ssh-dropbear \
        pciutils \
        run-postinsts \
        tcf-agent \
        udev-extraconf \
"
COMMON_FEATURES_append_mz = "\
        hwcodecs \
        ssh-server-dropbear \
"

IMAGE_INSTALL_append_pz = "\
        e2fsprogs \
        e2fsprogs-resize2fs \
        e2fsprogs-e2fsck \
        e2fsprogs-mke2fs \
        parted \
        util-linux-mkfs \
"
