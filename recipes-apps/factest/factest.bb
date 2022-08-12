#
# This file is the factest recipe.
#

SUMMARY = "Factory Acceptance Tests scripts"
SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

COMPATIBLE_MACHINE = "zub1cg-sbc"

RDEPENDS_${PN} += "gpio-utils"

SRC_URI = " file://factest.sh \
			file://szg_lb_test.sh \
			file://click_test.sh \
			file://internal_sensors_test.sh \
			"

S = "${WORKDIR}"

do_install() {
	     install -d ${D}/home/root
	     install -m 0755 factest.sh ${D}/home/root
	     install -m 0755 szg_lb_test.sh ${D}/home/root
	     install -m 0755 click_test.sh ${D}/home/root
	     install -m 0755 internal_sensors_test.sh ${D}/home/root
}

FILES_${PN} += "/home/root/factest.sh \
				/home/root/szg_lb_test.sh \
				/home/root/click_test.sh \
				/home/root/internal_sensors_test.sh \
				"
