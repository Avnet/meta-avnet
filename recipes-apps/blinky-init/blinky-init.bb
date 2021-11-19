#
# This file is the blinky-init recipe.
#

SUMMARY = "Simple blinky-init application"
SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

# pz7010 does not have a route to the ps led
COMPATIBLE_MACHINE = "uz|pz7015-fmc2|pz7020-fmc2|pz7030-fmc2"

SRC_URI = "file://blinky-init \
	"

S = "${WORKDIR}"

inherit update-rc.d

INITSCRIPT_NAME = "blinky-init"
INITSCRIPT_PARAMS = "start 99 S ."


do_install() {
    install -d ${D}${sysconfdir}/init.d
    install -m 0755 ${S}/blinky-init ${D}${sysconfdir}/init.d/blinky-init
}

FILES_${PN} += "${sysconfdir}/*"


