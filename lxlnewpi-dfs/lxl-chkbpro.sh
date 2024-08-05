#!/bin/bash

# this script checks if boot partition is mounted as 'rw', and tries to
# mount it 'ro'

# add this file to crontab to run it hourly, as
# 0 * * * * root /path/to/lxl-chkbootro.sh

log ()
{
	logger -t lxl-chkbootro $*
  # for debugging...
  # echo "lxl-chkbpro $*"
}

chkbp()
{
  # param: $1: boot partition mount point, such as /boot, /boot/efi, /boot/firmware, etc.)
  local BP="$1"
  # remove '/'s
  local BP0=${BP//\/}
  # ro flag file
  local CHKBPROFLAGF=/mnt/ram/lxl/chk${BP0}ro.flag

  # check if ${BP} is mounted as 'rw'
  MOUNTED=""
  CHKMOUNT=$(findmnt -n -o OPTIONS ${BP})
  if [ -n "$CHKMOUNT" ] ; then
      MOUNTED=${CHKMOUNT:0:2}
  fi

  if [ -z "${MOUNTED}" ]
  then
    # not found, assume this is not a partition, skip it (no logging)
    # echo "${BP} is not mounted as a partition."
    return 0
  fi

  if [ ! "${MOUNTED}" = "rw" ]
  then
    rm -rf ${CHKBPROFLAGF}
    log "${BP} is mounted 'ro'."
    return 0
  fi

  # if ${BP} is mounted as 'rw'
  if [ -f ${CHKBPROFLAGF} ]
  then
    # the flag exists, meaning ${BP} was mounted as 'rw' last time we checked
    log "${BP} is mounted 'rw' and marked, trying to mount it 'ro'..."
    sudo mount -o remount,ro ${BP}
  else
    # create flag file for next checking
    touch ${CHKBPROFLAGF}
    chmod a+rw ${CHKBPROFLAGF}
    log "${BP} is mounted 'rw', mark it."
  fi
}

chkbp "/boot"
chkbp "/boot/firmware"
chkbp "/boot/efi"

# vim: set sw=2 et ts=2:
