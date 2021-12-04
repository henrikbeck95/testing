# ArchLinux

## Description

This is an auto installation setup method for ArchLinux operating system. It can detect if the installation setup is running on physical machine or using Virt-Manager to apply the right settings, install the softwares and customize the appearance.

By default it brings KDE Plasma as desktop environment but you can change it by editing the executable scripts.

## References

- [Instalasi Driver Espon L120 pada Arch Linux](https://www.muntaza.id/printer/2019/12/30/arch-linux-printer-epson-l120.html)

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

### Step #1 (livecd mode)

- Download the variable file script, give executable permission and execute the variable file script.
	> $ `curl -L -O https://raw.githubusercontent.com/henrikbeck95/testing/main/archlinux/main.sh && chmod +x ./main.sh && ./main.sh`

- Execute the **livecd mode** script.
	> $ `./archlinux_part_1.sh`

### Step #2 (chroot mode)

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
### Step #3 (drivers)

Be aware to execute this step procedure after reboot the machine. This can be very helpful for detecting problems in case of needing.

At this point you have a totally clean ArchLinux operating system installed on your machine. Otherwise there are still a lot of work to do such as installing drivers, softwares tools and a graphical interface. If you did not remove the files after the setup installation you can reuse them. In the other hand, if you did, you should download them again (unless you decide to make it by yourself).

- Login as **Root** user.
	> $ `sudo su`

- Go to `/root/` directory and execute the script.
	> $ `cd /root/ && ./archlinux_part_3.sh`

### Step #4 (graphical interface)

### Step #5 (software tools)
-->

### Troubleshoots

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
	
	<!--
	1. If the operating system does not boot
		> Open Virtual Machine Manager software.

		> Select a **virtual machine**.

		> Click on **Info** buttom.
		
		> Click on **IDE CDROM 1** buttom.
		
		> Erase all the **source path** text.
		
		> Run the ArchLinux virtual machine.
		
		> Select **ArchLinux GNU/Linux** option on GRUB bootloader screen.
		
		> Login your ArchLinux credentials.
	-->

## Linux

### Commands

- Get Linux distro name
	> $ `lsb_release -a`

- List of desktop environments (GNOME; Xfce; KDE).
	> $ `echo $XDG_SESSION_DESKTOP`

- Open website link on browser
	> $ `xdg-open <website_link>`

- Open Dolphin file manager as root
	> $ `sudo pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY KDE_SESSION_VERSION=5 KDE_FULL_SESSION=true dbus-launch dolphin`

### Backup

- Timeshift

```bash
#Change Timeshift engine
#sudo timeshift --rsync
sudo timeshift --btrfs

#Linux all snapshots
sudo timeshift --list

#Delete a snapshot
#sudo btrfs subvolume delete /run/timeshift/backup/timeshift-btrfs/snapshots/2021-11-25_11-44-35/@/var/lib/portables/
#sudo btrfs subvolume delete /run/timeshift/backup/timeshift-btrfs/snapshots/2021-11-25_11-44-35/@/var/lib/machines/
#sudo btrfs subvolume delete /run/timeshift/backup/timeshift-btrfs/snapshots/2021-11-25_11-44-35/@/

#sudo rm -fr /run/timeshift/backup/timeshift-btrfs/snapshots/2021-11-25_11-44-35/@/var/lib/portables/
#sudo rm -fr /run/timeshift/backup/timeshift-btrfs/snapshots/2021-11-25_11-44-35/@/var/lib/machines/
#sudo rm -fr /run/timeshift/backup/timeshift-btrfs/snapshots/2021-11-25_11-44-35/@/

sudo timeshift --delete --snapshot '2021-11-25_11-44-35'

#Check Timeshift snapshots storage
sudo lf /run/timeshift/backup/timeshift-btrfs/snapshots/

#Create a snapshot
sudo timeshift --create --comments "After ArchLinux downgrade to linux-lts-5.10.82-1" --tags D
```

### GitHub

#### User info

- [GitHub API - Henrik's profile info](https://api.github.com/users/henrikbeck95)

- [GitHub API - Henrik's profile pricture](https://avatars.githubusercontent.com/u/52793108?v=4)

#### Repositories

- Git credentials

```bash
git config --global user.name "Henrik Beck"
git config --global user.email "henrikbeck95@gmail.com"

git config --global credential.helper store
git clone https://github.com/henrikbeck95/voice_assistant_linux.git $HOME/Documents/voice_assistant_linux
cd $HOME/Documents/voice_assistant_linux
git checkout development
```

- Git branches

```bash
#List all branches available
git branch -a

#Change branch
git checkout syncing

#Delete branch locally
git branch -d <local_branch_name>

#Delete branch remotelly
git push origin --delete <remote_branch_name>

#Upload all changes
git push --all origin

#Display commit history
git log --oneline
```

## Appearance

### Desktop environment

|Desktop environment	|Category				|Subcategory				|???										|???
|---					|---					|---						|---										|---
|KDE Plasma				|Appearance				|Global theme				|???										|Breeze Dark
|KDE Plasma				|Appearance				|Application style			|???										|Breeze
|KDE Plasma				|Appearance				|Plasma style				|???										|Materia
|KDE Plasma				|Appearance				|Colors						|???										|Dracula
|KDE Plasma				|Appearance				|Window decoration			|???										|Breeze
|KDE Plasma				|Appearance				|Icons						|???										|Bonny-Dark-Icons
|KDE Plasma				|Appearance				|Cursors					|???										|"Nordzy-Cursors"
|KDE Plasma				|Appearance				|Splash screen				|???										|Dracula
|KDE Plasma				|Workspace behavior		|General behavior			|Clicking files or folders					|Selects theme (Open by double-clicking instead)
|KDE Plasma				|Workspace behavior		|Desktop effects			|Accssibility								|Magnifier
|KDE Plasma				|Workspace behavior		|Desktop effects			|Appearance									|Desature unresponsive applications
|KDE Plasma				|Workspace behavior		|Desktop effects			|Appearance									|Fading popups
|KDE Plasma				|Workspace behavior		|Desktop effects			|Appearance									|Full screen
|KDE Plasma				|Workspace behavior		|Desktop effects			|Appearance									|Login
|KDE Plasma				|Workspace behavior		|Desktop effects			|Appearance									|Logout
|KDE Plasma				|Workspace behavior		|Desktop effects			|Appearance									|Maximize
|KDE Plasma				|Workspace behavior		|Desktop effects			|Appearance									|Morphing popups
|KDE Plasma				|Workspace behavior		|Desktop effects			|Appearance									|Screen edges
|KDE Plasma				|Workspace behavior		|Desktop effects			|Appearance									|Sliding popups
|KDE Plasma				|Workspace behavior		|Desktop effects			|Appearance									|Magic lamp
|KDE Plasma				|Workspace behavior		|Desktop effects			|Show desktop animation						|Window aperture
|KDE Plasma				|Workspace behavior		|Desktop effects			|Tools										|null
|KDE Plasma				|Workspace behavior		|Desktop effects			|Virtual desktop switching animation		|Slide
|KDE Plasma				|Workspace behavior		|Desktop effects			|Window management							|Desktop grid
|KDE Plasma				|Workspace behavior		|Desktop effects			|Window management							|Present windows
|KDE Plasma				|Workspace behavior		|Desktop effects			|Window open/close animation				|Fade
|KDE Plasma				|Workspace behavior		|Screen edges				|Screen corner top left						|Application launcher
|KDE Plasma				|Workspace behavior		|Screen edges				|Screen corner top right					|Show desktop
|KDE Plasma				|Workspace behavior		|Screen edges				|Screen corner bottom left					|Present windows - all destops
|KDE Plasma				|Workspace behavior		|Screen edges				|Screen corner bottom right					|Present windows - current desktop
|KDE Plasma				|Workspace behavior		|Screen edges				|Others										|Maximize windows dragged to top edge
|KDE Plasma				|Workspace behavior		|Screen edges				|Others										|Tile windows dragged to let or right top edge
|KDE Plasma				|Workspace behavior		|Screen edges				|Others										|Trigger quarter tiling in **outer 25%** of the screen
|KDE Plasma				|Workspace behavior		|Screen edges				|Others										|Switch desktop on edge **disabled**
|KDE Plasma				|Workspace behavior		|Screen edges				|Others										|Activation delay **0 ms**
|KDE Plasma				|Workspace behavior		|Screen edges				|Others										|Reactivation delay **350 ms**
|KDE Plasma				|Workspace behavior		|Touch screen				|null										|null
|KDE Plasma				|Workspace behavior		|Screen locking				|Lock screen automatically					|After waking from sleep
|KDE Plasma				|Workspace behavior		|Screen locking				|Allow unlocking withou password for		|5 seconds
|KDE Plasma				|Workspace behavior		|Screen locking				|Keyboad shortcut							|Meta + L
|KDE Plasma				|Workspace behavior		|Screen locking				|Appearance									|dracula-purplish
|KDE Plasma				|Workspace behavior		|Virtual desktops			|Row 1										|Desktop 1 - 20
|KDE Plasma				|Workspace behavior		|Virtual desktops			|Options									|Navigation wraps around
|KDE Plasma				|Workspace behavior		|Virtual desktops			|Options									|Show animation when switching **slide**
|KDE Plasma				|Workspace behavior		|Virtual desktops			|Options									|Show on-screen display when switching **1.000 ms**
|KDE Plasma				|Workspace behavior		|Virtual desktops			|Options									|Show desktop layout indicators
|KDE Plasma				|Workspace behavior		|Activities					|Default									|null
|KDE Plasma				|Window management		|Window behavior			|Focus										|Window activation policy **focus follows mouse**
|KDE Plasma				|Window management		|Window behavior			|Focus										|Delay focus by **50 ms**
|KDE Plasma				|Window management		|Window behavior			|Focus										|Focus stealing prevention **low**
|KDE Plasma				|Window management		|Window behavior			|Focus										|Raising stealing prevention **click raises active window**
|KDE Plasma				|Window management		|Window behavior			|Titlebar actions							|Double click **maximize**
|KDE Plasma				|Window management		|Window behavior			|Titlebar actions							|Mouse wheel **do nothing**
|KDE Plasma				|Window management		|Window behavior			|Titlebar and frame actions					|Active left click **raise**
|KDE Plasma				|Window management		|Window behavior			|Titlebar and frame actions					|Inactive left click **activate and raise**
|KDE Plasma				|Window management		|Window behavior			|Titlebar and frame actions					|Active middle click **do nothing**
|KDE Plasma				|Window management		|Window behavior			|Titlebar and frame actions					|Inactive middle click **do nothing**
|KDE Plasma				|Window management		|Window behavior			|Titlebar and frame actions					|Active right click **show actions menu**
|KDE Plasma				|Window management		|Window behavior			|Titlebar and frame actions					|Active right click **show actions menu**
|KDE Plasma				|Window management		|Window behavior			|Maximize button actions					|Left click **maximize**
|KDE Plasma				|Window management		|Window behavior			|Maximize button actions					|Middle click **vertically maximize**
|KDE Plasma				|Window management		|Window behavior			|Maximize button actions					|Right click **horizontally maximize**
|KDE Plasma				|Window management		|Window behavior			|Inactive inner window actions				|Left click **activate, raise and pass click**
|KDE Plasma				|Window management		|Window behavior			|Inactive inner window actions				|Middle click **activate and pass click**
|KDE Plasma				|Window management		|Window behavior			|Inactive inner window actions				|Right click **activate and pass click**
|KDE Plasma				|Window management		|Window behavior			|Inactive inner window actions				|Mouse wheel **scroll**
|KDE Plasma				|Window management		|Window behavior			|Inner window, titlebar and frame actions	|Modifier key **meta**
|KDE Plasma				|Window management		|Window behavior			|Inner window, titlebar and frame actions	|Left click **move**
|KDE Plasma				|Window management		|Window behavior			|Inner window, titlebar and frame actions	|Middle click **toggle raise and lower**
|KDE Plasma				|Window management		|Window behavior			|Inner window, titlebar and frame actions	|Right click **resize**
|KDE Plasma				|Window management		|Window behavior			|Inner window, titlebar and frame actions	|Mouse wheel **do nothing**
|KDE Plasma				|Window management		|Window behavior			|Movement									|Window geometry **display when moving or resizing**
|KDE Plasma				|Window management		|Window behavior			|Movement									|Screen edge snap zone **10 px**
|KDE Plasma				|Window management		|Window behavior			|Movement									|Window snap zone **10 px**
|KDE Plasma				|Window management		|Window behavior			|Movement									|Center snap zone **none**
|KDE Plasma				|Window management		|Window behavior			|Advances									|Window unshading **259 ms**
|KDE Plasma				|Window management		|Window behavior			|Advances									|Window placement **centered**
|KDE Plasma				|Window management		|Window behavior			|Advances									|Special windows **hode utility windows for inactive applications
|KDE Plasma				|Window management		|Task switcher				|Main visualization							|Show selected window
|KDE Plasma				|Window management		|Task switcher				|Main visualization							|Thumbnail grid
|KDE Plasma				|Window management		|Task switcher				|Main shortcuts								|All windows forward **ALT + Tab**
|KDE Plasma				|Window management		|Task switcher				|Main shortcuts								|All windows reverse **ALT + SHIFT + Tab**
|KDE Plasma				|Window management		|Task switcher				|Main shortcuts								|Current application forward **`**
|KDE Plasma				|Window management		|Task switcher				|Main shortcuts								|Current application reverse **~**
|KDE Plasma				|Window management		|Task switcher				|Main content								|Sort order **recently used**
|KDE Plasma				|Window management		|Task switcher				|Main filter windows by						|Virtual desktops **current desktop**
|KDE Plasma				|Window management		|Task switcher				|Main filter windows by						|Activities **current activity**
|KDE Plasma				|Window management		|Task switcher				|Alternative visualization					|Show selected window
|KDE Plasma				|Window management		|Task switcher				|Alternative visualization					|Breeze
|KDE Plasma				|Window management		|Task switcher				|Alternative shortcuts						|All windows forward **none**
|KDE Plasma				|Window management		|Task switcher				|Alternative shortcuts						|All windows reverse **none**
|KDE Plasma				|Window management		|Task switcher				|Alternative shortcuts						|Current application forward **none**
|KDE Plasma				|Window management		|Task switcher				|Alternative shortcuts						|Current application reverse **none**
|KDE Plasma				|Window management		|Task switcher				|Alternative content						|Sort order **recently used**
|KDE Plasma				|Window management		|Task switcher				|Alternative filter windows by				|Virtual desktops **current desktop**
|KDE Plasma				|Window management		|Task switcher				|Alternative filter windows by				|Activities **current activity**
|KDE Plasma				|Window management		|Kwin scripts				|default									|null
|KDE Plasma				|Window management		|Window rules				|default									|null
|KDE Plasma				|Shortcuts				|Shortcuts					|Alacritty									|CTRL + ALT + T
|KDE Plasma				|Shortcuts				|Shortcuts					|Dolphin									|CTRL + E
|KDE Plasma				|Shortcuts				|Shortcuts					|SPECTACLE									|CTRL + PrtSc
|KDE Plasma				|Startup and shutdown	|Login screen (SDDM)		|main										|Dracula (Eliver Lara)
|KDE Plasma				|Startup and shutdown	|Autostart					|null										|Libinput gestures
|KDE Plasma				|Startup and shutdown	|Autostart					|null										|Yakuake
|KDE Plasma				|Startup and shutdown	|Background services		|all										|all
|KDE Plasma				|Startup and shutdown	|Desktop session			|General									|Confirm logout
|KDE Plasma				|Startup and shutdown	|Desktop session			|General									|Offer shutdown options
|KDE Plasma				|Startup and shutdown	|Desktop session			|Default leave option						|End current session
|KDE Plasma				|Startup and shutdown	|Desktop session			|When logging in							|Restore previous saved session
|KDE Plasma				|Startup and shutdown	|Desktop session			|Don't restore these applications			|null
|KDE Plasma				|Regional settings		|Formats					Region										|Brasil - português (pt_BR)
|KDE Plasma				|Regional settings		|Formats					|Detailed settings							|Brasil - português (pt_BR)
|KDE Plasma				|Regional settings		|Formats					|Numbers									|Brasil - português (pt_BR)
|KDE Plasma				|Regional settings		|Formats					|Time										|Brasil - português (pt_BR)
|KDE Plasma				|Regional settings		|Formats					|Currency									|Brasil - português (pt_BR)
|KDE Plasma				|Regional settings		|Formats					|Measurement units							|Brasil - português (pt_BR)
|KDE Plasma				|Regional settings		|Formats					|Collation and sorting						|No change
|KDE Plasma				|Input devices			|Keyboard					|Hardware									|Keyboard model **Lenovo (previously IBM) | IBM ThinkPad 560|/600/600E/A22E**
|KDE Plasma				|Input devices			|Keyboard					|Hardware									|NumLock on Plasma startup **turn on**
|KDE Plasma				|Input devices			|Keyboard					|Hardware									|When a key is held **repeat the key**
|KDE Plasma				|Input devices			|Keyboard					|Hardware									|Delay **600 ms**
|KDE Plasma				|Input devices			|Keyboard					|Hardware									|Rate **25, 00 repeat**
|KDE Plasma				|Input devices			|Keyboard					|Layouts									|Switching policy **global**
|KDE Plasma				|Input devices			|Keyboard					|Layouts									|Shortcuts for switching layout 
|KDE Plasma				|Input devices			|Keyboard					|Layouts									|Shortcuts for switching layout 
|KDE Plasma				|Input devices			|Keyboard					|Layouts									|Shortcuts for switching layout 
|KDE Plasma				|Input devices			|Keyboard					|Layouts									|Shortcuts for switching layout 
|KDE Plasma				|Input devices			|Keyboard					|Layouts									|Configure layouts **br | Portuguese (Brazil) | Portuguese (Brazil, IBM/Lenovo ThinkPad)
|KDE Plasma				|Input devices			|Mouse						|Acceleration profile						|Aadaptive
|KDE Plasma				|Input devices			|Game controller			|null										|null
|KDE Plasma				|Input devices			|Touchpad					|General									|Device enabled
|KDE Plasma				|Input devices			|Touchpad					|General									|Disable while typing
|KDE Plasma				|Input devices			|Touchpad					|Pointer acceleration						|0.00
|KDE Plasma				|Input devices			|Touchpad					|Accelerating profile						|Adaptive
|KDE Plasma				|Input devices			|Touchpad					|Tapping									|tap-to-click
|KDE Plasma				|Input devices			|Touchpad					|Tapping									|tap-to-drag
|KDE Plasma				|Input devices			|Touchpad					|Scrolling									|Two fingers
|KDE Plasma				|Input devices			|Touchpad					|Scrolling									|Invert scroll direction (natural scrolling)
|KDE Plasma				|Display and monitor	|Display configuration		|Resolution									|1366x768 (683:384)
|KDE Plasma				|Display and monitor	|Display configuration		|Orientation								|Default
|KDE Plasma				|Display and monitor	|Display configuration		|Refresh rate								|60 Hz
|KDE Plasma				|Display and monitor	|Display configuration		|Save displays' properties					|For any display  arrangement
|KDE Plasma				|Display and monitor	|Compositor					|Enable compositor on startup				|Checked
|KDE Plasma				|Display and monitor	|Compositor					|Scale method								|Smooth
|KDE Plasma				|Display and monitor	|Compositor					|Rendering backend							|OpenGL
|KDE Plasma				|Display and monitor	|Compositor					|Latency									|Balance of latency and smoothness
|KDE Plasma				|Display and monitor	|Compositor					|Tearing prevention ("vsync")				|Automatic
|KDE Plasma				|Display and monitor	|Compositor					|Keep window thumbnails						|Only for shown windows
|KDE Plasma				|Display and monitor	|Compositor					|Allow applications to block compositing	|Checked
|KDE Plasma				|Display and monitor	|Night color				|Activate night color						|Checked
|KDE Plasma				|Display and monitor	|Night color				|Night color temperature					|4500K
|KDE Plasma				|Display and monitor	|Night color				|Activation time							|Sunset to sunrise at current location
|KDE Plasma				|Power management		|Energy saving				|On AC Power								|Dim screen **after 10 min**
|KDE Plasma				|Power management		|Energy saving				|On AC Power								|Screen energy saving **switch off after 30 min**
|KDE Plasma				|Power management		|Energy saving				|On AC Power								|Buttons events handling _when laptop lid closed_ **sleep*
|KDE Plasma				|Power management		|Energy saving				|On AC Power								|Buttons events handling _when power button pressed_ **prompt log out dialog**
|KDE Plasma				|Power management		|Energy saving				|On battery									|Dim screen **after 5 min**
|KDE Plasma				|Power management		|Energy saving				|On battery									|Screen energy saving **switch off after 15 min**
|KDE Plasma				|Power management		|Energy saving				|On battery									|Suspend session _automatically_ **sleep**
|KDE Plasma				|Power management		|Energy saving				|On battery									|Buttons events handling _when laptop lid closed_ **sleep*
|KDE Plasma				|Power management		|Energy saving				|On battery									|Buttons events handling _when power button pressed_ **prompt log out dialog**
|KDE Plasma				|Power management		|Energy saving				|On low battery								|Screen brightness _level_ **default**
|KDE Plasma				|Power management		|Energy saving				|On low battery								|Dim screen **after 1 min**
|KDE Plasma				|Power management		|Energy saving				|On low battery								|Screen energy saving **switch off after 2 min**
|KDE Plasma				|Power management		|Energy saving				|On low battery								|Buttons events handling _when laptop lid closed_ **sleep*
|KDE Plasma				|Power management		|Energy saving				|On low battery								|Buttons events handling _when power button pressed_ **prompt log out dialog**
|KDE Plasma				|Power management		|Activity power settings	|Default												|Do not use special settings
|KDE Plasma				|Power management		|Advanced power settings	|Battery levels											|Low level **15%**
|KDE Plasma				|Power management		|Advanced power settings	|Battery levels											|Critical level **5**
|KDE Plasma				|Power management		|Advanced power settings	|Battery levels											|At critical level **sleep**
|KDE Plasma				|Power management		|Advanced power settings	|Other settings											|Pause media players when suspendend **enabled**
|KDE Plasma				|Removable storage		|Removable					|Browse files with file manager							|Portable media player
|KDE Plasma				|Removable storage		|Removable					|Open files with file manager							|Storage access, storage drive, storage volume
|KDE Plasma				|Removable storage		|Removable devices			|Enable automatic mounting of removable media			|Checked
|KDE Plasma				|Removable storage		|Removable devices			|Automatically mount all removable media at login		|Checked
|KDE Plasma				|Removable storage		|Removable devices			|Automatically mount all removable media when attached	|Checked

<!--
```bash
ln -sf /home/henrikbeck95/Pictures/dracula/dracula_icon.png /home/henrikbeck95/Pictures/icon.png
ln -sf /home/henrikbeck95/Pictures/dracula/dracula_wallpaper.png /home/henrikbeck95/Pictures/wallpaper.png
```
-->

<!--
### Customization

|Desktop environment	|Category			|Subcategory		|???				|???
|---					|---				|---				|---				|---
|KDE Plasma				|???				|Launcher icon		|???				|RedHat logo
|KDE Plasma				|???				|Profile picture	|???				|Myself
|KDE Plasma				|???				|Wallpaper			|???				|Dracula RedHat

### Panels

|KDE Plasma				|???				|Global menu
-->

### Fonts

- [x] AirBnB Cereal
- [x] FiraCode
- [x] Meslo

- Clear and regenerate font cache
	> $ `fc-cache -f -v`

### Theme

#### Setup
	> $ `mkdir -p $HOME/compilation/dracula/`

<!--
#### Gedit
	
```bash
wget https://raw.githubusercontent.com/dracula/gedit/master/dracula.xml -O $HOME/.local/share/gedit/styles/dracula.xml
	```

#### GRUB

```bash
git clone https://github.com/dracula/grub.git $HOME/compilation/dracula/grub
```
-->

#### LibreOffice

```bash
git clone https://github.com/dracula/libreoffice.git $HOME/compilation/dracula/libreoffice
vim $HOME/compilation/dracula/libreoffice/add_dracula_application_colors.sh 
$HOME/compilation/dracula/libreoffice/add_dracula_application_colors.sh 
```

#### Clone others Dracula theme repositories

```bash
git clone https://github.com/dracula/betterdiscord.git $HOME/compilation/dracula/betterdiscord
git clone https://github.com/dracula/eclipse.git $HOME/compilation/dracula/eclipse
git clone https://github.com/dracula/firefox.git $HOME/compilation/dracula/firefox
git clone https://github.com/dracula/kate.git $HOME/compilation/dracula/kate
git clone https://github.com/dracula/krita.git $HOME/compilation/dracula/krita
git clone https://github.com/dracula/metatrader5.git $HOME/compilation/dracula/metatrader5
git clone https://github.com/dracula/netbeans.git $HOME/compilation/dracula/netbeans
git clone https://github.com/dracula/qt5.git $HOME/compilation/dracula/qt5
git clone https://github.com/dracula/tty.git $HOME/compilation/dracula/tty
git clone https://github.com/dracula/wallpaper.git $HOME/compilation/dracula/wallpaper
git clone https://github.com/dracula/xresources.git $HOME/compilation/dracula/xresources
```

## Behavior

### Desktop files

- AppImage extraction
	> `$HOME/Applications/LibreOffice-fresh.standard-x86_64.AppImage --appimage-extract`

- XDG update
	> $ `xdg-desktop-menu forceupdate`
	> $ `update-desktop-database ~/.local/share/applications/`
	> $ `sudo update-desktop-database /usr/share/applications/`

### Firejail

```bash
firejail --private firefox
firejail --private /usr/bin/firefox

firejail --appimage --private --profile=firefox $HOME/Applications/firefox-94.0.r20211103134640-x86_64.AppImage

alias jailfox="firejail --appimage --private --profile=firefox $HOME/Applications/firefox-94.0.r20211103134640-x86_64.AppImage"
```

### Shortcuts

|Keybind		|Software
|---			|---
|Ctrl + Alt + T	|Alacritty
|Meta + E		|Dolphin
|PrtSc + Ctrl	|Spectacle

<!--
|PrtSc			|Scrot
|PrtSc + Shift	|OBS Studio
-->

### Shell

- Set ZSH as default shell

```bash
echo -e $SHELL
cat /etc/shells
sudo chsh -s /usr/bin/zsh
echo -e "Restart current session"
```

## Hardware

### Printer

- How to install Epson L120 printer.
	```bash
	#Clone the Arch User Repository (AUR)
	cd $HOME/compilation/
	git clone https://aur.archlinux.org/epson-inkjet-printer-201310w.git
	
	#Compile the software
	cd $HOME/compilation/epson-inkjet-printer-201310w/
	makepkg -si --needed

	#Install the dependencies
	sudo pacman -Syu --needed cups system-config-printer
	```

## Softwares

### System

- Update system

```bash
sudo pacman -Syyuu
sudo pacman -Syu
```

### Installation setup

#### AppImage

- Install softwares from `AppImage`
	> $ `mkdir -p $HOME/Applications/`

	> $ `wget -c <package_link> - O $HOME/Applications/<package_name>`
	
	> $ `chmod +x $HOME/Applications/<package_name>`

#### Binary

- Install softwares from `Binary`

	1. Install LF file manager from binary

	```bash
	cd /tmp/
	wget -c https://github.com/gokcehan/lf/releases/download/r26/lf-linux-amd64.tar.gz
	tar -xf /tmp/lf-linux-amd64.tar.gz
	#sudo mv /tmp/??? /usr/local/bin/lf
	```

	1. Install Oh-My-Posh with all themes

	```bash
	sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
	sudo chmod +x /usr/local/bin/oh-my-posh
	mkdir ~/.poshthemes
	wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O ~/.poshthemes/themes.zip
	unzip ~/.poshthemes/themes.zip -d ~/.poshthemes
	chmod u+rw ~/.poshthemes/*.json
	rm ~/.poshthemes/themes.zip
	```

#### Compilation

- Compilation

	1. Compile Paru

	```bash
	mkdir $HOME/compilation
	cd $HOME/compilation/
	git clone https://aur.archlinux.org/paru.git
	cd $HOME/compilation/paru/
	makepkg -si
	```

#### Git

- Git

	1. ASDF

	```bash
	git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf --branch v0.8.1
	echo ". $HOME/.asdf/asdf.sh" >> $HOME/.bashrc
	echo ". $HOME/.asdf/completions/asdf.bash" >> $HOME/.bashrc
	```

#### Container

- Install softwares from `Container`
	> $ `podman pull <container_name>`

#### Pacman

- Install softwares from `Pacman`
	> $ `sudo pacman -S <package_name> --noconfirm`

- Install softwares from `Pacman` manually
	> $ `sudo pacman -U <package_path>`

- Give executable permission
	> $ `chmod +x $HOME/Applications/*.AppImage`

#### Paru

- Install softwares from `Paru`
	> $ `sudo paru -S <package_name>`

### List

#### Installed

|Package	    |Software		        |Theme		    |Command
|---		    |---			        |---		    |---
|AppImage	    |Audacity		        |GTK		    |https://github.com/audacity/audacity/releases/download/Audacity-3.1.0/audacity-linux-3.1.0-x86_64.AppImage
|AppImage	    |Balena Etcher		    |QT5		    |???
|AppImage	    |Firefox		        |???		    |https://github.com/srevinsaju/Firefox-Appimage/releases/download/firefox-v94.0.r20211103134640/firefox-94.0.r20211103134640-x86_64.AppImage
|AppImage	    |GIMP			        |null		    |wget -c https://apprepo.de/appimage/download/gimp
|AppImage	    |KeePassXC		        |null		    |https://github.com/keepassxreboot/keepassxc/releases/download/2.6.6/KeePassXC-2.6.6-x86_64.AppImage
|AppImage	    |LibreOffice-fresh	    |Dracula	    |???
|AppImage	    |LibreOffice-still	    |Dracula	    |???
|AppImage       |StarUML		        |null           |https://staruml.io/download/releases/StarUML-3.2.2.AppImage
|AppImage	    |Visual Studio Code     |Midnight City	|https://apprepo.de/appimage/download/vscode
|AppImage	    |Visual Studio Codium	|Midnight City	|https://github.com/VSCodium/vscodium/releases/download/1.55.2/VSCodium-1.55.2-1618361301.glibc2.16-x86_64.AppImage
|AppImage	    |VLC			        |null		    |https://github.com/cmatomic/VLCplayer-AppImage/releases/download/3.0.11.1/VLC_media_player-3.0.11.1-x86_64.AppImage
|Binary		    |LF			            |null		    |[Check dedicated section]()
|Binary		    |Oh-My-Posh!		    |Aliens		    |[Check dedicated section]()
|Compilation	|Paru			        |null		    |[Check dedicated section]()
|Git			|ASDF					|null			|[Check dedicated section]()
|Pacman 		|Alacritty		        |Midnight City	|sudo pacman -S alacritty
|Pacman 		|Ark			        |QT5		    |sudo pacman -S ark
|Pacman 		|Bash-completion	    |null		    |sudo pacman -S bash-completion
|Pacman 		|Cheese			        |???		    |sudo pacman -S cheese
|Pacman 		|Dolphin		        |QT5		    |sudo pacman -S dolphin
|Pacman 		|FFMpeg			        |null		    |sudo pacman -S ffmpeg
|Pacman			|Firejail				|null			|sudo pacman -S firejail
|Pacman 		|Git			        |null		    |sudo pacman -S git
|Pacman 		|GParted		        |null		    |sudo pacman -S gparted
|Pacman 		|GRUB			        |Dracula	    |???
|Pacman			|GThumb					|GTK			|sudo pacman -S gthumb
|Pacman 		|Htop			        |null		    |sudo pacman -S htop
|Pacman 		|JQ			            |null		    |sudo pacman -S jq
|Pacman			|Linux-LTS				|null			|sudo pacman -S linux-lts
|Pacman			|LSB Core				|null			|sudo pacman -S lsb-release
|Pacman 		|Neofetch		        |null		    |sudo pacman -S neofetch
|Pacman 		|NTFS-3g		        |null		    |sudo pacman -S ntfs-3g
|Pacman 		|Numlockx		        |null		    |sudo pacman -S numlockx
|Pacman 		|Okular			        |QT5		    |sudo pacman -S okular
|Pacman 		|Redshift		        |null		    |sudo pacman -S redshift
|Pacman		    |Scrot			        |null		    |sudo pacman -S scrot
|Pacman		    |Spectacle		        |QT5		    |sudo pacman -S spectacle
|Pacman		    |Tmux			        |Dracula	    |sudo pacman -S tmux
|Pacman		    |Unrar			        |null		    |sudo pacman -S unrar
|Pacman		    |Unzip			        |null		    |sudo pacman -S unzip
|Pacman		    |Wget			        |null		    |sudo pacman -S wget
|Pacman		    |ZSH			        |Oh-My-Posh!	|sudo pacman -S zsh
|Pacman		    |ZSH-autosuggestions	|null		    |sudo pacman -S zsh-autosuggestions
|Pacman		    |ZSH-highlighting	    |null		    |sudo pacman -S zsh-syntax-highlighting
|Pacman		    |ZSH-completions	    |null		    |sudo pacman -S zsh-completions
|Paru		    |Timeshift		        |null		    |paru -S timeshift
|System		    |Bash			        |Oh-My-Posh!	|null
|System		    |GTK			        |Dracula        |null
|System		    |QT5			        |Dracula        |null
|System		    |TTY			        |Dracula	    |null
|System		    |Xresources		        |Dracula	    |null

#### Testing

|Package	    |Software		        |Theme          |Command
|---		    |---			        |---            |---
|AppImage       |Discord		        |???			|https://github.com/srevinsaju/discord-appimage/releases/download/stable/Discord-0.0.16-x86_64.AppImage
|AppImage	    |Microsoft Teams	    |???			|???
|AppImage	    |OnlyOffice		        |???			|https://github.com/ONLYOFFICE/appimage-desktopeditors/releases/download/v6.3.1/DesktopEditors-x86_64.AppImage
|AppImage	    |Opera			        |???			|https://apprepo.de/appimage/download/opera
|AppImage	    |Zoom			        |???			|???
|Binary         |Android Studio         |???			|https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2020.3.1.25/android-studio-2020.3.1.25-linux.tar.gz

#### Not installed

|Package	    |Software		        |Theme          |Command
|---		    |---			        |---            |---
|AppImage	    |Darktable		        |???		    |???
|AppImage	    |Eclipse		        |Dracula	    |???
|AppImage	    |Inkscape		        |Dracula	    |???
|AppImage	    |Joplin			        |Dracula		|[Check dedicated section]()
|AppImage	    |Kate			        |Dracula	    |???
|AppImage	    |Krita			        |Dracula	    |???
|AppImage	    |NetBeans		        |Dracula	    |???
|AppImage	    |Qalculate!		        |???		    |???
|AppImage	    |Thunderbird		    |Dracula	    |???
|AppImage	    |Transmition		    |???		    |???
|Binary			|Anaconda				|null			|[Check dedicated section]()
|Container	    |TaskWarrior            |???		    |???
|Pacman		    |Buildah		        |null		    |[Check dedicated section]()
|Pacman		    |Cockpit		        |null		    |[Check dedicated section]()
|Pacman			|Discord				|null		    |sudo pacman -S discord
|Pacman		    |KDE Connect            |???		    |???
|Pacman			|Libreoffice still PT-BR|Dracula		|sudo pacman -S libreoffice-still-pt-br
|Pacman		    |PSCX2			        |???		    |???
|Pacman		    |Podman			        |null		    |[Check dedicated section]()
|Pacman		    |Podman-compose         |null		    |[Check dedicated section]()
|Pacman		    |QEMU			        |null		    |[Check dedicated section]()
|Pacman		    |Virt-Manager           |???		    |[Check dedicated section]()
|Pacman manually|Gestures		        |???		    |[Check dedicated section]()
|Pacman manually|libinput-gestures		|null		    |[Check dedicated section]()
|Paru		    |Dropbox		        |???			|???
|Paru		    |Spotify		        |???			|???
|Unknown	    |Déjà Dup               |???		    |???
|Unknown	    |Firejail		        |null		    |???
|Unknown	    |FreeMind		        |???		    |???
|Unknown	    |HandBreak		        |???		    |???
|Unknown	    |NativeFier		        |null		    |???
|Unknown	    |OBS Studio		        |???		    |???
|Unknown	    |RetroArch		        |???		    |???
|Unknown	    |Telegram-Desktop	    |???		    |???
|Unknown	    |Xdotool		        |null		    |???

#### Others - Verifying

- Testing

```bash
sudo pacman -Sy libxau libxi libxss libxtst libxcursor libxcomposite libxdamage libxfixes libxrandr libxrender mesa-libgl  alsa-lib libglvnd
conda install anaconda-docs
conda install anaconda-oss-docs
---
clear && $(which python3) /home/henrikbeck95/Documents/voice_assistant_linux/src/main.py
---
mkdir -p ~/compilation/zsh/
cd ~/compilation/zsh/
git clone --depth 1 -- https://github.com/marlonrichert/zsh-snap.git
source ./zsh-snap/install.zsh
---
znap source marlonrichert/zsh-autocomplete
znap source zsh-users/zsh-autosuggestions
znap source zsh-users/zsh-syntax-highlighting
---
sudo pacman -S wmctrl
sudo libinput-gestures
gestures
---
sudo lf
sudo grub-mkconfig -o /boot/grub/grub.cfg
---
cd ~/compilation
wget -c https://mirror.clarkson.edu/manjaro/testing/community/x86_64/libinput-gestures-2.69-1-any.pkg.tar.zst
sudo pacman -U ~/compilation/libinput-gestures-2.69-1-any.pkg.tar.zst
wget -c https://mirror.clarkson.edu/manjaro/stable/community/x86_64/gestures-0.2.5-1-any.pkg.tar.zst
sudo pacman -U ~/compilation/gestures-0.2.5-1-any.pkg.tar.zst
```

### Package manager configuration

#### Pacman

- Edit Pacman settings file
	> $ `sudo vim -O /etc/pacman.conf`


- Edit the following lines

	```bash
	#Ignore package updates
	IgnorePkg   = linux
	```

- Uncomment the following lines

	```bash
	# Misc options
	Color
	
	# REPOSITORIES
	[multilib-testing]
	Include = /etc/pacman.d/mirrorlist

	[multilib]
	Include = /etc/pacman.d/mirrorlist
	```

#### Paru

- Edit Pacman settings file
	> $ `sudo vim -O /etc/paru.conf`


- Edit the following lines

	```bash
	```

- Uncomment the following lines

	```bash
	```

## Task list

### Actions

1. [ ] Edit the desktop files to support `Firejail` sandbox
1. [ ] Copy the desktop files to this repoository
1. [ ] Link the desktop file from this repository to the dedicated Linux path
1. [ ] 

### Installing...

1. [ ] FirewallD
1. [ ] ASDF plugins

### Testing

- [ ] Add GTK application to KDE Plasma global menu
	> [How to enable global menu with GTK apps on KDE Plasma desktop](https://www.youtube.com/watch?v=WUmpB1690Zo)
	
	- Install software
		> $ `sudo pacman -S appmenu-gtk-module`

	- Insert into `$HOME/.bashrc` file
		```bash
		if [ -n "$GTK_MODULES" ]; then
			GTK_MODULES="${GTK_MODULES}:appmenu-gtk-module" # unity-gtk-module
			#GTK_MODULES="${GTK_MODULES}:unity-gtk-module" # unity-gtk-module
		else
			GTK_MODULES="appmenu-gtk-module"
			#GTK_MODULES="unity-gtk-module"
		fi

		if [ -z "$UBUNTU_MENUPROXY" ]; then
			UBUNTU_MENUPROXY=1
		fi
		```

### Searching...

1. [Is Deepin Linux The Windows Killer? (Deepin 20.3 First Look)](https://www.youtube.com/watch?v=29onMCIbbXc)
1. [Conheça os tipos diferentes de Kernel Linux](https://www.youtube.com/watch?v=hfi2lqaa6YQ)
1. [Running MS OFFICE on Linux - Is it enough to justify paying for Wine?](https://www.youtube.com/watch?v=ZH5JYshhtYg)
1. [ ] How to enable Numlockx on startup.
1. [Oracle Linux 8](https://www.oracle.com/linux/downloads/linux-beta8-downloads.html)

### Notes

```markdown
- [x] Backup dotfiles
- [ ] Restore Timeshift backup
- [ ] Block Linux kernel updates
- [ ] Install the softwares
	- [ ] VIEWER
	- [ ] 
	- [ ] 
	- [ ] 
- [ ] KWin shortcuts
- [ ] Fazer o TCC
```