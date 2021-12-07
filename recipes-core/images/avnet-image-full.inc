require recipes-core/images/avnet-image-minimal.inc

IMAGE_INSTALL_append_zynq = "\
        bc \
        bonnie++ \
        bridge-utils \
        coreutils \
        ethtool \
        gpio-utils \
        hdparm \
        i2c-tools \
        i2c-tools-misc \
        iperf3 \
        iw \
        kernel-modules \
        nano \
        opencl-clhpp-dev \
        opencl-headers-dev \
        openssh \
        openssh-scp \
        openssh-sftp-server \
        openssh-sshd \
        python-webserver-init \
        python-webserver \
        python3 \
        python3-core \
        python3-dbus \
        python3-pygobject \
        sbc \
        usbutils \
        xrt \
        xrt-dev \
        zocl \
"

IMAGE_INSTALL_append_zynqmp = "\
        bridge-utils \
        cmake \
        dnf \
        gpio-utils \
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
        packagegroup-petalinux-display-debug \
        packagegroup-petalinux-gstreamer \
        packagegroup-petalinux-matchbox \
        packagegroup-petalinux-opencv-dev \
        packagegroup-petalinux-opencv \
        packagegroup-petalinux-python-modules \
        packagegroup-petalinux-self-hosted \
        packagegroup-petalinux-v4lutils \
        packagegroup-petalinux-vitisai-dev \
        packagegroup-petalinux-vitisai \
        packagegroup-petalinux-x11 \
        pciutils \
        python-pyserial \
        python3 \
        python3-pip \
        xrt \
        xrt-dev \
        zocl \
"

IMAGE_INSTALL_remove_zynqmp = "\
        packagegroup-core-ssh-dropbear \
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
        dialog-control \
        get-gpio-offsets \
        glibc \
        hostapd \
        i2csensor \
        libogg \
        libpulse \
        libpulsecommon \
        libpulsecore \
        libvorbis \
        lis2ds \
        minized-misc \
        minized-wireless \
        pulseaudio \
        pulseaudio-misc \
        pulseaudio-module-bluetooth-discover \
        pulseaudio-module-bluetooth-policy \
        pulseaudio-module-bluez5-device \
        pulseaudio-module-bluez5-discover \
        pulseaudio-module-switch-on-connect \
        pulseaudio-server \
        wpa-supplicant \
"

IMAGE_INSTALL_append_mz = "\
"

IMAGE_INSTALL_append_pz = "\
        haveged \
        pciutils \
        performance-tests \
        util-linux-mkfs \
"

COMMON_FEATURES_remove_zynqmp = "\
        ssh-server-dropbear \
"

COMMON_FEATURES_remove_zynq = "\
        ssh-server-dropbear \
"

COMMON_FEATURES_append_zynqmp = "\
        ssh-server-openssh \
"

COMMON_FEATURES_append_zynq = "\
        ssh-server-openssh \
"
