#!/bin/sh

# this file will be installed in /root/bin, and called by cron(/etc/cron.d/lxl-cron-boot

PROG=$(basename $0)

# this is a temp solution for /var/cache in tmpfs

logger -t $PROG "starting..."

# for /var/cache in tmpfs, create these directories
# apt and apt-show-versions might be in tmpfs, create them if necessary
mkdir -p /var/cache/apt
mkdir -p /var/cache/apt-show-versions

# some packages also assume folders created in /var/cache
# such lighttpd/samba/supervisor/polipo/exim4, etc.

# allow normal user to run dmesg
echo 0 > /proc/sys/kernel/dmesg_restrict

# vim: set sw=2 et ts=2:
