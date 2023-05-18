#!/bin/bash

OOB_IMAGE=/home/root/oob_image/BOOT.BIN

cecho(){
    RED="\033[0;31m"
    GREEN="\033[0;32m"  # <-- [0 means not bold
    YELLOW="\033[1;33m" # <-- [1 means bold
    CYAN="\033[1;36m"
    # ... Add more colors if you like

    NC="\033[0m" # No Color

    # printf "${(P)1}${2} ${NC}\n" # <-- zsh
    printf "${!1}${2} ${NC}\n" # <-- bash
}

echo "Installing Out of the Box Image on EMMC"

lsblk -o NAME,LABEL /dev/mmcblk1p1  | grep boot
status=$?

if [ $status -ne 0 ]
then
   cecho "RED" "\n--------- 'boot' partition not found on EMMC. Did you first run the factory tests? ---------"
fi


cp $OOB_IMAGE /run/media/mmcblk1p1
status=$?

if [ $status -ne 0 ]
then
   cecho "RED" "\n--------- Failed to install Out of the Box Image on EMMC. Did you first run the factory tests? ---------"
else
   cecho "GREEN" "\n--------- Out of the Box Image successfully installed on EMMC ---------"
fi

sync
sleep 1
echo ""
