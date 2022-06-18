DESCRIPTION = "Device monitor script for AMD-Xilinx System Management Wizard"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

#FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://devmon.sh \
   file://imudemo.sh \
" 


do_install() {
	install -d ${D}/home/root/
	install -m 755 ${WORKDIR}/devmon.sh ${D}/home/root/
	install -m 755 ${WORKDIR}/imudemo.sh ${D}/home/root/
}

FILES_${PN} = " \
		/home/root/devmon.sh \
		/home/root/imudemo.sh \
"
