require recipes-core/images/avnet-image-minimal.inc

COMPATIBLE_MACHINE = "zub1cg-sbc"

IMAGE_INSTALL:append = "\
        factest \
"


