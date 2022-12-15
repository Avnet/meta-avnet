#
# This file is the factest-launcher recipe.
#

SUMMARY = "Simple factest-launcher application"
SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://factest-launcher.sh \
		  "

S = "${WORKDIR}"

RDEPENDS_${PN} = "factest oob-image"

do_install() {
	     install -d ${D}/home/root
	     install -m 0755 factest-launcher.sh ${D}/home/root
}

FILES_${PN} += "/home/root/factest-launcher.sh \
               "
