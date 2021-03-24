FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://system-bsp.dtsi \
"

SRC_URI_append_u96v2-sbc = " file://openamp.dtsi \
"

SRC_URI_append_uz7ev-evcc-hdmi = " file://hdmi.dtsi \
"

SRC_URI_append_uz7ev-evcc-quadcam-h = " file://fmc-quad.dtsi \
"

do_configure_append () {
        echo '#include "system-bsp.dtsi"' >> ${DT_FILES_PATH}/system-top.dts
}
