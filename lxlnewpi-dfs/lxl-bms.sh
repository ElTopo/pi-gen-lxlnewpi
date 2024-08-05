#!/bin/bash

# this script checks if /boot | /boot/firmware | /boot/efi partition is mounted as 'rw' or 'ro'

bms ()
{
  BOOT="$1"
  # check if ${BOOT} is mounted as 'rw'
  MOUNTED=""
  CHKMOUNT=$(findmnt -n -o OPTIONS ${BOOT})
  if [ -n "$CHKMOUNT" ] ; then
      MOUNTED=${CHKMOUNT:0:2}
  fi

  if [ -z "${MOUNTED}" ]; then
    return 0
  fi
    
  echo "${BOOT} is mounted '${MOUNTED}'."
}

# old raspbian
bms /boot
# new raspbian
bms /boot/firmware
# ubuntu
bms /boot/efi
# more partitions to check...

# vim: set sw=2 et ts=2:
