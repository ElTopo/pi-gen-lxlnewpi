#!/bin/sh

# this file will be installed in /root/bin, and called by cron(/etc/cron.d/lxl-boot-cron
#
# this is a temp solution for tmpfs partitions and other default settings
# you may want to create your own service in /etc/init.d/ and remove this cron script
#
# this script deals with various system folders mounsted as tmpfs in memory
# . /var/log: fsck/journal
# . /var/cache: apt/apt-show-versions
# and some other installed packages

PROG=$(basename $0)

# if there's already a 'lxl' service, let it do the work
if [ -r /etc/init.d/lxl ] ; then
  logger -t $PROG "handing over to /etc/init.d/lxl..."
  logger -t $PROG "you should remove /etc/cron.d/lxlnewpi-boot-cron and /root/lxlnewpi/lxlnewpi-boot.sh"
  exit 0
fi

logger -t $PROG "starting..."

# for systemd
# don't use /var/log as systemd's journald storage
# make sure: in /etc/systemd/journald.conf,  Storage= is NOT persistent! (auto or volatile)
# see man journald.conf
rm -rf /var/log/journal

# for /var/cache in tmpfs, create these directories
# apt and apt-show-versions
mkdir -p /var/cache/apt
mkdir -p /var/cache/apt-show-versions

# empty mail
: > /var/mail/mail

# some packages also assume folders created in /var/cache /var/log
# such lighttpd/samba, etc., create them

# for installed lighttpd
if [ -x  /usr/sbin/lighttpd ] ; then
	/usr/bin/install -d -o www-data -g www-data -m 755 /var/log/lighttpd
	/usr/bin/install -d -o www-data -g www-data -m 755 /var/cache/lighttpd/compress
	/usr/bin/install -d -o www-data -g www-data -m 755 /var/cache/lighttpd/uploads
fi

# for installed samba
if [ -x /usr/sbin/samba ] ; then
	/usr/bin/install -d -m 755 /var/log/samba
	/usr/bin/install -d -m 755 /var/cache/samba
fi

# more 3rd party package folders...

# allow normal user to run dmesg
echo 0 > /proc/sys/kernel/dmesg_restrict

# user's own folders in /mnt/ram
if [ -d /mnt/ram/ ] ; then
	# user 'root'
  /usr/bin/install -d -m 755 -o root -g root /mnt/ram/root
  /usr/bin/install -d -m 755 -o root -g root /mnt/ram/root/.local/tmp
  /usr/bin/install -d -m 755 -o root -g root /mnt/ram/root/.local/log
	# user 'lxl'
  /usr/bin/install -d -m 755 -o lxl -g lxl /mnt/ram/lxl
  /usr/bin/install -d -m 755 -o lxl -g lxl /mnt/ram/lxl/.local/tmp
  /usr/bin/install -d -m 755 -o lxl -g lxl /mnt/ram/lxl/.local/log
fi

# vim: set sw=2 et ts=2:
