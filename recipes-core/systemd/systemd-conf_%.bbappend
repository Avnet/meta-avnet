FILESEXTRAPATHS:prepend := "${THISDIR}/systemd-conf:"

SRC_URI:append:zub1cg-sbc-trifecta = " \
    file://10-mlan0.network \
"

FILES:${PN}:append:zub1cg-sbc-trifecta = " \
    ${sysconfdir}/systemd/network/10-mlan0.network \
"

do_install:append:zub1cg-sbc-trifecta() {
    install -d ${D}${sysconfdir}/systemd/network
    install -m 0644 ${WORKDIR}/10-mlan0.network ${D}${sysconfdir}/systemd/network
}
