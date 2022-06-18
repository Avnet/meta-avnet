#
# This file is the icm42688-sysfs recipe.
#

SUMMARY = "Simple icm42688-sysfs application"
SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://test-sensors-sysfs.c \
      file://Makefile \
      file://invensense.mk \
        "

S = "${WORKDIR}"

do_compile() {
        oe_runmake
}

do_install() {
        install -d ${D}${bindir}
        install -m 0755 icm42688-sysfs ${D}${bindir}
}
