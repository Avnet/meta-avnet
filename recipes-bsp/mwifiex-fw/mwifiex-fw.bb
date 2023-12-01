DESCRIPTION = "Firmware files for use with Azurewave wifi and BT chip(sd8987)"
LICENSE = "CLOSED"

SRC_URI = "git://github.com/nxp-imx/imx-firmware.git;protocol=git;branch=${BRANCH}"

SRCREV = "b6f070e3d4cab23932d9e6bc29e3d884a7fd68f4"
BRANCH = "lf-5.15.52_2.1.0"

S = "${WORKDIR}/git"

DEPENDS += "mwifiex"

do_install() {
    install -d ${D}${base_libdir}/firmware/nxp/
    install -m 0755 ${S}/nxp/FwImage_8987/sdiouart8987_combo_v0.bin ${D}${base_libdir}/firmware/nxp/
    install -m 0644 ${S}/nxp/wifi_mod_para.conf  ${D}${base_libdir}/firmware/nxp/
}

FILES:${PN} = "${base_libdir}/firmware/nxp/*"
