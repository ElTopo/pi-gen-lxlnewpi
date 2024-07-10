#!/bin/bash -e

# make sure ssh server is started
touch ${ROOTFS_DIR}/boot/firmware/ssh

# update /etc/fstab with lxl's tmpfs partitions
cat ${BASE_DIR}/lxlnewpi-dfs/lxl-tmpfs-fstab >> ${ROOTFS_DIR}/etc/fstab
# create /etc/cron.d/lxl-tmpfs-boot-cron
mkdir -p ${ROOTFS_DIR}/etc/cron.d/
cp -f  ${BASE_DIR}/lxlnewpi-dfs/lxl-tmpfs-boot-cron ${ROOTFS_DIR}/etc/cron.d/
# create /root/bin/tmpfs-boot.sh
mkdir -p ${ROOTFS_DIR}/root/bin/
cp -f  ${BASE_DIR}/lxlnewpi-dfs/tmpfs-boot.sh ${ROOTFS_DIR}/root/bin/
# create /root/bin/rpisdimgbkup.sh
cp -f  ${BASE_DIR}/lxlnewpi-dfs/rpisdimgbkup.sh ${ROOTFS_DIR}/root/bin/
# update ~/.profile
echo " "  >> ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.profile
echo "# lxlp, a temp solution before setting up your dotdfs" >> ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.profile
echo ". ~/lxlp" >> ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.profile
# create ~/lxlp
install -v -o 1000 -g 1000 -m 0644 -D ${BASE_DIR}/lxlnewpi-dfs/lxlp ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/lxlp
# create ~/bin/lxl-rb2.sh
install -v -o 1000 -g 1000 -d ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/bin
install -v -o 1000 -g 1000 -m 0755 -D ${BASE_DIR}/lxlnewpi-dfs/lxl-rb2.sh ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/bin/lxl-rb2.sh

# lxl: remove package(s): dphys-swapfile,fake-hwclock,udisks2
#      and do apt autoremove
on_chroot << EOF
apt purge -y dphys-swapfile fake-hwclock udisks2
apt autoremove -y
EOF

