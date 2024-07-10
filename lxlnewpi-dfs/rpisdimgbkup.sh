#!/bin/bash

# this script uses dd to create an image of /dev/mmcblk0p2 (rootfs /)

# NOTE: this script only works when the system is running with overlay rootfs

APP=$(basename $0)

DO_SD=0
DO_P1=0
DO_P2=0

usage ()
{
  echo "Usage: ${APP} [sd] [p1] [p2]"
  echo "       sd: create an image of current SD card (/dev/mmcblk0, bootable)"
  echo "       p1: create an image of boot partition (/dev/mmcblk0p1)"
  echo "       p2: create an image of rootfs partition (/dev/mmcblk0p2)"
}

get_fstype ()
{
  [ -z "$1" ] && echo "bad"

	local FSTYPE=$(df --output=fstype $1 2>/dev/null | grep -v ^Type)
	echo ${FSTYPE}
}

# command line options and  args
while [ -n "$1" ]
do
  case "$1" in
    -h|--help)
      usage
      exit 0
    ;;
    sd)
			DO_SD=1
    ;;
    p1)
			DO_P1=1
    ;;
    p2)
			DO_P2=1
    ;;
    *)
      { echo "${APP}: unknown param [$1]!"; usage; exit 1; }
    ;;
  esac
  shift
done

# running with overlayroot?
[ $(get_fstype "/") != "overlay" ] && \
    { echo "${APP}: system is NOT running with overlay rootfs! quit."; exit 1; }

# backup dir OK?
IAMGEBACKUPDIR=~/imagebackupdir
[ ! -d "${IAMGEBACKUPDIR}/" ] && \
    { echo "${APP}: ${IAMGEBACKUPDIR} does not exist! quit."; exit 1; }

[ $(get_fstype "${IAMGEBACKUPDIR}/") != "ext4" ] && \
    { echo "${APP}: ${IAMGEBACKUPDIR} is not ext4! quit."; exit 1; }

# whole sd card
SD=/dev/mmcblk0
# bootpar
P1=/dev/mmcblk0p1
P1FSTYPE="vfat"
# rootfs
P2=/dev/mmcblk0p2
P2FSTYPE="ext4"

# whole sd card/mmcblk0
DATESTR=$(date +"%Y%m%d-%H%M%S")
SDIMAGEF=${IAMGEBACKUPDIR}/$(hostname)-$(basename ${SD})-${DATESTR}.img
if [ ${DO_SD} -ne 0 ] ; then
  echo "$(basename ${SD}) --> ${SDIMAGEF}?"
  read -t 5 -p "===> [y]/n: " yn
  if [ "${yn}" = "y" -o "${yn}" = ""  ]; then
    echo " "
    echo "Ctrl+C to cancel..."
    sudo dd if=${SD} of=${SDIMAGEF} status=progress bs=4M
  fi
  echo " "
fi
# bootpar/mmcblk0p1
DATESTR=$(date +"%Y%m%d-%H%M%S")
P1IMAGEF=${IAMGEBACKUPDIR}/$(hostname)-$(basename ${P1})-${P1FSTYPE}-${DATESTR}.img
if [ ${DO_P1} -ne 0 ]; then 
  echo "$(basename ${P1}) --> ${P1IMAGEF}?"
  read -t 5 -p "===> [y]/n: " yn
  if [ "${yn}" = "y" -o "${yn}" = ""  ]; then
    echo " "
    echo "Ctrl+C to cancel..."
    sudo dd if=${P1} of=${P1IMAGEF} status=progress bs=4M
  fi
  echo " "
fi
# rootfs/mmcblk0p2
DATESTR=$(date +"%Y%m%d-%H%M%S")
P2IMAGEF=${IAMGEBACKUPDIR}/$(hostname)-$(basename ${P2})-${P2FSTYPE}-${DATESTR}.img
if [ ${DO_P2} -ne 0 ]; then
  echo "$(basename ${P2}) --> ${P2IMAGEF}?"
  read -t 5 -p "===> [y]/n: " yn
  if [ "${yn}" = "y" -o "${yn}" = ""  ]; then
    echo " "
    echo "Ctrl+C to cancel..."
    sudo dd if=${P2} of=${P2IMAGEF} status=progress bs=4M
  fi
  echo " "
fi

# vim: set sw=2 et ts=2:
