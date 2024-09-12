SUMMARY = "MWIFIEX Driver"
LICENSE="CLOSED"
LIC_FILES_CHKSUM=""
SECTION = "PETALINUX/modules"

SRCREV = "a84df583155bad2a396a937056805550bdf655ab"
SRCBRANCH = "lf-6.6.3_1.0.0"
SRC_URI = "git://github.com/nxp-imx/mwifiex.git;protocol=https;branch=${SRCBRANCH} \
           file://0001-makefile-add-modules_install.patch \
           "

DEPENDS += " virtual/kernel "

inherit module

S = "${WORKDIR}/git/mxm_wifiex/wlan_src"

MODULE_DIR = "mxm_wifiex/wlan_src"

KERNEL_DIR = "${STAGING_KERNEL_DIR}"

EXTRA_OEMAKE = ' \
                KERNELDIR=${KERNEL_DIR} \
                CONFIG_STA_CFG80211=y \
                O=${STAGING_KERNEL_BUILDDIR} \
                '
