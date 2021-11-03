#
# This file is the edge-impulse recipe.
#

SUMMARY = "Simple edge-impulse install/start"
SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = " \
    file://edge-impulse.sh \
"

RDEPENDS_${PN} += " \
    packagegroup-core-buildessential \
    packagegroup-petalinux-audio \
    packagegroup-petalinux-mraa \
    packagegroup-petalinux-multimedia \
"

do_install() {
    install -d ${D}/home/root/
    install -m 755 ${WORKDIR}/edge-impulse.sh ${D}/home/root/
}

FILES_${PN} = " \
    /home/root/edge-impulse.sh \
"
