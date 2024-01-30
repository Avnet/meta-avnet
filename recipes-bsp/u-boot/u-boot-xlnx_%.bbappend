FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://0001-usb-dwc3-Fix-remove-function-if-no-ulpi_reset-gpio.patch \
            "

UBOOTELF_NODTB_BINARY = "u-boot.elf"
