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

SRC_URI_append_uz = " file://pmic-configs/"
SRC_URI_append_ultra96v2 = " file://pmic-configs/"

SRCREV = "${AUTOREV}"

SRCBRANCH ?= "master"
SUBPATH = "pmic-prog"
S = "${WORKDIR}/${SUBPATH}"

inherit pkgconfig cmake

FILES_${PN} += "${ROOT_HOME}/${SUBPATH}/*"

do_install() {
        install -d ${D}${ROOT_HOME}/${SUBPATH}
        install -m 0755 ${B}/pmic_prog ${D}${ROOT_HOME}/${SUBPATH}/
}

do_install_append_uz() {
        cp -r ${WORKDIR}/pmic-configs ${D}${ROOT_HOME}/${SUBPATH}/
}

do_install_append_ultra96v2() {
        cp -r ${WORKDIR}/pmic-configs ${D}${ROOT_HOME}/${SUBPATH}/
}

