#!/bin/bash -e

# make sure ssh server is started
touch ${ROOTFS_DIR}/boot/firmware/ssh

# update fstab with lxl's tmpfs partitions
cat ${BASE_DIR}/lxlnewpi-dfs/lxl-tmpfs-fstab >> ${ROOTFS_DIR}/etc/fstab
echo " "  >> ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.profile
echo "# lxlp, a temp solution before setting up your dotdfs"  >> ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.profile
echo ". ~/lxlp"  >> ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.profile
install -v -o 1000 -g 1000 -d ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/bin
install -v -o 1000 -g 1000 -D ${BASE_DIR}/lxlnewpi-dfs/lxlp ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/lxlp
install -v -o 1000 -g 1000 -D  ${BASE_DIR}/lxlnewpi-dfs/lxl-rb2.sh ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/bin/lxl-rb2.sh

# lxl: remove package(s): dphys-swapfile,fake-hwclock,udisks2
#      and do apt autoremove
on_chroot << EOF
apt purge -y dphys-swapfile fake-hwclock udisks2
apt autoremove -y
EOF

