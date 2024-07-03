#!/bin/sh
#
# lxl's reboot-to script
#
#
# this script call functions in raspi-config script
#
# usage: lxl-rb2.sh [rofs|rwfs|overlay|normal]
#           rofs,overlay:   reboot to ROFS/overlay rootfs
#           rwfs,normal:    reboot to RWFS/normal rootfs
#        use 'sudo' to change system configuration
#
# add the following lines in user's ~/.profile for quick rootfs ref:
#
# grep -q "overlayroot=tmpfs" /proc/cmdline && \
#          printf "\n===== running ROFS =====\n\n" || \
#          printf "\n===== running RWFS =====\n\n"

APP=$(basename $0)

# colors
NC='\033[0m' # No Color
GREEN='\033[0;32m'
RED='\033[0;31m'
REDBELL='\033[0;31m\a'

# check raspi-config
dpkg-query -W raspi-config >/dev/null 2>&1
if [ $? -eq 0 ]
then 
	echo "${GREEN}raspi-config is installed.${NC}"
else
	echo "${RED}raspi-config is not installed!${NC}"
  exit 1
fi

# now running FS (0:ro, 1:rw), bootpar (0:ro, 1:rw)
NOW_FS=0
NOW_BP=0

# configured FS (0:ro, 1:rw), bootpar (0:ro, 1:rw)
CONF_FS=0
CONF_BP=0

# get params
RB2_FS=-1
while [ -n "$1" ]
do
  case "$1" in 
    overlay|rofs)
      RB2_FS=0
    ;;
    normal|rwfs)
      RB2_FS=1
    ;;
    *)
	    echo "${RED}!!!unknown param: [$1]!!! ignored.${NC}"
    ;;
  esac
  shift
done

# calling functions in raspi-config
#   if the function returns a value:
#     if raspi-config nonint func
#     then
#     else
#     fi
#   if the function echos a value:
#     if [ $(raspi-config nonint func) -eq 0 ]
#     then
#     else
#     fi

# check if this system is a RPI
if raspi-config nonint is_pi
then
	echo "${GREEN}This system is a Pi.${NC}"
else
	echo "${RED}This system is not a Pi.${NC}"
fi

# check if this system is running with overlayroot
if [ $(raspi-config nonint get_overlay_now) -eq 0 ]
then
	echo "${RED}This system is running with overlay rootfs [ROFS}.${NC}"
  NOW_FS=0
else
	echo "${GREEN}This system is running with normal rootfs [RWFS}.${NC}"
  NOW_FS=1
fi

# check if this system is configured as overlayroot for next boot
if [ $(raspi-config nonint get_overlay_conf) -eq 0 ]
then
	echo "${RED}This system is configured with overlay rootfs [ROFS] for next boot.${NC}"
  CONF_FS=0
else
	echo "${GREEN}This system is configured with normal rootfs [RWFS] for next boot.${NC}"
  CONF_FS=1
fi
# check if boot partition is mounted 'ro'
if [ $(raspi-config nonint get_bootro_now) -eq 0 ]
then
	echo "${RED}This system's bootpar is mounted as 'ro'.${NC}"
  NOW_BP=0
else
	echo "${GREEN}This system's bootpar is mounted as 'rw'.${NC}"
  NOW_BP=1
fi

# check if boot partition is ro
if [ $(raspi-config nonint get_bootro_conf) -eq 0 ]
then
	echo "${RED}This system's bootpar is configured as 'ro' in fstab.${NC}"
  CONF_BP=0
else
	echo "${GREEN}This system's bootpar is not configured as 'ro' in fstab.${NC}"
  CONF_BP=1
fi

# check if we need to change ro/rw
if [ $RB2_FS -eq -1 ]
then
  # user only wants to check status without any params
  exit 0
fi

if [ $CONF_FS -eq $RB2_FS ]
then
  # echo "CONF FS($CONF_FS) is same as RB2 FS($RB2_FS)"
  echo -n "current system is already configured as 'reboot to "
  if [ $RB2_FS -eq 0 ]
  then
    echo "[ROFS]'"
  else
    echo "[RWFS]'"
  fi
  echo "===> no changes."
  exit 0
fi

UID=$(id -u)
if [ $UID -ne 0 ] 
then
  echo ""
  echo "${RED}use 'sudo' to run this script to change system configuration!${NC}"
  exit 1
fi

if [ $(raspi-config nonint get_bootro_conf) -ne 0 ]
then
  # bootpar is NOT set to 'ro' in fstab
  # always change bootpar to 'ro' in fstab
  if raspi-config nonint enable_bootro
  then
    echo "===> bootpar is configured as 'ro' in fstab."
  else
    echo "${RED}failed to configure bootpar as 'ro' in fstab!${NC}"
  fi
fi

# we need to change ro/rw
if [ $RB2_FS -eq 0 ]
then
  # change to rofs
  if raspi-config nonint enable_overlayfs
  then
    echo "===> system is configured, reboot to 'ROFS'."
  else
    echo "${RED}failed to configure System to 'rofs'!${NC}"
  fi
fi

if [ $RB2_FS -eq 1 ]
then
  # change to rwfs
  if raspi-config nonint disable_overlayfs
  then
    echo "===> system is configured, reboot to 'RWFS'."
  else
    echo "${RED}failed to configure System to 'rwfs'!${NC}"
  fi
fi

# vim: set sw=2 et ts=2:
