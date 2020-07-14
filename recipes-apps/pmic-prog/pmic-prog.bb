#
# This is the pmic-prog application recipe
#
#

SUMMARY = "pmic-prog application"
SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

DEPENDS = "i2c-tools"

SRC_URI = "git://github.com/Avnet/BSP-rootfs-sources.git;protocol=https;branch=${SRCBRANCH};subpath=${SUBPATH};"

SRCREV = "${AUTOREV}"

SRCBRANCH ?= "master"
SUBPATH = "pmic-prog"
S = "${WORKDIR}/${SUBPATH}"

inherit pkgconfig cmake

do_install() {
        install -d ${D}${bindir}
        install -m 0755 ${B}/pmic_prog ${D}${bindir}
}

