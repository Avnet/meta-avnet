DESCRIPTION = "Target packages for Avnet images"

inherit packagegroup

PACKAGES = " \
    ${PN}-core \
    ${PN}-misc \
    "

PROVIDES = "${PACKAGES}"

RDEPENDS:${PN}-core = " \
    bash \
    busybox \
    coreutils \
    kernel-modules \
    os-release \
    sed \
    systemd \
    systemd-conf \
    "

RDEPENDS:${PN}-misc = " \
    "
