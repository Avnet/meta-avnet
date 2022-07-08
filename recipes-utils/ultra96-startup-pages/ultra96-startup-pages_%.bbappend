FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
LIC_FILES_CHKSUM = "file://LICENSE.md;md5=a768baea9d204ad586e989c92a2afb31"

SRC_URI = "git://github.com/Avnet/BSP-rootfs-sources.git;protocol=https;branch=${SRCBRANCH};subpath=${SUBPATH} \
       file://ultra96-startup-page.sh \
       file://connman_settings \
       "

RDEPENDS:${PN}:remove = "\
    chromium-x11 \
"

SRCREV = "${AUTOREV}"

SRCBRANCH ?= "master"
SUBPATH = "ultra96-startup-pages"
S = "${WORKDIR}/${SUBPATH}"

do_install () {
    install -d ${D}${datadir}/ultra96-startup-pages
    rsync -r --exclude=".*" ${S}/* ${D}${datadir}/ultra96-startup-pages

    install -d ${D}${sysconfdir}/init.d/
    install -m 0755 ${WORKDIR}/ultra96-startup-page.sh ${D}${sysconfdir}/init.d/ultra96-startup-page.sh

    install -d ${D}/var/lib/connman
    install -m 0755 ${WORKDIR}/connman_settings ${D}/var/lib/connman/settings

}
