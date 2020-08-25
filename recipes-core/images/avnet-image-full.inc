require recipes-core/images/avnet-image-common.inc

# append what's already defined by petalinux (build/conf/plnxtool.conf)
IMAGE_INSTALL_append_zynq = "\
                bluez5 \
                bluez5-doc \
                bluez5-obex \
                bridge-utils \
                can-utils \
                dialog-control \
                get-gpio-offsets \
                i2c-tools-misc \
                i2c-tools \
                i2csensor \
                libogg \
                libpulse \
                libpulsecommon \
                libpulsecore \
                libvorbis \
                lis2ds \
                nano \
                openssh-sftp-server \
                packagegroup-core-ssh-dropbear \
                pciutils \
                pulseaudio-misc \
                pulseaudio-module-bluetooth-discover \
                pulseaudio-module-bluetooth-policy \
                pulseaudio-module-bluez5-device \
                pulseaudio-module-bluez5-discover \
                pulseaudio-module-switch-on-connect \
                pulseaudio-server \
                pulseaudio \
                sbc \
"

COMMON_FEATURES_append_zynq = "\
                hwcodecs \
                ssh-server-dropbear \
"
