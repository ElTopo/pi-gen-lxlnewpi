This is a quick note for setting up newly created lxlnewpi system.

This folder, /root/lxlnewpi/, contains quick note (this file, i.e., readme.lxlnewpi.txt),
and some configure files:
. static-eth0.nmconnection				-> /etc/NetworkManager/system-connections/
. Caddyfile.rp8080						-> /etc/caddy/Caddyfile
(configure files of autofs/cron are pre-installed because they don't overwrite package files)

After you properly configured your new system, feel free to delete /root/lxlnewpi/

=======================================================================================
lxlnewpi is designed totally headless, it only needs power + dhcpd ethernet connection.
	.local domain name: lxlnewpi.local
	ssh user: lxl
	password: 1234567890
=======================================================================================

Frist run:
. wait for 3 minutes or so, 'ping lxlnewpi.local' to get replies
. 'ssh-copy-id lxl@lxlnewpi.local' with default password
  (you may need to delete old ssh keys for lxlnewpi.local)
. make sure passwordless 'ssh lxl@lxlnewpi.local' works.
. change users' passwords! (both user 'lxl' and 'root')

1. fix /etc/apt/trusted.gpg issue:
    mv -f /etc/apt/trusted.gpg /etc/apt/trusted.gpg.d/

2. change to static IP on eth0:
   modify static-eth0.nmconnection (line "address1="), 
   then copy it to /etc/NetworkManager/system-connections/
	sudo cp static-eth0.nmconnection /etc/NetworkManager/system-connections/

3. restore user lxl's .ssh keys from backup

4. as user 'root' , do 'crontab -e', add the following lines:
		# lxl
		MAILTO=""

		0 * * * * /usr/local/sbin/lxl-chkbpro.sh

5. as user 'lxl', do 'crontab -e', add the following lines:
		# lxl
		MAILTO=""

		@reboot sleep 600 && apt list > /tmp/aptlist

		0 4 * * * apt list > /tmp/aptlist

6. chenage /etc/default/zramswap:
		PERCENT=80

7. (the last step to do before the first reboot) change hostname:
   edit /etc/hostname and /etc/hosts

========= reboot the system, make sure it works as expected ========

Later:

1. set up git repositories

2. get dotdfs from git repo

# vim: set sw=2 et ts=2:
