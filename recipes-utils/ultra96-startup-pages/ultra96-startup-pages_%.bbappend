FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
LIC_FILES_CHKSUM = "file://LICENSE.md;md5=a768baea9d204ad586e989c92a2afb31"

SRC_URI = "git://github.com/Avnet/BSP-rootfs-sources.git;protocol=https;branch=${SRCBRANCH};subpath=${SUBPATH} \
       file://ultra96-startup-page.sh \
       file://ultra96-startup-page.service \
       file://ultra96-startup-commands.sh \
       file://launch-ultra96-startup-page.desktop \
       file://launch-ultra96-startup-page.sh \
       file://connman_settings \
       "

RDEPENDS:${PN}:remove = "\
    chromium-x11 \
"

SRCREV = "${AUTOREV}"

SRCBRANCH ?= "master"
SUBPATH = "ultra96-startup-pages"
S = "${WORKDIR}/${SUBPATH}"

do_install:append () {
    install -d ${D}/var/lib/connman
    install -m 0755 ${WORKDIR}/connman_settings ${D}/var/lib/connman/settings
}
