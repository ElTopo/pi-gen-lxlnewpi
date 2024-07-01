#!/bin/bash -e

# make sure ssh server is started
touch ${ROOTFS_DIR}/boot/firmware/ssh

# update fstab with lxl's tmpfs partitions
cat ${BASE_DIR}/lxlnewpi-dfs/lxl-tmpfs-fstab >> ${ROOTFS_DIR}/etc/fstab
cp -f ${BASE_DIR}/lxlnewpi-dfs/lxlp  ${ROOTFS_DIR}/home/lxl/

# lxl: remove package(s): dphys-swapfile,fake-hwclock,udisks2
#      and do apt autoremove
on_chroot << EOF
apt purge -y dphys-swapfile fake-hwclock udisks2
apt autoremove -y
EOF

