#@TYPE: Machine
#@NAME: AUboard-15P-microblazeel
#@DESCRIPTION: Machine configuration for the AUboard-15P board.

MACHINEOVERRIDES =. "auboard15p:auboard15p-microblazeel:"

# Variables that changes based on hw design or board specific requirement must be
# defined before calling the required inclusion file else pre-expansion value
# defined in microblazeel-generic.conf will be set.

# Yocto FS-Boot variables
YAML_SERIAL_CONSOLE_STDIN:pn-fs-boot ?= "axi_uartlite_0"
YAML_SERIAL_CONSOLE_STDOUT:pn-fs-boot ?= "axi_uartlite_0"
YAML_MAIN_MEMORY_CONFIG:pn-fs-boot ?= "DDR4_0"
YAML_FLASH_MEMORY_CONFIG:pn-fs-boot ?= "axi_quad_spi_0"
XSCTH_PROC:pn-fs-boot ?= "microblaze_0"

# Yocto device-tree variables
YAML_CONSOLE_DEVICE_CONFIG:pn-device-tree ?= "axi_uartlite_0"
YAML_MAIN_MEMORY_CONFIG:pn-device-tree ?= "DDR4_0"
DT_PADDING_SIZE:pn-device-tree ?= "0x1000"
DTC_FLAGS:pn-device-tree ?= ""
XSCTH_PROC:pn-device-tree ?= "microblaze_0"
YAML_DT_BOARD_FLAGS ?= "{BOARD template}"

# Yocto KERNEL Variables
UBOOT_ENTRYPOINT  ?= "0x80000000"
UBOOT_LOADADDRESS ?= "0x80000000"

# Set DDR Base address for u-boot-xlnx-scr variables
DDR_BASEADDR ?= "0x80000000"
SKIP_APPEND_BASEADDR ?= "0"

# auboard15p-microblazeel Serial Console
SERIAL_CONSOLES ?= "115200;ttyUL0"
YAML_SERIAL_CONSOLE_BAUDRATE ?= "115200"

# Required generic machine inclusion
require conf/machine/microblaze-generic.conf

# This machine conf file uses auboard15p-microblazeel xsa as reference input.
# User can override with auboard15p custom xsa using HDF_BASE and HDF_PATH variables
# from local.conf.
HDF_MACHINE = "auboard15p-microblazeel"

#### No additional settings should be after the Postamble
#### Postamble
PACKAGE_EXTRA_ARCHS:append = "${@['', 'auboard15p-microblazeel']['auboard15p-microblazeel' != '${MACHINE}']}"
