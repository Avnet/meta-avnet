require factest-launcher.inc

SUMMARY = "Simple factest-launcher application"

COMPATIBLE_MACHINE = "zub1cg-sbc|mz-iocc"
RDEPENDS:${PN} = "factest oob-image"
RCONFLICTS:${PN} = "factest-launcher-dpemmc"
