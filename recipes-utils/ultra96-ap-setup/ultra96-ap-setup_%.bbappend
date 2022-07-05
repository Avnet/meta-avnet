LIC_FILES_CHKSUM = "file://wpa_ap.conf;md5=24ab6a95620be06cef908de36a5d01c3"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

INITSCRIPT_PARAMS = "start 99 S . stop 90 6 . stop 90 0 ."


do_install:append () {
    # Remove default ap.sh file as it is not required
    rm -f ${D}${datadir}/wpa_ap/ap.sh
}