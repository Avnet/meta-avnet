DESCRIPTION = "Target packages for supporting development"

inherit packagegroup

PACKAGES = " \
    ${PN}-debugging \
    ${PN}-hardware-testing \
    ${PN}-monitoring \
    ${PN}-profiling \
    ${PN}-provisioning \
    ${PN}-testing \
    ${PN}-tracing \
    ${PN}-utilities \
    "

PROVIDES = "${PACKAGES}"

RDEPENDS:${PN}-debugging = " \
    binutils \
    devmem2 \
    gdb \
    gdbserver \
    openssh-scp \
    openssh-sftp-server \
    openssh-sshd \
    rsync \
    systemd-extra-utils \
    valgrind \
    "

RDEPENDS:${PN}-hardware-testing = " \
    ethtool \
    i2c-tools \
    libgpiod-tools \
    mmc-utils \
    mtd-utils \
    net-tools \
    pciutils \
    picocom \
    usbutils \
    fpga-manager-script \
    "

RDEPENDS:${PN}-monitoring = " \
    htop \
    iproute2-ss \
    sysstat \
    systemtap \
    "

RDEPENDS:${PN}-profiling = " \
    iperf3 \
    perf \
    systemd-analyze \
    "

RDEPENDS:${PN}-provisioning = " \
    bmap-tools \
    gzip \
    mmc-utils \
    mtd-utils \
    "

RDEPENDS:${PN}-testing = " \
    ptest-runner \
    "

RDEPENDS:${PN}-tracing = " \
    babeltrace2 \
    blktrace \
    lttng-modules \
    lttng-tools \
    lttng-ust \
    strace \
    tcpdump \
    trace-cmd \
    "

RDEPENDS:${PN}-utilities = " \
    curl \
    findutils \
    socat \
    vim-tiny \
