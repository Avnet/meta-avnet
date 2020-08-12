FILESEXTRAPATHS_prepend := "${THISDIR}/files/${MACHINE}:${THISDIR}/files:"

SRC_URI += "file://system-user.dtsi \
"

SRC_URI_append_ultra96v2 = " file://openamp.dtsi \
"
