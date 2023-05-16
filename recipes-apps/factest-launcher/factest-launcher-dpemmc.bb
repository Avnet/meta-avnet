require factest-launcher.inc

SUMMARY = "Simple factest-launcher application for dp-emmc extension board"

SRC_URI = "file://factest-launcher-dpemmc.sh \
		   file://factest-launcher \
		   file://factest-launcher.service \
		  "

COMPATIBLE_MACHINE = "zub1cg-sbc"
RDEPENDS:${PN} = "factest-dpemmc oob-image"
RCONFLICTS:${PN} = "factest-launcher"

python do_unpack:append() {
    os.rename("factest-launcher-dpemmc.sh", "factest-launcher.sh")
}