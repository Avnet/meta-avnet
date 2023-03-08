#
# This file is the blinky recipe.
#

SUMMARY = "Simple blinky application"
SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://linux_ps_led_blink.c \
	file://Makefile \
	file://blinky.init \
	file://blinky.service \
	"

COMPATIBLE_MACHINE = "uz|pz|zub1cg-sbc"

S = "${WORKDIR}"

inherit systemd update-rc.d

INITSCRIPT_PACKAGES = "${PN}"
INITSCRIPT_NAME = "blinky"
INITSCRIPT_PARAMS:${PN} = "start 99 S ."

SYSTEMD_PACKAGES="${PN}"
SYSTEMD_SERVICE:${PN}="blinky.service"
SYSTEMD_AUTO_ENABLE:${PN}="enable"

DEPENDS:append = " gpio-utils"
RDEPENDS:${PN} += "gpio-utils"

do_install() {
	install -d ${D}/home/root
	install -m 0755 blinky ${D}/home/root

	install -d ${D}${sysconfdir}/init.d
	install -m 0755 ${S}/blinky.init ${D}${sysconfdir}/init.d/blinky
	if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
		install -d ${D}${systemd_system_unitdir}
		install -m 0644 ${S}/blinky.service ${D}${systemd_system_unitdir}
	fi
}

do_install:append:pz () {
	sed -i -e 's,^BOARD=.*,BOARD="PicoZed",; s,^LED_NAME=.*,LED_NAME="PS_LED1",;' ${D}${sysconfdir}/init.d/blinky
}
do_install:append:uz () {
	sed -i -e 's,^BOARD=.*,BOARD="UltraZed",; s,^LED_NAME=.*,LED_NAME="PS_LED1",;' ${D}${sysconfdir}/init.d/blinky
}
do_install:append:zub1cg-sbc () {
	sed -i -e 's,^BOARD=.*,BOARD="ZUBoard 1CG",; s,^LED_NAME=.*,LED_NAME="MIO_LED_1",;' ${D}${sysconfdir}/init.d/blinky
}

FILES:${PN} += " \
	/home/root/* \
	${sysconfdir}/* \
	${systemd_system_unitdir}/* \
"
