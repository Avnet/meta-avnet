#
# This file is the oob_image recipe.
#

SUMMARY = "Out Of the Box images and scripts"
SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

COMPATIBLE_MACHINE = "zub1cg-sbc"

RDEPENDS_${PN} += "bash"

SRC_URI = " file://flash-programming.sh \
		"

SRC_URI_append_zub1cg-sbc = " \
	https://github.com/Avnet/freertos-oob/releases/download/v1.3/BOOT.BIN;downloadfilename=BOOT.BIN \
"

SRC_URI[sha256sum] = "e65c97ec9705df9b6be343e2140af30539ee48b957e9b5159d72f1a93e47c51d"

S = "${WORKDIR}"

do_install() {
		install -d ${D}/home/root
		install -m 0755 flash-programming.sh ${D}/home/root
		install -d ${D}/home/root/oob_image/
		install -m 0444 BOOT.BIN ${D}/home/root/oob_image/
}

FILES_${PN} += "/home/root/flash-programming.sh \
				/home/root/oob_image/BOOT.BIN \
				"
