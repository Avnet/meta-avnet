require factest.inc

SUMMARY = "DP-EMMC Factory Acceptance Tests scripts"

COMPATIBLE_MACHINE = "zub1cg-sbc"

# common factest source files for all machines
SRC_URI = "\
	file://factest-dpemmc.sh \
	file://dp.sh;subdir=${SCRIPT_LOC} \
	file://emmc.sh;subdir=${SCRIPT_LOC}  \
	file://emmc_mmcblk1.sfdisk;subdir=${SCRIPT_LOC}  \
	file://qspi_utils.sh;subdir=${SCRIPT_LOC}  \
	"

python do_unpack:append() {
    os.rename("factest-dpemmc.sh", "factest.sh")
}
