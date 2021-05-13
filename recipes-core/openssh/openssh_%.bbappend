do_install_append() {
    echo "===== PISS ====="
    echo "PermitRootLogin yes" >> ${D}${sysconfdir}/ssh/sshd_config
}

