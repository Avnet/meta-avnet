#@TYPE: Machine
#@NAME: k24
#@DESCRIPTION: Generic support for K24.
#

SOC_VARIANT = "eg"

MACHINEOVERRIDES =. "k24:"

require conf/machine/include/k24-sm.inc

EXTRA_IMAGEDEPENDS += " \
		arm-trusted-firmware \
		virtual/bootloader \
		u-boot-xlnx-scr \
		virtual/fsbl \
		virtual/pmu-firmware \
		avnet-boot-scr \
		"

# Used to create a wic image to boot from sd
IMAGE_BOOT_FILES = " \
                    boot.bin \
                    boot.scr \
                    fitImage;image.ub \
                    "

WKS_FILES = "petalinux-image-minimal.wks"

# deploy avnet-boot-scr scripts in images/linux/ folder
EXTRA_FILESLIST:append = " ${DEPLOY_DIR_IMAGE}/avnet-boot/:avnet-boot/ "

EXTRA_IMAGEDEPENDS:remove = "qemu-devicetrees"

DISTRO_FEATURES:append = " dbus"

PACKAGE_FEED_URIS = "http://petalinux.xilinx.com/sswreleases/sswboardfeeds/"
PACKAGE_FEED_BASE_PATHS = "zzsoc"
PACKAGE_FEED_ARCHS = "all aarch64 plnx_aarch64"
