#!/bin/bash -e

# make sure ssh server is started
touch ${ROOTFS_DIR}/boot/firmware/ssh

# update /etc/fstab with lxl's tmpfs partitions
cat ${BASE_DIR}/lxlnewpi-dfs/lxl-tmpfs-fstab >> ${ROOTFS_DIR}/etc/fstab
# create /etc/cron.d/lxl-boot-cron
mkdir -p ${ROOTFS_DIR}/etc/cron.d/
cp -f  ${BASE_DIR}/lxlnewpi-dfs/lxl-boot-cron ${ROOTFS_DIR}/etc/cron.d/
# update root's ~/.profile
echo " "  >> ${ROOTFS_DIR}/root/.profile
echo "# lxlp, a temp solution before setting up your dotdfs" >> ${ROOTFS_DIR}/root/.profile
echo ". ~lxl/lxlp" >> ${ROOTFS_DIR}/root/.profile
# create /root/bin/boot.sh
mkdir -p ${ROOTFS_DIR}/root/bin/
cp -f  ${BASE_DIR}/lxlnewpi-dfs/boot.sh ${ROOTFS_DIR}/root/bin/
# create notes/files in /root/lxlnewpi/
mkdir -p ${ROOTFS_DIR}/root/lxlnewpi/
cp -f  ${BASE_DIR}/lxlnewpi-dfs/readme.lxlnewpi.txt ${ROOTFS_DIR}/root/lxlnewpi/
cp -f  ${BASE_DIR}/lxlnewpi-dfs/static-eth0.nmconnection ${ROOTFS_DIR}/root/lxlnewpi/
# create dpkg-pre-invoke script
mkdir -p ${ROOTFS_DIR}/etc/apt/apt.conf.d/ ${ROOTFS_DIR}/usr/local/bin/ ${ROOTFS_DIR}/usr/local/sbin/
cp -f  ${BASE_DIR}/lxlnewpi-dfs/lxl-dpkg-pre-invoke.sh ${ROOTFS_DIR}/usr/local/sbin/
cp -f  ${BASE_DIR}/lxlnewpi-dfs/55lxl-dpkg-pre-invoke ${ROOTFS_DIR}/etc/apt/apt.conf.d/
# add various lxl-* script in /usr/local/bin or /usr/local/sbin
cp -f  ${BASE_DIR}/lxlnewpi-dfs/lxl-rpisdimgbkup.sh ${ROOTFS_DIR}/usr/local/sbin/
cp -f  ${BASE_DIR}/lxlnewpi-dfs/lxl-rb2.sh ${ROOTFS_DIR}/usr/local/sbin/
cp -f  ${BASE_DIR}/lxlnewpi-dfs/lxl-bms.sh ${ROOTFS_DIR}/usr/local/bin/
cp -f  ${BASE_DIR}/lxlnewpi-dfs/lxl-chkbpro.sh ${ROOTFS_DIR}/usr/local/sbin/
# create /etc/auto.master.d/lxlusb.autofs and /etc/auto.lxlusb
mkdir -p ${ROOTFS_DIR}/etc/auto.master.d/
cp -f  ${BASE_DIR}/lxlnewpi-dfs/lxlusb.autofs ${ROOTFS_DIR}/etc/auto.master.d/
cp -f  ${BASE_DIR}/lxlnewpi-dfs/auto.lxlusb ${ROOTFS_DIR}/etc/
# update ~/.profile
echo " "  >> ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.profile
echo "# lxlp, a temp solution before setting up your dotdfs" >> ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.profile
echo ". ~/lxlp" >> ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.profile
# create ~lxl/lxlp
install -v -o 1000 -g 1000 -m 0644 -D ${BASE_DIR}/lxlnewpi-dfs/lxlp ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/lxlp
# create ~/bin/lxl-rb2.sh
install -v -o 1000 -g 1000 -d ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/bin

# lxl: remove package(s): dphys-swapfile,fake-hwclock,udisks2
#      and do apt autoremove
on_chroot << EOF
apt purge -y dphys-swapfile fake-hwclock udisks2
apt autoremove -y
EOF

