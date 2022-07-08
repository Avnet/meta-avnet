LIC_FILES_CHKSUM = "file://wpa_ap.conf;md5=24ab6a95620be06cef908de36a5d01c3"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:remove = " \
    file://ap.sh \
    "

INITSCRIPT_PARAMS = "start 99 S . stop 90 6 . stop 90 0 ."


do_install () {
    install -d ${D}${datadir}/wpa_ap
    install -d ${D}${sysconfdir}/init.d/

    install -m 0755 ${WORKDIR}/ultra96-ap-setup.sh ${D}${sysconfdir}/init.d/ultra96-ap-setup.sh
    install -m 0644 ${WORKDIR}/wpa_ap.conf  ${D}${datadir}/wpa_ap/wpa_ap.conf
    install -m 0644 ${WORKDIR}/udhcpd.conf  ${D}${datadir}/wpa_ap/udhcpd.conf
}