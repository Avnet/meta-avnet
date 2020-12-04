require recipes-core/images/petalinux-image-common.inc

IMAGE_INSTALL_append_uz7ev-evcc-hdmi = "\
    packagegroup-hdmi-utils \
	packagegroup-petalinux-xrt \
	xrt-dev \
	dnf \
	e2fsprogs-resize2fs \
	parted \
	packagegroup-petalinux-vitisai \
"
