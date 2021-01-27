DESCRIPTION = "Util scripts for hdmi"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI += "file://hdmi_passthrough.sh \
"


do_install() {
	install -d ${D}/home/root/
	install -m 777 ${WORKDIR}/hdmi_passthrough.sh ${D}/home/root/
}

FILES_${PN} = " \
		/home/root/hdmi_passthrough.sh \
"
