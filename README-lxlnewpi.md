# pi-gen-lxlnewpi

## Forked from pi-gen with my custom settings

* **always enable openssh-server** on first boot, by installing openssh-server and \
  boot partition ssh file, with sshguard
* use zram device as swap (zram-tools)
* set default locale to US UTF-8, timezone LA, keyboard US
* install the following packages by default:
```
	zram-tools busybox-static sshguard rsyslog tmux vim git tig
	apt-file apt-show-versions overlayroot bvi btop lsof axel
```
* remove the following packages:
```
	dphys-swapfile fake-hwclock udisks2 
```
* put these directories in memory as tmpfs partitions:
```
	/tmp            
	/var/empty      
	/var/mail       
	/var/log        
	/var/cache      
	/var/tmp        
	/mnt/lxlcache   
```
* some quick aliases, custom $PS1 (in \~/lxlp)
* a script (\~/bin/lxl-rb2.sh) to quickly switch between ROFS and RWFS
* skip v8 kernel till later when I get a Pi5/Pi5
* apt autoremove
* defaults:
```
	hostname: lxlnewpi
	first user: lxl
	password: 1234567890
```

### TODOs
. root's cronjob to remount /boot/firmware as 'ro' if it's mounted as 'rw'
. dpkg-pre-invoke script in /etc/apt/apt.conf.d/ to remount /boot/firmware to 'rw' \
  before install/upgrade/remove packages
. configure watchdog(?) to reboot system when memory is low... 

