FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://bsp.cfg \
            file://user.cfg \
            file://vitis_kconfig.cfg \
            file://0001-hwmon-pmbus-Add-Infineon-IR38060-62-63-driver.patch \
            "

SRC_URI_append_u96v2-sbc = " file://fix_u96v2_pwrseq_simple.patch \
                           "

SRC_URI_append_mz = " file://0001-irqchip-irq-xilinx-intc-use-version-from-4.19.patch \
                     "

SRC_URI_append_uz7ev-evcc-hdmi-v = " \
                file://0002-drm-xlnx_mixer-Dont-enable-primary-plane-by-default.patch \
                file://0003-drm_atomic_helper-Supress-vblank-timeout-warning-mes.patch \
"

SRC_URI_remove_uz7ev-evcc-quadcam-h = " \
                file://0001-hwmon-pmbus-Add-Infineon-IR38060-62-63-driver.patch \
"
