require recipes-core/images/avnet-image-full.inc

COMPATIBLE_MACHINE = "zub1cg-sbc|mz-iocc"

IMAGE_INSTALL:append = "\
        factest \
        factest-launcher \
"

IMAGE_INSTALL:remove:zub1cg-sbc = "\
        blinky \
"

