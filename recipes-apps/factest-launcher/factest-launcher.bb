require factest-launcher.inc

SUMMARY = "Simple factest-launcher application"

COMPATIBLE_MACHINE = "zub1cg-sbc|mz-iocc|u96v2-sbc-factest|k24-iocc-factest"
RDEPENDS:${PN} = "factest"
RDEPENDS:${PN}:append:zub1cg-sbc = " oob-image"
RDEPENDS:${PN}:append:mz-iocc = " oob-image"
RCONFLICTS:${PN} = "factest-launcher-dpemmc"
