#!/bin/bash
echo "script start\n"
ln -sf /usr/share/zoneinfo/Asia/Vladivostok /etc/localtime
hwclock --systohc
pacman -S nano git zip 
localectl set-locale LANG=en_US.UTF-8
locale-gen
echo "arch" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1		localhost" >> /etc/hosts
echo "127.0.1.1	arch.localdomain	arch" >> /etc/hosts
passwd
useradd -m username kenny
passwd kenny
usermod -aG wheel,audio,video,optical,storage kenny
pacman -S sudo
EDITOR=nano visudo
pacman -S grub
pacman -S  efibootmgr dosfstools os-prober mtools
mkdir /boot/EFI
mount /dev/sda1 /boot/EFI
grub-install --target=x86_64-efi  --bootloader-id=grub_uefi --recheck
grub-mkconfig -o /boot/grub/grub.cfg
pacman -S --noconfirm networkmanager openssh-server
systemctl enable NetworkManager
systemctl enable sshd