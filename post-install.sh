#! /bin/bash

# This is Configuration script of Ruhex Arch Linux Installation Package.
echo "Ruhex Arch Configurator"

# Set date time
ln -sf /usr/share/zoneinfo/Asia/Vladivostok /etc/localtime
hwclock --systohc

# Set locale to en_US.UTF-8 UTF-8
localectl set-locale LANG=en_US.UTF-8
locale-gen

# Set hostname
echo "barsik" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1		localhost" >> /etc/hosts
echo "127.0.1.1	barsik.localdomain	barsik" >> /etc/hosts

# Generate initramfs
mkinitcpio -P

# Set root password
passwd

# Install bootloader
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=barsik --recheck
grub-mkconfig -o /boot/grub/grub.cfg

# Create new user
useradd -m -G wheel,power,audio,video,optical,storage,uucp,network kenny
sed --in-place 's/^#\s*\(%wheel\s\+ALL=(ALL)\s\+NOPASSWD:\s\+ALL\)/\1/' /etc/sudoers
echo "Set password for new user"
passwd kenny

# Enable services
systemctl enable NetworkManager.service
systemctl enable sshd.service

echo "Configuration done. You can now exit chroot."