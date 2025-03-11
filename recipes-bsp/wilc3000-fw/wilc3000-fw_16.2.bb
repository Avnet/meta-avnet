HOMEPAGE = "https://github.com/linux4wilc/firmware"
DESCRIPTION = "Firmware files for use with Microchip wilc3000"
LICENSE = "CLOSED"
LIC_FILES_CHKSUM = "file://LICENSE.wilc_fw;md5=89ed0ff0e98ce1c58747e9a39183cc9f"

SRC_URI = "git://github.com/linux4wilc/firmware.git;protocol=git;branch=${BRANCH}"

# Tag: wilc_linux_16_2
SRCREV = "56ced13b64331db9ffb5f7dc6d704bcaaac4842b"
BRANCH = "master"

S = "${WORKDIR}/git"

DEPENDS += "wilc"

do_install() {
    install -d ${D}${base_libdir}/firmware/mchp
    install -m 0755 ${S}/wilc* ${D}${base_libdir}/firmware/mchp
}

FILES:${PN} = "${base_libdir}/firmware/mchp/*"
