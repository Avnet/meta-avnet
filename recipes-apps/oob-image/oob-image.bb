#
# This file is the oob_image recipe.
#

SUMMARY = "Out Of the Box images and scripts"
SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"



COMPATIBLE_MACHINE = "zub1cg-sbc|mz-iocc"

RDEPENDS:${PN} += "bash"

SRC_URI = " file://flash-programming.sh \
		"

SRC_URI:append:zub1cg-sbc = " \
	https://github.com/Avnet/freertos-oob/releases/download/v1.4/BOOT.BIN;downloadfilename=BOOT.BIN;name=zu1-boot \
	file://emmc-programming.sh \
"

SRC_URI[zu1-boot.sha256sum] = "1738635584d692b2095c800969a07f551bd4170b331d6b6cc7b226b97d11587b"

SRC_URI:append:mz-iocc = " \
	file://oob.zip \
"


S = "${WORKDIR}"

do_install() {
		install -d ${D}/home/root
		install -m 0755 flash-programming.sh ${D}/home/root
		install -d ${D}/home/root/oob_image/
}

do_install:append:zub1cg-sbc () {
		install -m 0755 emmc-programming.sh ${D}/home/root
		install -m 0444 BOOT.BIN ${D}/home/root/oob_image/
}

do_install:append:mz-iocc () {
	install -m 0755 ${S}/boot.bin ${D}/home/root/oob_image/
	install -m 0755 ${S}/devicetree.dtb ${D}/home/root/oob_image/
	install -m 0755 ${S}/system.bit.bin ${D}/home/root/oob_image/
	install -m 0755 ${S}/uImage ${D}/home/root/oob_image/
	install -m 0755 ${S}/uramdisk.image.gz ${D}/home/root/oob_image/
}

FILES:${PN} += "\
	/home/root/flash-programming.sh \
"

FILES:${PN}:append:zub1cg-sbc = "\
	/home/root/oob_image/BOOT.BIN \
	/home/root/emmc-programming.sh \
"

FILES:${PN}:append:mz-iocc = "\
	/home/root/oob_image/boot.bin \
	/home/root/oob_image/devicetree.dtb \
	/home/root/oob_image/system.bit.bin \
	/home/root/oob_image/uImage \
	/home/root/oob_image/uramdisk.image.gz \
"
