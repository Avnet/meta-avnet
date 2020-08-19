FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://system-bsp.dtsi \
"

SRC_URI_append_ultra96v2 = " file://openamp.dtsi \
"

do_configure_append () {
        echo '/include/ "system-bsp.dtsi"' >> ${DT_FILES_PATH}/system-top.dts
}

