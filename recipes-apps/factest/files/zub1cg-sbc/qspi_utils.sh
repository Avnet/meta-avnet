#!/bin/sh

USER_MTD_DEV=/dev/mtd1
MAX_LOGFILE_SIZE=0x8000 #defined in freertos image

qspi_erase_user_part ()
{
    flash_erase $USER_MTD_DEV 0 0
}

qspi_check_user_part ()
{
    stat $USER_MTD_DEV > /dev/null 2>&1
    if [[ $? -ne 0 ]]
    then
        echo "error: mtd device ('$USER_MTD_DEV') unknown "
        return 1
    fi

    qspi_erase_user_part
    if [[ $? -ne 0 ]]
    then
        echo "error: failed to erase QSPI user partition"
        return 1
    fi

    return 0
}

copy_log_file_to_qspi () {
    log_file=$1

    # copying size of log file at the beginning of the user part
    size=`stat --printf="%s" $log_file`

    if [[ $size -gt  $MAX_LOGFILE_SIZE ]]
    then
        echo "warning: log file size exceeds max size ($MAX_LOGFILE_SIZE) - file will be truncated"
        size=$((MAX_LOGFILE_SIZE))
    fi

    v=`awk -v n=$size  'BEGIN{printf "%08X", n;}'`
    echo -n -e "\\x${v:6:2}\\x${v:4:2}\\x${v:2:2}\\x${v:0:2}" > size.bin
    mtd_debug write $USER_MTD_DEV 0x0 0x4 size.bin
    if [[ $? -ne 0 ]]
    then
        echo "error: failed to copy size of log file to QSPI user partition"
        return 1
    fi

    rm size.bin

    # copying file at offset 0x04
    mtd_debug write $USER_MTD_DEV 0x4 $size $log_file
    if [[ $? -ne 0 ]]
    then
        echo "error: failed to copy $log_file to QSPI user partition"
        return 1
    fi

    echo "Test Results copied to QSPI user partition"
    return 0
}