This is a quick note for setting up lxlnewpi system.

lxlnewpi is designed totally headless, it only needs power + dhcpd ethernet connection.

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

3. as user 'root' , do 'crontab -e', add the following lines:
		# lxl
		MAILTO=""

		0 * * * * /usr/local/sbin/lxl-chkbpro.sh

4. as user 'lxl', do 'crontab -e', add the following lines:
		# lxl
		MAILTO=""

		@reboot sleep 600 && apt list > /tmp/aptlist

		0 4 * * * apt list > /tmp/aptlist

5. chenage /etc/default/zramswap:
		PERCENT=80

6. (before reboot) change hostname:
   edit /etc/hostname and /etc/hosts

========= reboot the system, make sure it works as expected ========

Later:
1. restore user lxl's .ssh keys from backup

2. get dotdfs from git

