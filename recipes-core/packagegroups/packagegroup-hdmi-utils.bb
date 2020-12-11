DESCRIPTION = "HDMI related Packages"

inherit packagegroup distro_features_check

APP_PACKAGES = " \
	kernel-module-hdmi \
	libv4l \
	media-ctl \
	ffmpeg \
	file \
	ldd \
	"

RDEPENDS_${PN}_append += " \
	packagegroup-core-tools-debug \
	packagegroup-petalinux-display-debug \
	packagegroup-petalinux-gstreamer \
	packagegroup-petalinux-v4lutils \
	packagegroup-petalinux-x11 \
	gstreamer1.0-plugins-good \
	packagegroup-petalinux-self-hosted \
	${APP_PACKAGES} \
	"
