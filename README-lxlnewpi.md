# pi-gen-lxlnewpi

## Forked from pi-gen with my custom settings

* **always enable openssh-server**, by installing openssh-server and \
  boot partition ssh file, with sshguard
* use zram as swap (zram-tools)
* set default locale to US UTF-8, timezone LA, keyboard US
* install the following packages by default:
```
	zram-tools busybox-static sshguard rsyslog tmux vim git tig
	apt-file apt-show-versions overlayroot bvi btop lsof axel
```
* remove the following packages:
```
	dphys-swapfile fake-hwclock udisks2. 
```
* put these directories in memory as tmpfs partition:
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
* defaults:
```
	hostname: lxlnewpi
	first user: lxl
	password: 1234567890
```
