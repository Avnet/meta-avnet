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

echo "Installing Out of the Box Image on Flash memory"
flashcp $OOB_IMAGE /dev/mtd0 -v
status=$?

if [ $status -ne 0 ]
then
   cecho "RED" "\n--------- Failed to install Out of the Box Image on Flash memory ---------"
else
   cecho "GREEN" "\n--------- Out of the Box Image successfully installed on Flash memory ---------"
fi

sleep 2
echo ""
