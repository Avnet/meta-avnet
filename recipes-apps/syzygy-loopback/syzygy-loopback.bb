#
# This file is the syzygy-loopback recipe.
#

SUMMARY = "Simple syzygy-loopback application"
SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

COMPATIBLE_MACHINE = "zub1cg-sbc"

SRC_URI = "file://szg_lb_test.sh \
		  "

S = "${WORKDIR}"

do_install() {
	     install -d ${D}/home/root
	     install -m 0755 szg_lb_test.sh ${D}/home/root
}

FILES_${PN} += "/home/root/szg_lb_test.sh \
               "
