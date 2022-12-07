#
# This file is the factest-launcher recipe.
#

SUMMARY = "Simple factest-launcher application"
SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit update-rc.d systemd

SRC_URI = "file://factest-launcher.sh \
		   file://factest-init \
		   file://factest-launcher.service \
		  "

S = "${WORKDIR}"

RDEPENDS:${PN} = "factest oob-image"
RCONFLICTS:${PN} = "blinky"

INITSCRIPT_NAME = "factest-init"
INITSCRIPT_PARAMS = "start 99 5 ."

SYSTEMD_PACKAGES="${PN}"
SYSTEMD_SERVICE:${PN}="factest-launcher.service"
SYSTEMD_AUTO_ENABLE:${PN}="enable"

do_install() {
		install -d ${D}/home/root
		install -m 0755 factest-launcher.sh ${D}/home/root

		if ${@bb.utils.contains('DISTRO_FEATURES', 'sysvinit', 'true', 'false', d)}; then
			install -d ${D}${sysconfdir}/init.d
			install -m 0755 ${S}/factest-init ${D}${sysconfdir}/init.d/factest-init
		fi

		if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
			install -d ${D}${systemd_system_unitdir}
			install -m 0644 ${WORKDIR}/factest-launcher.service ${D}${systemd_system_unitdir}
		fi
}

FILES:${PN} += "/home/root/factest-launcher.sh \
				${@bb.utils.contains('DISTRO_FEATURES','sysvinit','${sysconfdir}/init.d/factest-init', '', d)} \
				${@bb.utils.contains('DISTRO_FEATURES','systemd','${systemd_system_unitdir}/factest-launcher.service', '', d)} \
			"
