#
# This file is the factest recipe.
#

SUMMARY = "Factory Acceptance Tests scripts"
SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

COMPATIBLE_MACHINE = "zub1cg-sbc|mz-iocc"

RDEPENDS:${PN} += "gpio-utils bash"

SRC_URI = " file://factest.sh \
			file://szg_lb_test.sh \
			file://click_test.sh \
			file://internal_sensors_test.sh \
			file://buttons_and_leds_test.sh \
			file://ethernet_test.sh \
			file://usb_test.sh \
			file://rtc_test.sh \
			file://sysmon_test.sh \
			file://sysmon.conf \
			"

S = "${WORKDIR}"

do_install() {
		install -d ${D}/home/root
		install -m 0755 factest.sh ${D}/home/root
		install -d ${D}/home/root/factest_scripts/
		install -m 0755 szg_lb_test.sh ${D}/home/root/factest_scripts/
		install -m 0755 click_test.sh ${D}/home/root/factest_scripts/
		install -m 0755 internal_sensors_test.sh ${D}/home/root/factest_scripts/
		install -m 0755 buttons_and_leds_test.sh ${D}/home/root/factest_scripts/
		install -m 0755 ethernet_test.sh ${D}/home/root/factest_scripts/
		install -m 0755 usb_test.sh ${D}/home/root/factest_scripts/
		install -m 0755 rtc_test.sh ${D}/home/root/factest_scripts/
		install -m 0755 sysmon_test.sh ${D}/home/root/factest_scripts/
		install -m 0755 sysmon.conf ${D}/home/root/factest_scripts/
}

FILES:${PN} += "/home/root/factest.sh \
				/home/root/factest_scripts/szg_lb_test.sh \
				/home/root/factest_scripts/click_test.sh \
				/home/root/factest_scripts/internal_sensors_test.sh \
				/home/root/factest_scripts/buttons_and_leds_test.sh \
				/home/root/factest_scripts/ethernet_test.sh \
				/home/root/factest_scripts/usb_test.sh \
				/home/root/factest_scripts/rtc_test.sh \
				/home/root/factest_scripts/sysmon_test.sh \
				/home/root/factest_scripts/sysmon.conf \
				"
