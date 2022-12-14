#
# This file is the factest recipe.
#

SUMMARY = "Factory Acceptance Tests scripts"
SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

COMPATIBLE_MACHINE = "zub1cg-sbc|mz7020-iocc|mz7010-iocc"

RDEPENDS:${PN} += "gpio-utils bash python3-ansi2html "

# common factest source files for all machines
SRC_URI = "\
      file://factest.sh \
      file://buttons_and_leds_test.sh \
      file://ethernet_test.sh \
      file://qspi_utils.sh \
      file://sysmon.conf \
      file://sysmon_test.sh \
      file://usb_test.sh \
      "

# source files specific to the zub1cg-sbc machine
SRC_URI:append:zub1cg-sbc = "\
      file://click_test.sh \
      file://internal_sensors_test.sh \
      file://rtc_test.sh \
      file://szg_lb_test.sh \
      "

# source files specific to the mz7020-iocc machine
SRC_URI:append:mz7020-iocc = "\
      file://pmod_lb_test.sh \
      file://program_oob_qspi.sh \
      file://oob/boot.bin;unpack=0 \
      file://oob/devicetree.dtb \
      file://oob/system.bit.bin;unpack=0 \
      file://oob/uImage \
      file://oob/uramdisk.image.gz;unpack=0 \
      "

# source files specific to the mz7010-iocc machine
SRC_URI:append:mz7010-iocc = "\
      file://pmod_lb_test.sh \
      file://program_oob_qspi.sh \
      file://oob/boot.bin;unpack=0 \
      file://oob/devicetree.dtb \
      file://oob/system.bit.bin;unpack=0 \
      file://oob/uImage \
      file://oob/uramdisk.image.gz;unpack=0 \
      "

S = "${WORKDIR}"

do_install() {
      install -d ${D}/home/root/
      install -m 0755 factest.sh ${D}/home/root/
      install -d ${D}/home/root/factest_scripts/
      install -m 0755 buttons_and_leds_test.sh ${D}/home/root/factest_scripts/
      install -m 0755 ethernet_test.sh ${D}/home/root/factest_scripts/
      install -m 0755 qspi_utils.sh ${D}/home/root/factest_scripts/
      install -m 0755 sysmon.conf ${D}/home/root/factest_scripts/
      install -m 0755 sysmon_test.sh ${D}/home/root/factest_scripts/
      install -m 0755 usb_test.sh ${D}/home/root/factest_scripts/
}

do_install:append:zub1cg-sbc () {
      install -d ${D}/home/root/factest_scripts/
      install -m 0755 click_test.sh ${D}/home/root/factest_scripts/
      install -m 0755 internal_sensors_test.sh ${D}/home/root/factest_scripts/
      install -m 0755 rtc_test.sh ${D}/home/root/factest_scripts/
      install -m 0755 szg_lb_test.sh ${D}/home/root/factest_scripts/
}

do_install:append:mz7020-iocc () {
      install -d ${D}/home/root/oob/
      install -m 0755 ${S}/oob/boot.bin ${D}/home/root/oob/
      install -m 0755 ${S}/oob/devicetree.dtb ${D}/home/root/oob/
      install -m 0755 ${S}/oob/system.bit.bin ${D}/home/root/oob/
      install -m 0755 ${S}/oob/uImage ${D}/home/root/oob/
      install -m 0755 ${S}/oob/uramdisk.image.gz ${D}/home/root/oob/
      install -d ${D}/home/root/factest_scripts/
      install -m 0755 pmod_lb_test.sh ${D}/home/root/factest_scripts/
      install -m 0755 program_oob_qspi.sh ${D}/home/root/factest_scripts/
}

do_install:append:mz7010-iocc () {
      install -d ${D}/home/root/oob/
      install -m 0755 ${S}/oob/boot.bin ${D}/home/root/oob/
      install -m 0755 ${S}/oob/devicetree.dtb ${D}/home/root/oob/
      install -m 0755 ${S}/oob/system.bit.bin ${D}/home/root/oob/
      install -m 0755 ${S}/oob/uImage ${D}/home/root/oob/
      install -m 0755 ${S}/oob/uramdisk.image.gz ${D}/home/root/oob/
      install -d ${D}/home/root/factest_scripts/
      install -m 0755 pmod_lb_test.sh ${D}/home/root/factest_scripts/
      install -m 0755 program_oob_qspi.sh ${D}/home/root/factest_scripts/
}

FILES:${PN} += "\
      /home/root/factest.sh\
      /home/root/factest_scripts/buttons_and_leds_test.sh \
      /home/root/factest_scripts/ethernet_test.sh \
      /home/root/factest_scripts/qspi_utils.sh \
      /home/root/factest_scripts/sysmon.conf \
      /home/root/factest_scripts/sysmon_test.sh \
      /home/root/factest_scripts/usb_test.sh \
      "

FILES:${PN}:append:zub1cg-sbc = "\
      /home/root/factest_scripts/click_test.sh \
      /home/root/factest_scripts/internal_sensors_test.sh \
      /home/root/factest_scripts/rtc_test.sh \
      /home/root/factest_scripts/szg_lb_test.sh \
      "

FILES:${PN}:append:mz7020-iocc = "\
      /home/root/factest_scripts/pmod_lb_test.sh \
      /home/root/factest_scripts/program_oob_qspi.sh \
      /home/root/oob/boot.bin \
      /home/root/oob/devicetree.dtb \
      /home/root/oob/system.bit.bin \
      /home/root/oob/uImage \
      /home/root/oob/uramdisk.image.gz \
      "

FILES:${PN}:append:mz7010-iocc = "\
      /home/root/factest_scripts/pmod_lb_test.sh \
      /home/root/factest_scripts/program_oob_qspi.sh \
      /home/root/oob/boot.bin \
      /home/root/oob/devicetree.dtb \
      /home/root/oob/system.bit.bin \
      /home/root/oob/uImage \
      /home/root/oob/uramdisk.image.gz \
      "
