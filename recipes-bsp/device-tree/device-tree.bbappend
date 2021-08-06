FILESEXTRAPATHS_prepend := "${THISDIR}/files:${SYSCONFIG_PATH}:"

SRC_URI_append = "\
	file://config \
	file://system-user.dtsi \
	file://system-bsp.dtsi \
"

SRC_URI_append_u96v2-sbc = "\
	file://openamp.dtsi \
"

SRC_URI_append_uz7ev-evcc-hdmi = "\
	file://hdmi.dtsi \
"

SRC_URI_append_uz7ev-evcc-quadcam-h = "\
	file://fmc-quad.dtsi \
"

python () {
    if d.getVar("CONFIG_DISABLE"):
        d.setVarFlag("do_configure", "noexec", "1")
}

export PETALINUX
do_configure_append () {
	script="${PETALINUX}/etc/hsm/scripts/petalinux_hsm_bridge.tcl"
	data=${PETALINUX}/etc/hsm/data/
	eval xsct -sdx -nodisp ${script} -c ${WORKDIR}/config \
	-hdf ${DT_FILES_PATH}/hardware_description.${HDF_EXT} -repo ${S} \
	-data ${data} -sw ${DT_FILES_PATH} -o ${DT_FILES_PATH} -a "soc_mapping"
}

# For Avnet BSP only
do_configure_append () {
        if [ -e ${WORKDIR}/system-bsp.dtsi ]; then
               cp ${WORKDIR}/system-bsp.dtsi ${DT_FILES_PATH}/system-bsp.dtsi
               echo '/include/ "system-bsp.dtsi"' >> ${DT_FILES_PATH}/${BASE_DTS}.dts
        fi
}

# For Ultra96-SBC BSP only
do_configure_append_u96v2-sbc () {
        if [ -e ${WORKDIR}/openamp.dtsi ]; then
               cp ${WORKDIR}/openamp.dtsi ${DT_FILES_PATH}/openamp.dtsi
               echo '/include/ "openamp.dtsi"' >> ${DT_FILES_PATH}/${BASE_DTS}.dts
        fi
}

# For uz7ev-evcc-hdmi BSP only
do_configure_append_uz7ev-evcc-hdmi () {
        if [ -e ${WORKDIR}/hdmi.dtsi ]; then
               cp ${WORKDIR}/hdmi.dtsi ${DT_FILES_PATH}/hdmi.dtsi
               echo '/include/ "hdmi.dtsi"' >> ${DT_FILES_PATH}/${BASE_DTS}.dts
        fi
}

# For uz7ev-evcc-quadcam BSP only
do_configure_append_uz7ev-evcc-quadcam () {
        if [ -e ${WORKDIR}/fmc-quad.dtsi ]; then
               cp ${WORKDIR}/fmc-quad.dtsi ${DT_FILES_PATH}/fmc-quad.dtsi
               echo '/include/ "fmc-quad.dtsi"' >> ${DT_FILES_PATH}/${BASE_DTS}.dts
        fi
}