SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

RDEPENDS:${PN} += "gpio-utils bash python3-ansi2html "

S = "${WORKDIR}"
SCRIPT_LOC = "factest_scripts"

do_install() {
	install -d ${D}/home/root/
	install -m 0755 factest.sh ${D}/home/root/
	install -d ${D}/home/root/${SCRIPT_LOC}/
	install -m 0755 ${S}/${SCRIPT_LOC}/* ${D}/home/root/${SCRIPT_LOC}/
}

FILES:${PN} += "${ROOT_HOME} \
			"
