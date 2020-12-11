require recipes-core/images/petalinux-image-common.inc

IMAGE_INSTALL_append_uz7ev-evcc-hdmi = "\
    dnf \
    e2fsprogs-resize2fs \
    packagegroup-hdmi-utils \
    packagegroup-petalinux-matchbox \
    packagegroup-petalinux-vitisai \
    packagegroup-petalinux-xrt \
    parted \
    xrt-dev \
    xterm \
"
