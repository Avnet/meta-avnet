#@TYPE: Machine
#@NAME: pz-fmc2
#@DESCRIPTION: Generic support for Picozed with FMC2.
#

MACHINEOVERRIDES =. "pz:pz-fmc2:"

require conf/machine/include/soc-zynq.inc
require conf/machine/include/machine-xilinx-default.inc

MACHINE_FEATURES = "rtc ext2 ext3 vfat usbhost usbgadget"

EXTRA_IMAGEDEPENDS += "libyaml-native python3-cython-native python3-pyyaml-native"

UBOOT_MACHINE = "xilinx_zynq_virt_defconfig"

# prevent U-Boot from deploying the boot.bin
SPL_BINARY ?= ""

SERIAL_CONSOLES ?= "115200;ttyPS0"

MACHINE_ESSENTIAL_EXTRA_RDEPENDS += "device-tree"

EXTRA_IMAGEDEPENDS += " \
        virtual/bootloader \
        u-boot-xlnx-scr \
        virtual/fsbl \
        avnet-boot-scr \
        "

# Used to create a wic image to boot from emmc
IMAGE_BOOT_FILES = " \
                    boot.bin \
                    avnet-boot/avnet_mmc_ext4.scr;boot.scr \
                    fitImage;image.ub \
                    "

WKS_FILES = "petalinux-image-minimal.wks"

# deploy avnet-boot-scr scripts in images/linux/ folder
EXTRA_FILESLIST:append = " ${DEPLOY_DIR_IMAGE}/avnet-boot/:avnet-boot/ "
