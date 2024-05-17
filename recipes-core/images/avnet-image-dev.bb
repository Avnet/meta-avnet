inherit image

COMPATIBLE_MACHINE = "zub1cg-sbc-base"

IMAGE_LINGUAS = ""

NO_RECOMMENDATIONS = "1"

IMAGE_FSTYPES = "ext4 ext4.gz wic"

INITRAMFS_MAXSIZE ?= "512000"

IMAGE_FEATURES += " \
    allow-empty-password \
    allow-root-login \
    empty-root-password \
    package-management \
    dev-pkgs \
    "

PACKAGE_INSTALL = " \
    ${FEATURE_INSTALL} \
    packagegroup-avnet-core \
    packagegroup-avnet-misc \
    packagegroup-avnet-development-debugging \
    packagegroup-avnet-development-hardware-testing \
    packagegroup-avnet-development-monitoring \
    packagegroup-avnet-development-profiling \
    packagegroup-avnet-development-provisioning \
    packagegroup-avnet-development-testing \
    packagegroup-avnet-development-tracing \
    packagegroup-avnet-development-utilities \
    "
