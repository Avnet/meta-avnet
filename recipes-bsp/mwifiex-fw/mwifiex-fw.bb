DESCRIPTION = "Firmware files for use with Azurewave wifi and BT chip(sd8987)"
LICENSE = "CLOSED"

SRC_URI = "git://github.com/nxp-imx/imx-firmware.git;protocol=git;branch=${BRANCH}"

SRCREV = "2afa15e77f0b58eade42b4f59c9215339efcca66"
BRANCH = "lf-6.6.3_1.0.0"

S = "${WORKDIR}/git"

DEPENDS += "mwifiex"

do_install() {
    install -d ${D}${base_libdir}/firmware/nxp/
    install -m 0755 ${S}/nxp/FwImage_8987/sdiouart8987_combo_v0.bin ${D}${base_libdir}/firmware/nxp/
    install -m 0644 ${S}/nxp/wifi_mod_para.conf  ${D}${base_libdir}/firmware/nxp/
}

FILES:${PN} = "${base_libdir}/firmware/nxp/*"
