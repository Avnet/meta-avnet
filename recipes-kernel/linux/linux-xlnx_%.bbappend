FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://bsp.cfg \
            file://user.cfg \
            file://vitis_kconfig.cfg \
            file://0001-hwmon-pmbus-Add-Infineon-IR38060-62-63-driver.patch \
            "

SRC_URI_append_u96v2-sbc = " file://fix_u96v2_pwrseq_simple.patch \
                           "

#SRC_URI_append_mz = " file://0001-irqchip-irq-xilinx-intc-use-version-from-4.19.patch \
#                     "

SRC_URI_append_uz7ev-evcc-hdmi-v = " \
                file://0002-drm-xlnx_mixer-Dont-enable-primary-plane-by-default.patch \
                file://0003-drm_atomic_helper-Supress-vblank-timeout-warning-mes.patch \
"

SRC_URI_append_uz7ev-evcc-nvme = " \
                file://nvme.cfg \
"

SRC_URI_append_uz7ev-evcc-hdmi-v-n = " \
                file://nvme.cfg \
"

SRC_URI_append_uz7ev-evcc-quadcam-h = " \
        file://0001-arm-zynq-Add-MAX20087-driver.patch \
        file://0002-max20087-Remove-unused-members.patch \
        file://0003-media-i2c-max9286-fix-access-to-unallocated-memory.patch \
        file://0004-media-i2c-max9286-Break-out-reverse-channel-setup.patch \
        file://0005-media-i2c-max9286-Make-channel-amplitude-programmabl.patch \
        file://0006-media-i2c-max9286-Configure-reverse-channel-amplitud.patch \
        file://0007-media-i2c-Add-MARS-driver.patch \
        file://0008-media-i2c-max9286-add-support-for-port-regulators.patch \
        file://0009-max9286-WIP-modifications-for-mars-module.patch \
        file://0010-max9286-WIP-fix-endpoint-fwnode.patch \
        file://0011-max9286-WIP-modify-resolution.patch \
        file://0012-xilinx-vipp-WIP-blacklist-mars-module.patch \
        file://0013-media-i2c-mars-Wait-for-sometime-before-mars-sensor-.patch \
        file://0014-media-i2c-mars-Wait-for-correct-sensor-initializatio.patch \
        file://0015-media-i2c-max96705-fix-color-issue-due-to-bad-frame-.patch \
        file://0016-media-i2c-update-mars-drivers-for-REV1-serializers.patch \
        file://0001-v4l-xilinx-multi-scaler-change-print-level-from-erro.patch \
"
