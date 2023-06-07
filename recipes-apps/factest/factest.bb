require factest.inc

SUMMARY = "Factory Acceptance Tests scripts"

COMPATIBLE_MACHINE = "zub1cg-sbc|mz-iocc"
RCONFLICTS:${PN} = "blinky"

# common factest source files for all machines
SRC_URI = "\
	file://factest.sh \
	file://buttons_and_leds_test.sh;subdir=${SCRIPT_LOC} \
	file://ethernet_test.sh;subdir=${SCRIPT_LOC}  \
	file://qspi_utils.sh;subdir=${SCRIPT_LOC}  \
	file://sysmon.conf;subdir=${SCRIPT_LOC}  \
	file://sysmon_test.sh;subdir=${SCRIPT_LOC}  \
	file://usb_test.sh;subdir=${SCRIPT_LOC}  \
	"

# source files specific to the zub1cg-sbc machine
SRC_URI:append:zub1cg-sbc = "\
	file://click_test.sh;subdir=${SCRIPT_LOC}  \
	file://internal_sensors_test.sh;subdir=${SCRIPT_LOC}  \
	file://rtc_test.sh;subdir=${SCRIPT_LOC}  \
	file://hsio_lb_test.sh;subdir=${SCRIPT_LOC}  \
	"

# source files specific to the mz-iocc machines
SRC_URI:append:mz-iocc = "\
	file://pmod_lb_test.sh;subdir=${SCRIPT_LOC}  \
	"
