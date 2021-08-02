#!/usr/bin/env sh

#Applying GRUB
while true; do
    read -p "Inform the BIOS profile your PC is: [legacy/uefi] " QUESTION_BIOS

    case $QUESTION_BIOS in
        "legacy")
            echo -e "This command must be implemented"
            #grub-install --target=x86_64-efi --bootloader-id=GRUB
            #grub-install --target=x86_64-efi --boot-directory=/boot/efi --bootloader-id=GRUB
            #efibootmgr -c -d /dev/sda -p 1 -L "ArchLinux" -l \vmlinuz-linux -u "root=/dev/sda2 rw initrd=/initramfs-linux.img"
            break
            ;;
        "uefi")
            #MUST BE FIXED
            grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
            grub-mkconfig -o /boot/grub/grub.cfg
            break
            ;;
        *) echo "Please answer legacy or uefi." ;;
    esac
done

# Installing the graphic drivers

- X Window System QXL driver including Xspice server for virtual machine
    > \# `pacman -S xf86-video-qxl`

- Select the option according to your graphic video manufacturer. You can discovery it using the `lspci | grep -e VGA -e 3D` command.
    - **For Intel graphic video**
        > \# `pacman -S xf86-video-intel`
        
    - For AMD graphic video
        > \# `pacman -S xf86-video-amdgpu`

    - For Nvidia graphic video
        > \# `pacman -S nvidia nvidia-utils`

#/etc/locale.gen
FILENAME="/home/henrikbeck95/Desktop/testing/locale.gen"
FILENAME_BAK="/home/henrikbeck95/Desktop/testing/locale.bak"

if [[ -f $FILENAME_BAK ]]; then
    rm -f $FILENAME_BAK
fi

cp $FILENAME $FILENAME_BAK

#Uncomment the line: # pt_BR.UTF-8 UTF-8
TEXT_OLD="# pt_BR.UTF-8 UTF-8"
TEXT_NEW="pt_BR.UTF-8 UTF-8"
sed -i "s/$TEXT_OLD/$TEXT_NEW/g" $FILENAME_BAK