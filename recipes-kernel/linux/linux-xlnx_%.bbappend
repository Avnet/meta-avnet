FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://avnet-bsp.cfg \
            file://vitis_kconfig.cfg \
            file://0001-hwmon-pmbus-Add-support-Infineon-IR38062-IR38063.patch \
            "

SRC_URI:append:u96v2-sbc = " file://fix_u96v2_pwrseq_simple.patch \
                           "

SRC_URI:append:uz7ev-evcc-nvme = " \
                file://nvme.cfg \
"

SRC_URI:append:zub1cg-sbc = " \
                file://0001-drivers-iio-temperature-import-ssts22h-driver.patch \
"
