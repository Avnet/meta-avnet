require factest.inc

SUMMARY = "Factory Acceptance Tests scripts"

COMPATIBLE_MACHINE = "zub1cg-sbc|mz-iocc|u96v2-sbc-factest|k24-iocc-factest"
RCONFLICTS:${PN} = "blinky"

# common factest source files for all machines
SRC_URI = "\
	file://factest.sh \
	file://buttons_and_leds_test.sh;subdir=${SCRIPT_LOC} \
	"

# source files specific to the zub1cg-sbc machine
SRC_URI:append:zub1cg-sbc = "\
	file://ethernet_test.sh;subdir=${SCRIPT_LOC}  \
	file://qspi_utils.sh;subdir=${SCRIPT_LOC}  \
	file://sysmon.conf;subdir=${SCRIPT_LOC}  \
	file://sysmon_test.sh;subdir=${SCRIPT_LOC}  \
	file://usb_test.sh;subdir=${SCRIPT_LOC}  \
	file://click_test.sh;subdir=${SCRIPT_LOC}  \
	file://internal_sensors_test.sh;subdir=${SCRIPT_LOC}  \
	file://rtc_test.sh;subdir=${SCRIPT_LOC}  \
	file://hsio_lb_test.sh;subdir=${SCRIPT_LOC}  \
	"

# source files specific to the mz-iocc machines
SRC_URI:append:mz-iocc = "\
	file://ethernet_test.sh;subdir=${SCRIPT_LOC}  \
	file://qspi_utils.sh;subdir=${SCRIPT_LOC}  \
	file://sysmon.conf;subdir=${SCRIPT_LOC}  \
	file://sysmon_test.sh;subdir=${SCRIPT_LOC}  \
	file://usb_test.sh;subdir=${SCRIPT_LOC}  \
	file://pmod_lb_test.sh;subdir=${SCRIPT_LOC}  \
	"

# source files specific to the u96v2-sbc-factest machine
SRC_URI:append:u96v2-sbc-factest = "\
	file://dp_test.sh;subdir=${SCRIPT_LOC}  \
	file://sd_test.sh;subdir=${SCRIPT_LOC}  \
	file://usb_host_test.sh;subdir=${SCRIPT_LOC}  \
	file://usb_device_test.sh;subdir=${SCRIPT_LOC}  \
	file://sensors_test.sh;subdir=${SCRIPT_LOC}  \
	file://loopback_gpios_test.sh;subdir=${SCRIPT_LOC}  \
	file://wifi_test.sh;subdir=${SCRIPT_LOC}  \
	file://bt_test.sh;subdir=${SCRIPT_LOC}  \
	"

# source files specific to the zub1cg-sbc machine
SRC_URI:append:k24-iocc-factest = "\
	file://click_test.sh;subdir=${SCRIPT_LOC}  \
	file://ethernet_test.sh;subdir=${SCRIPT_LOC}  \
	file://hsio_lb_test.sh;subdir=${SCRIPT_LOC}  \
	file://pmod_lb_test.sh;subdir=${SCRIPT_LOC}  \
	file://qspi_utils.sh;subdir=${SCRIPT_LOC}  \
	file://rtc_test.sh;subdir=${SCRIPT_LOC}  \
	file://usb_test.sh;subdir=${SCRIPT_LOC}  \
	"
