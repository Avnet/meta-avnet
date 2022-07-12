DESCRIPTION = "Util scripts for hdmi"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

COMPATIBLE_MACHINE = "uz7ev-evcc-hdmi|uz7ev-evcc-hdmi-v|uz7ev-evcc-quadcam-h|uz7ev-evcc-quadcam-h-v"

FF = "files"

HDMI_FILES = " \
    file://hdmi_passthrough.sh;subdir=${FF} \
"

QUADCAM_FILES = " \
    file://launch_quad_cam_gstreamer.sh;subdir=${FF} \
    file://launch_quad_cam_gstreamer_960x540.sh;subdir=${FF} \
    file://launch_one_cam_gstreamer.sh;subdir=${FF} \
    file://media_cfg.sh;subdir=${FF} \
    file://media_cfg_960x540.sh;subdir=${FF} \
"

VCU_FILES = " \
    file://file_to_vcu_to_hdmi.sh;subdir=${FF} \
    file://hdmi_to_vcu_to_file.sh;subdir=${FF} \
    file://hdmi_to_vcu_to_hdmi.sh;subdir=${FF} \
"

SRC_URI:uz7ev-evcc-hdmi = " \
    ${HDMI_FILES} \
"

SRC_URI:uz7ev-evcc-hdmi-v = " \
    ${HDMI_FILES} \
    ${VCU_FILES} \
"

SRC_URI:uz7ev-evcc-quadcam-h = " \
    ${QUADCAM_FILES} \
    ${HDMI_FILES} \
"

SRC_URI:uz7ev-evcc-quadcam-h-v = " \
    ${QUADCAM_FILES} \
    ${HDMI_FILES} \
    ${VCU_FILES} \
    file://launch_quad_cam_vcu_gstreamer.sh;subdir=${FF}  \
    file://launch_quad_cam_vcu_gstreamer_960x540.sh;subdir=${FF}  \
"

do_install() {
    install -d ${D}/${ROOT_HOME}
    install -m 777 ${WORKDIR}/${FF}/* ${D}/${ROOT_HOME}
}

FILES:${PN} = "${ROOT_HOME}/*"
