#!/bin/bash

# this script is a generic pre-invoke for dpkg

# make sure some read-only directories e.g., (/boot, /boot/efi, /boot/firmware, etc.) get re-mounted r/w
# copy 55lxl-dpkg-pre-invoke to /etc/apt/apt.conf.d/

PROGNAME="lxl-dpkg-pre-invoke.sh"

log ()
{
	logger -t ${PROGNAME} $*
}

process_part ()
{
	# params:
  # $1: part dir (e.g., /boot)

  local PARTDIR="$1"
  local PARTDIR0=${PARTDIR//\/}
  local ROFLAG=/mnt/ram/lxl/chk${PARTDIR0}ro.flag

  # check if ${PARTDIR} is mounted as 'ro'
  MOUNTED=""
  CHKMOUNT=$(findmnt -n -o OPTIONS ${PARTDIR})
  if [ -n "$CHKMOUNT" ] ; then
      MOUNTED=${CHKMOUNT:0:2}
  fi

  # either ${PARTDIR} is not a parition or it is not mounted as 'ro'
  if [ -z "${MOUNTED}" -o ! "${MOUNTED}" = "ro" ]
  then
    # we are done for this partition
    return 0
  fi

  # we need to remount ${PARTDIR} as 'rw'
  rm -rf ${ROFLAG}
  log "trying to remount ${PARTDIR} as 'rw'..."
  sudo mount -o remount,rw ${PARTDIR}
  return $?
}

# /boot partition: old raspbian
process_part /boot
# /boot/firmware partition: new raspbian
process_part /boot/firmware
# /boot/efi partition: ubuntu
process_part /boot/efi

# vim: set sw=2 et ts=2:
