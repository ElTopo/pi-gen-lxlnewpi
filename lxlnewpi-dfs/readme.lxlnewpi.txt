This is a quick note for setting up lxlnew pi system.

1. fix /etc/apt/trusted.gpg issue:
    mv -f /etc/apt/trusted.gpg /etc/apt/trusted.gpg.d/

2. change to static IP on eth0:
   modify static-eth0.nmconnection (line "address1="), 
   then copy it to /etc/NetworkManager/system-connections/
	sudo cp static-eth0.nmconnection /etc/NetworkManager/system-connections/

3. change hostname:
   edit /etc/hostname and /etc/hosts

4. restore .ssh keys from backup

5. get dotdfs from git

