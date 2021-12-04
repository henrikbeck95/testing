# Gentoo

## Description

Auto installation setup for Gentoo operating system on Virt-Manager (still in beta and coding).

## References

- [Gentoo official documentation](https://wiki.gentoo.org/wiki/Handbook:X86/Full/Installation/pt-br).

- [How to install Gentoo Linux - part 1](https://www.youtube.com/watch?v=q9_sXkA4Rv8).

- [How to install Gentoo Linux - part 2](https://www.youtube.com/watch?v=wQxBsunITaA).

- [How to install Gentoo packages (part 3)](https://www.youtube.com/watch?v=Oq6EQZ0q4tE).

- [Como Instalar o Gentoo](https://www.youtube.com/watch?v=BD1wIoX0E2c).

## Installation setup

### First step (livecd mode):

- Download the variable file script, give executable permission and execute the variable file script.
	> $ `curl -L -O https://raw.githubusercontent.com/henrikbeck95/testing/main/gentoo/main.sh && chmod +x ./main.sh && ./main.sh`

- Execute the **livecd mode** script.
	> $ `./gentoo_part_1.sh`

### Second step (chroot mode):

- Download the variable file script, give executable permission and execute the variable file script.
	> $ `curl -L -O https://raw.githubusercontent.com/henrikbeck95/testing/main/gentoo/main.sh && chmod +x ./main.sh && ./main.sh`

- Go to `/root/` directory and execute the **chroot mode** script.
	> $ `cd /root/ && ./gentoo_part_2.sh`

- Once the script gets finished, exit from the **chroot mode**.
	> $ `exit`

- Now, back on **livecd mode** go to the $HOME directory.
	> $ `cd`

- Unmount the partitions.
	>  $ `umount -l /mnt/gentoo/dev{/shm,/pts,}`
	>  $ `umount -R /mnt/gentoo`

- Power off the virtual machine.
	>  $ `shutdown now` or $ `reboot` or just force power off.

### Third step (after reboot):

- Virtual Machine Manager:
	1. Click on **Info** buttom.
	1. Click on **IDE CDROM 1** buttom.
	1. Erase all the **source path** text.
	1. Run the Gentoo virtual machine.
	1. Select **Gentoo GNU/Linux** option on GRUB bootloader screen.
	1. Login your Gentoo credentials.

- Download the variable file script, give executable permission and execute the variable file script.
	> $ `curl -L -O https://raw.githubusercontent.com/henrikbeck95/testing/main/gentoo/main.sh && chmod +x ./main.sh && ./main.sh`

- Go to `/root/` directory and execute the **chroot mode** script.
	> $ `cd /root/ && ./gentoo_part_3.sh`