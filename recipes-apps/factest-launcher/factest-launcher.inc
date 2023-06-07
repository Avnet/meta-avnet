SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit update-rc.d systemd

SRC_URI = "file://factest-launcher.sh \
		   file://factest-launcher \
		   file://factest-launcher.service \
		  "

S = "${WORKDIR}"

INITSCRIPT_PACKAGES = "${PN}"
INITSCRIPT_NAME = "factest-launcher"
INITSCRIPT_PARAMS:${PN} = "start 99 5 ."

SYSTEMD_PACKAGES="${PN}"
SYSTEMD_SERVICE:${PN}="factest-launcher.service"
SYSTEMD_AUTO_ENABLE:${PN}="enable"

do_install() {
		install -d ${D}${ROOT_HOME}
		install -m 0755 factest-launcher.sh ${D}${ROOT_HOME}/

		install -d ${D}${sysconfdir}/init.d
		install -m 0755 ${S}/factest-launcher ${D}${sysconfdir}/init.d/factest-launcher

		if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
			install -d ${D}${systemd_system_unitdir}
			install -m 0644 ${WORKDIR}/factest-launcher.service ${D}${systemd_system_unitdir}
		fi
}

FILES:${PN} += "${ROOT_HOME} \
			"
