DESCRIPTION = "Image definition for Avnet boards"
LICENSE = "MIT"

# append what is already defined by petalinux (meta-petalinux and build/conf/plnxtool.conf)

IMAGE_INSTALL:append:zynq = "\
	bc \
	bonnie++ \
	coreutils \
	ethtool \
	gpio-utils \
	hdparm \
	i2c-tools \
	i2c-tools-misc \
	iperf3 \
	iw \
	nano \
	ncurses-terminfo-base \
	opencl-clhpp-dev \
	opencl-headers-dev \
	openssh \
	openssh-scp \
	openssh-sftp-server \
	openssh-sshd \
	python-webserver \
	python3 \
	python3-core \
	python3-dbus \
	python3-pygobject \
	sbc \
	udev-extraconf \
	usbutils \
	util-linux-sulogin \
"

IMAGE_INSTALL:append:zynqmp = "\
	bc  \
	bonnie++ \
	cmake \
	coreutils \
	dnf \
	e2fsprogs \
	e2fsprogs-badblocks \
	e2fsprogs-e2fsck \
	e2fsprogs-resize2fs \
	ethtool \
	gpio-utils \
	hdparm \
	i2c-tools \
	i2c-tools-misc \
	iperf3 \
	json-c \
	libpython3 \
	lmsensors-sensorsdetect \
	mesa-megadriver \
	nano \
	opencl-clhpp-dev \
	opencl-headers-dev \
	openssh \
	openssh-scp \
	openssh-sftp-server \
	openssh-sshd \
	packagegroup-core-ssh-dropbear \
	packagegroup-petalinux-display-debug \
	packagegroup-petalinux-gstreamer \
	packagegroup-petalinux-lmsensors \
	packagegroup-petalinux-matchbox \
	packagegroup-petalinux-opencv \
	packagegroup-petalinux-opencv-dev \
	packagegroup-petalinux-python-modules \
	packagegroup-petalinux-self-hosted \
	packagegroup-petalinux-v4lutils \
	packagegroup-petalinux-x11 \
	parted \
	pmic-prog \
	python3 \
	python3-pip \
	python3-pyserial \
	usbutils \
	util-linux \
	util-linux-blkid \
	util-linux-fdisk \
	util-linux-mkfs \
	util-linux-mount \
	xrt \
	xrt-dev \
	zocl \
"

IMAGE_INSTALL:remove:zynqmp = "\
	packagegroup-core-ssh-dropbear \
"

IMAGE_INSTALL:append:u96v2-sbc = "\
	bluez5 \
	connman-gtk \
	git \
	iw \
	libftdi \
	openamp-fw-echo-testd \
	openamp-fw-mat-muld \
	openamp-fw-rpc-demo \
	packagegroup-base-extended \
	packagegroup-petalinux \
	packagegroup-petalinux-96boards-sensors \
	packagegroup-petalinux-benchmarks \
	packagegroup-petalinux-openamp \
	packagegroup-petalinux-ultra96-webapp \
	packagegroup-petalinux-utils \
	ultra96-ap-setup \
	ultra96-misc \
	ultra96-radio-leds \
	ultra96-wpa \
	usb-gadget-ethernet \
	wilc3000-fw \
	wilc \
"

IMAGE_INSTALL:append:uz = "\
	blinky \
	libdrm \
	libdrm-tests \
	libstdc++ \
	libv4l \
	media-ctl \
	performance-tests \
	python-webserver \
	python3 \
	python3-core \
	python3-dbus \
	python3-pygobject \
	yavta \
"

IMAGE_INSTALL:append:uz7ev-evcc = "\
	user-led-test \
	user-switch-test \
"

IMAGE_INSTALL:append:uz7ev-evcc-hdmi = "\
	hdmi-utils \
	kernel-module-hdmi \
"

IMAGE_INSTALL:remove:uz7ev-evcc-hdmi = "\
	blinky \
	python-webserver \
	user-led-test \
	user-switch-test \
"

IMAGE_INSTALL:append:uz7ev-evcc-nvme = "\
	nvme-cli \
"

IMAGE_INSTALL:append:pz = "\
	blinky \
	e2fsprogs \
	e2fsprogs-resize2fs \
	e2fsprogs-e2fsck \
	parted \
	performance-tests \
	util-linux-mkfs \
"

IMAGE_INSTALL:append:zub1cg-sbc = "\
	blinky \
	libdrm \
	libdrm-tests \
	libstdc++ \
	libv4l \
	media-ctl \
	python3 \
	python3-core \
	python3-dbus \
	python3-pygobject \
	yavta \
"

IMAGE_INSTALL:remove:zub1cg-sbc = "\
	pmic-prog \
"

COMMON_FEATURES:append:zynq = "\
	debug-tweaks \
	hwcodecs \
	ssh-server-openssh \
"

COMMON_FEATURES:append:zynqmp = "\
	debug-tweaks \
	hwcodecs \
	package-management \
	ssh-server-openssh \
"
