DESCRIPTION = "Util scripts for hdmi"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI += "file://hdmi_passthrough.sh \
"

SRC_URI_append_uz7ev-evcc-quadcam = " \
    file://isp_tune.sh \
    file://launch_quad_cam_gstreamer.sh \
    file://launch_one_cam_gstreamer.sh \
    file://media_cfg.sh \
"

do_install() {
	install -d ${D}/home/root/
	install -m 777 ${WORKDIR}/hdmi_passthrough.sh ${D}/home/root/
}

do_install_append_uz7ev-evcc-quadcam () {
    install -m 777 ${WORKDIR}/isp_tune.sh ${D}/home/root/
    install -m 777 ${WORKDIR}/launch_quad_cam_gstreamer.sh ${D}/home/root/
    install -m 777 ${WORKDIR}/launch_one_cam_gstreamer.sh ${D}/home/root/
    install -m 777 ${WORKDIR}/media_cfg.sh ${D}/home/root/
}

FILES_${PN} = " \
		/home/root/hdmi_passthrough.sh \
"

FILES_${PN}_append_uz7ev-evcc-quadcam = " \
        /home/root/isp_tune.sh \
        /home/root/launch_quad_cam_gstreamer.sh \
        /home/root/launch_one_cam_gstreamer.sh \
        /home/root/media_cfg.sh \
"
