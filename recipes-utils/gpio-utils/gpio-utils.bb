#
# Recipe to install common gpio util files
#

SUMMARY = "Installs common gpio utils"
SECTION = "gpio"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = " \
    file://gpio_map.sh \
    file://gpio_common.sh \
    file://gpio_common.py \
    file://gpio.cpp \
    file://gpio.h \
    file://Makefile \
    file://gpio-utils.init \
    file://gpio-utils.service \
	"

COMPATIBLE_MACHINE = "mz|pz|uz|u96v2-sbc|zub1cg-sbc"

S = "${WORKDIR}"

inherit systemd update-rc.d

INITSCRIPT_PACKAGES = "${PN}"
INITSCRIPT_NAME = "gpio-utils"
INITSCRIPT_PARAMS:${PN} = "start 90 S ."

SYSTEMD_PACKAGES="${PN}"
SYSTEMD_SERVICE:${PN}="gpio-utils.service"
SYSTEMD_AUTO_ENABLE:${PN}="enable"

CXXFLAGS:aarch64 = "-fPIC"

do_install() {

    INSTALL_DIR=${D}${prefix}/local/bin/gpio
    install -d ${INSTALL_DIR}
    install -m 0755 ${S}/gpio_map.sh ${INSTALL_DIR}
    install -m 0755 ${S}/gpio_common.sh ${INSTALL_DIR}
    install -m 0755 ${S}/gpio_common.py ${INSTALL_DIR}

    LID_DIR=${D}${libdir}
    install -d ${LID_DIR}
    oe_libinstall -so libgpio ${LID_DIR}

    INC_DIR=${D}${includedir}/gpio
    install -d ${INC_DIR}
    install -m 0644 ${S}/gpio.h ${INC_DIR}

    install -d ${D}${sysconfdir}/init.d
    install -m 0755 ${S}/gpio-utils.init ${D}${sysconfdir}/init.d/gpio-utils
    if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
        install -d ${D}${systemd_system_unitdir}
        install -m 0644 ${WORKDIR}/gpio-utils.service ${D}${systemd_system_unitdir}
    fi
}

FILES:${PN} += " \
    ${prefix}/local/bin/gpio/gpio_map.sh \
    ${prefix}/local/bin/gpio/gpio_common.sh \
    ${prefix}/local/bin/gpio/gpio_common.py \
    ${libdir}/libgpio.so.* \
    ${includedir}/gpio/gpio.h \
    ${sysconfdir}/init.d/gpio-utils \
    ${systemd_system_unitdir}/gpio-utils.service \
"
