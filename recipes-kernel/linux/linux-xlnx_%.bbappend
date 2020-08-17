FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://bsp.cfg \
            file://user.cfg \
            file://0001-hwmon-pmbus-Add-Infineon-IR38060-62-63-driver.patch \
            file://0002-tty-xilinx_uartps-use-version-from-4.19.patch \
            "

SRC_URI_ultra96_zynqmp += "file://fix_u96v2_pwrseq_simple.patch \
                           file://vitis_kconfig.cfg \
                           "
