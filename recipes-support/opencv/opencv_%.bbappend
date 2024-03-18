PACKAGECONFIG:append = " libav "

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0001-Add-missing-header-for-LIBAVCODEC_VERSION_INT.patch"

