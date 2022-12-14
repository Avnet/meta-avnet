require recipes-core/images/avnet-image-full.inc

COMPATIBLE_MACHINE = "zub1cg-sbc"

IMAGE_INSTALL:append = "\
        factest \
        factest-launcher \
"

IMAGE_INSTALL:remove = "\
        blinky \
        blinky-systemd \
"


