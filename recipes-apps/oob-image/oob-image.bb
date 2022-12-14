#
# This file is the oob_image recipe.
#

SUMMARY = "Out Of the Box images and scripts"
SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"



COMPATIBLE_MACHINE = "zub1cg-sbc"

RDEPENDS:${PN} += "bash"

SRC_URI = " file://flash-programming.sh \
		"

SRC_URI:append:zub1cg-sbc = " \
	https://github.com/Avnet/freertos-oob/releases/download/v1.1/BOOT.BIN;downloadfilename=BOOT.BIN \
"

SRC_URI[sha256sum] = "74d4150bd945b24bdeae20b3ee77f532c4e3462bf5e1f36909e401cea889d124"

S = "${WORKDIR}"

do_install() {
		install -d ${D}/home/root
		install -m 0755 flash-programming.sh ${D}/home/root
		install -d ${D}/home/root/oob_image/
		install -m 0444 BOOT.BIN ${D}/home/root/oob_image/
}

FILES:${PN} += "/home/root/flash-programming.sh \
				/home/root/oob_image/BOOT.BIN \
				"
