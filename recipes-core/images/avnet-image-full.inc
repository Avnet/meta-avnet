require recipes-core/images/avnet-image-minimal.inc

# append what's already defined by petalinux (build/conf/plnxtool.conf)

IMAGE_INSTALL_append_zynq = "\
        bc \
        bonnie++ \
        bridge-utils \
        coreutils \
        ethtool \
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
        bridge-utils \
        can-utils \
        cmake \
        dnf \
        json-c \
        libpython3 \
        lmsensors-sensorsdetect \
        mesa-megadriver \
        opencl-clhpp-dev \
        opencl-headers-dev \
        openssh \
        openssh-scp \
        openssh-sftp-server \
        openssh-sshd \
        packagegroup-petalinux-gstreamer \
        packagegroup-petalinux-matchbox \
        packagegroup-petalinux-opencv \
        packagegroup-petalinux-opencv-dev \
        packagegroup-petalinux-python-modules \
        packagegroup-petalinux-self-hosted \
        packagegroup-petalinux-v4lutils \
        packagegroup-petalinux-vitisai \
        packagegroup-petalinux-vitisai-dev \
        packagegroup-petalinux-x11 \
        pciutils \
        python3 \
        python3-pip \
        python-pyserial \
        sds-lib \
        xrt \
        xrt-dev \
        zocl \
"

IMAGE_INSTALL_remove_zynqmp = "\
        packagegroup-core-ssh-dropbear \
"

IMAGE_INSTALL_append_u96v2-sbc = "\
"

IMAGE_INSTALL_append_uz = "\
"

IMAGE_INSTALL_append_uz7ev-evcc = "\
"

IMAGE_INSTALL_append_minized-sbc = "\
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
        bridge-utils \
        iperf3 \
        kernel-modules \
        mtd-utils \
        openssh \
        openssh-scp \
        openssh-sftp-server \
        openssh-sshd \
        run-postinsts \
        tcf-agent \
        udev-extraconf \
"

IMAGE_INSTALL_append_pz = "\
        bonnie++ \
        bridge-utils \
        iperf3 \
        kernel-modules \
        openssh \
        openssh-scp \
        openssh-sftp-server \
        openssh-sshd \
        performance-tests \
        python-webserver-init \
        python-webserver \
        python3 \
        python3-core \
        python3-dbus \
        python3-pygobject \
"

COMMON_FEATURES_append_zynqmp = "\
"

COMMON_FEATURES_remove_zynqmp = "\
        ssh-server-dropbear \
"

COMMON_FEATURES_append_zynq = "\
        ssh-server-openssh \
"

COMMON_FEATURES_remove_zynq = "\
        ssh-server-dropbear \
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

