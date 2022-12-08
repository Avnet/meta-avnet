require recipes-core/images/avnet-image-full.inc

COMPATIBLE_MACHINE = "zub1cg-sbc|mz7020-iocc|mz7010-iocc"

IMAGE_INSTALL:append = "\
        factest \
"

