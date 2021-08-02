# ArchLinux

## Description

Auto installation setup for ArchLinux operating system using Virt-Manager.

## Final result demo

By default the script auto identify if you are trying to install the ArchLinux in a **physical machine** or in a **virtual machine**. So, do not worry about `/dev/sda` or `/dev/vda` devices.

- Option 1 (recommended for physical machine)

|Device     |Size   	|Type              	|Filesystem
|---        |---    	|---               	|---
|/dev/sda1  |512M		|EFI System			|vfat
|/dev/sda2  |**xxxG**	|Linux filesystem   |btrfs
|/dev/sda3	|8G			|Linux filesystem   |swap

- Option 2 (recommended for virtual machine)

|Device     |Size   	|Type               |Filesystem
|---        |---    	|---                |---
|/dev/sda1  |512M		|EFI System			|vfat
|/dev/sda2  |**xxxG**	|Linux filesystem   |btrfs

- Notes
	1. Replace **xxxG** according with your storage space.
	1. In the second option the SWAP is going to be created as a SWAP file.
	1. If you want to make a dual boot with this script (**not recommended**), you must edit the variables values on`./main.sh` file according to your needs.

## Installation setup

As long as the script runs it is going to ask you about the settings you need. Some times the script is going to open the file with the editor for you manually configuring it according to your preferences.

I strongly suggest you to read the scripts while executing it. The script is documented and it explains what you must do in each situation.

<!--
### Step number zero (preparing the virtual-manager)

- Virtual Machine Manager:
	1. Click on **Info** buttom.
	1. Click on **IDE CDROM 1** buttom.
	1. Erase all the **source path** text.
	1. Run the ArchLinux virtual machine.
	1. Select **ArchLinux GNU/Linux** option on GRUB bootloader screen.
	1. Login your ArchLinux credentials.
-->

### Step number 1 (livecd mode)

- Download the variable file script, give executable permission and execute the variable file script.
	> $ `curl -L -O https://raw.githubusercontent.com/henrikbeck95/testing/main/archlinux/main.sh && chmod +x ./main.sh && ./main.sh`

- Execute the **livecd mode** script.
	> $ `./archlinux_part_1.sh`

### Step number 2 (chroot mode)

- Download the variable file script, give executable permission and execute the variable file script.
	> $ `curl -L -O https://raw.githubusercontent.com/henrikbeck95/testing/main/archlinux/main.sh && chmod +x ./main.sh && ./main.sh`

- Go to `/root/` directory and execute the **chroot mode** script.
	> $ `cd /root/ && ./archlinux_part_2.sh`

- Once the script gets finished, exit from the **chroot mode** and go back to the **livecd mode**.
	> $ `exit`

- Unmount all the **BTRFS** partitions at once (do not worry about receiving a `target is busy` message).
    > \# `umount -a`

- Restart the machine (or the virtual machine)
    > \# `systemctl reboot`

- Notes
	1. In case you are installing on a virtual machine, consider to backup your virtual machine cloning it.
	1. In case you are using a physical machine, remove the USB pendrive device when the screen turns off and before the machine restart.

<!--
### Step number 3 (drivers)

Be aware to execute this step procedure after reboot the machine. This can be very helpful for detecting problems in case of needing.

At this point you have a totally clean ArchLinux operating system installed on your machine. Otherwise there are still a lot of work to do such as installing drivers, softwares tools and a graphical interface. If you did not remove the files after the setup installation you can reuse them. In the other hand, if you did, you should download them again (unless you decide to make it by yourself).

- Login as **Root** user.
	> $ `sudo su`

- Go to `/root/` directory and execute the script.
	> $ `cd /root/ && ./archlinux_part_3.sh`

### Step number 4 (graphical interface)

### Step number 5 (software tools)
-->

## Troubleshoots

In case of troubles this is the first place where you should read before searching in all the web along.

- The most common troubleshoots you might have are:
	1. BIOS does not detect UEFI (Virt-Manager).
		> If you are using Virt-Manager, **while** creating the virtual machine (on step 5 of 5) enable the **Customize configuration before install** option. The overview screen is going to be opened. You must change the **Firmware** from **BIOS** to **UEFI x86_64:/usr/share/OVMF/OVMF_CODE.fd** option. Apply the changes and click on **Begin installation** button.

	1. Disk partition.
		> Stop the script executing and reboot your physical machine or delete the virtual machine. Finally restart the script from the begin (first step).

	1. Edit some file with wrong information.
		> Stop the script executing and re-run the script again, again and again.

	1. GRUB
		> GRUB installation for BIOS legacy is incomplete, you have to do this procedure manually as long this function is not implemented. By the way, take a look into **BIOS does not detect UEFI (Virt-Manager)** troubleshoot maybe it might help you.
	
	1. If you need remount the ArchLinux as chroot mode, try:
		> Mounting the root partition: $ `mount $PARTITION_ROOT /mnt/`
		
		> Mounting root subvolume: $ `mount -o compress=lzo,subvol=@ $PARTITION_ROOT /mnt/`
		
		> Creating subvolumes for BTRFS: $ `cd /mnt/@/root`
		
		> Mounting boot: $ `mkdir -p /mnt/boot/efi && mount /dev/vda1 /mnt/boot/efi/`
		
		> Listing all the partition table: $ `lsblk`