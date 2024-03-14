FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# https://github.com/Xilinx/meta-xilinx/commit/b0efcddc5b3a35d143614698a39ecb5a9d134aac removed kernel include path
# However media is not included in their copy of dtb bindings
KERNEL_INCLUDE = " \
        ${STAGING_KERNEL_DIR}/arch/${ARCH}/boot/dts \
        ${STAGING_KERNEL_DIR}/arch/${ARCH}/boot/dts/* \
        ${STAGING_KERNEL_DIR}/scripts/dtc/include-prefixes \
        "

# Remove avnet-ultra96-rev1 dependency
YAML_DT_BOARD_FLAGS:u96v2-sbc ?= "{BOARD template}"

SRC_URI:append = "\
	file://system-bsp.dtsi \
"

SRC_URI:append:u96v2-sbc-base = "\
	file://openamp.dtsi \
"

SRC_URI:append:uz7ev-evcc-hdmi = "\
	file://hdmi.dtsi \
"

# For Avnet BSP only
do_configure:append () {
	if [ -e ${WORKDIR}/system-bsp.dtsi ]; then
		cp ${WORKDIR}/system-bsp.dtsi ${DT_FILES_PATH}/system-bsp.dtsi
		echo '#include "system-bsp.dtsi"' >> ${DT_FILES_PATH}/${BASE_DTS}.dts
	fi
}

# For Ultra96-SBC-base BSP only
do_configure:append:u96v2-sbc-base () {
	if [ -e ${WORKDIR}/openamp.dtsi ]; then
		cp ${WORKDIR}/openamp.dtsi ${DT_FILES_PATH}/openamp.dtsi
		echo '#include "openamp.dtsi"' >> ${DT_FILES_PATH}/${BASE_DTS}.dts
	fi
}

# For uz7ev-evcc-hdmi BSP only
do_configure:append:uz7ev-evcc-hdmi () {
	if [ -e ${WORKDIR}/hdmi.dtsi ]; then
		cp ${WORKDIR}/hdmi.dtsi ${DT_FILES_PATH}/hdmi.dtsi
		echo '#include "hdmi.dtsi"' >> ${DT_FILES_PATH}/${BASE_DTS}.dts
	fi
}
