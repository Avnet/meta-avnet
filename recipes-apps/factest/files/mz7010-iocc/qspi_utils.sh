#!/bin/sh

USER_MTD_DEV=/dev/mtd0
USER_MTD_BLOCK=/dev/mtdblock0
MOUNT_POINT=/mnt

qspi_umount_user_part () {
    umount $MOUNT_POINT > /dev/null 2>&1
}

qspi_mount_user_part () {
    qspi_umount_user_part
    mount -t jffs2 $USER_MTD_BLOCK $MOUNT_POINT
    if [[ $? -ne 0 ]]
    then
        echo "ERROR: couldn't mount QSPI user partition, try erasing partition"

        flash_erase -j $USER_MTD_DEV 0 0
        if [[ $? -ne 0 ]]
        then
            echo "ERROR: failed to erase mtd device $USER_MTD_DEV"
            return 1
        fi

        mount -t jffs2 $USER_MTD_BLOCK $MOUNT_POINT
        if [[ $? -ne 0 ]]
        then
            echo "ERROR: failed to mount QSPI user partition"
            return 1
        fi
    fi

    echo "QSPI user partition successfully mounted"
    return 0
}

copy_log_file_to_qspi () {
    log_file=$1
    destination_filename=$2
    cp $log_file $MOUNT_POINT/$destination_filename
    if [[ $? -ne 0 ]]
    then
        echo "ERROR: failed to copy $log_file to QSPI ($MOUNT_POINT/$destination_filename)"
        return 1
    fi

    echo "Test Results copied to QSPI ($MOUNT_POINT/$destination_filename)"
    return 0
}
