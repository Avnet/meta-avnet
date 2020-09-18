#
# This file is the usb-gadget-ethernet-init recipe.
#

SUMMARY = "Simple usb-gadget-ethernet-init application"
SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

COMPATIBLE_MACHINE = "ultra96"

SRC_URI = "file://usb-gadget-ethernet-init \
		  "

S = "${WORKDIR}"

inherit update-rc.d

INITSCRIPT_NAME = "usb-gadget-ethernet-init"
INITSCRIPT_PARAMS = "start 99 S ."


do_install() {
    install -d ${D}${sysconfdir}/init.d
    install -m 0755 ${S}/usb-gadget-ethernet-init ${D}${sysconfdir}/init.d/usb-gadget-ethernet-init
}

FILES_${PN} += "${sysconfdir}/*"
