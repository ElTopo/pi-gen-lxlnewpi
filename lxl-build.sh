#!/bin/bash 

# NOTE: to clean build, sudo rm -rf <work dir>

APP=$(basename $0)

# build lxlnewpios lite (stage2)
touch ./stage3/SKIP ./stage4/SKIP ./stage5/SKIP
touch ./stage4/SKIP_IMAGES ./stage5/SKIP_IMAGES

# source my config file so the script gets env $IMG_NAME
source ./lxlnewpi-dfs/lxlnewpi-config

# bootstrap does not like partitions mounted by autofs
# set up work dir and use a local filesystem image to fix the issue
WORKFSIMAGE="./.lxlnewpiwork.img"
if [ ! -f "${WORKFSIMAGE}" ] ; then
  echo "${APP}: workfsimage [$WORKFSIMAGE] is not found, creating it..."
  # create the image file (32GB, should be enough)
  SIZE32GB=$(( 32*1024*1024 ))
  BS=1024
  dd if=/dev/zero of="${WORKFSIMAGE}" bs=${BS} count=${SIZE32GB} status=progress
  mkfs.ext4 "${WORKFSIMAGE}"
fi
# mount point dir for the  that's not mounted by autofs/automount
MPDIR="/dev/shm/lxlnewpi"
grep -q "${MPDIR}" /proc/mounts
if [ $? -ne 0 ] ; then
  # before mounting the image, check it
  fsck.ext4 -y "${WORKFSIMAGE}"
  sudo mkdir -p "${MPDIR}"
  sudo mount "${WORKFSIMAGE}" "${MPDIR}" || \
      { echo "${APP}: failed to mount [${MPDIR}!"; exit 1; }
fi

WORKDIR="${MPDIR}/work/"

CFGF=/dev/shm/lxlnewpi-config
cp -f ./lxlnewpi-dfs/lxlnewpi-config ${CFGF}
echo " " >> ${CFGF}
echo "# work dir, make sure it's mounted outside of autofs partitions!" >> ${CFGF}
echo "WORK_DIR=\"${WORKDIR}\"" >> ${CFGF}

# clean before build if it has arg "cleanbuild"
[ "$1" = "cleanbuild" ] && sudo rm -rf ${WORKDIR}

echo "$APP: start building [$IMG_NAME]..."
sudo ./build.sh -c ${CFGF}

[ $? -eq 0 ] && echo "$APP: built OK." || echo "$APP: built failed with problem(s)!"
echo "$APP: Check [${WORKDIR}/$IMG_NAME/build.log] for details."

# vim: set sw=2 et ts=2:
