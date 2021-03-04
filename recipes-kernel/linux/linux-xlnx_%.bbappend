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

SRC_URI_append_uz7ev-evcc-quadcam = " \
                file://0002-drm-xlnx_mixer-Dont-enable-primary-plane-by-default.patch \
                file://0003-drm_atomic_helper-Supress-vblank-timeout-warning-mes.patch \
                file://0008-arm-zynq-Add-MAX20087-driver.patch \
                file://0009-arm-zynq-Add-avt_multi_sensor_fmc-driver.patch \
                file://0010-max9286-serdes-Fix-source-pad-media-format.patch \
                file://0011-ar0231-Fix-the-media-bus-format-to-GRBG.patch \
                file://0012-avt_multi_sensor_fmc-Add-dependency-on-REGULATOR.patch \
                file://0013-max20087-Remove-unused-members.patch \
                file://0020-media-i2c-Add-MAX9286-driver.patch \
                file://0021-media-i2c-fix-error-check-on-max9286_read-call.patch \
                file://0022-media-i2c-max9286-Allocate-v4l2_async_subdev-dynamic.patch \
"