#!/bin/bash

# This is Arch Linux Installation Script.

DISK=$1
P1="/dev/${DISK}1"
P2="/dev/${DISK}2"

echo "Ruhex Arch Installer"

# Set up time
timedatectl set-ntp true

# Initate pacman keyring
pacman-key --init
pacman-key --populate archlinux
pacman-key --refresh-keys

# to create the partitions
(
echo g # Create a new empty GPT partition table
echo d
echo d
echo n
echo 1
echo 
echo +512M
echo y
echo n
echo 2
echo 
echo 
echo t
echo 1
echo 1
echo p
echo w # Write changes
echo q
) | sudo fdisk /dev/$DISK

# Format the partitions
mkfs.fat -F32 $P1
mkfs.btrfs -L arch -n 32k $P2


# Mount the partitions
mount $P2 /mnt
mkdir -pv /mnt/boot/EFI
mount /dev/$P1 /mnt/boot/EFI
# Install Arch Linux
echo "Starting install.."
echo "Installing Arch Linux, GRUB2 as bootloader and other utils"
pacstrap /mnt base base-devel linux-firmware linux intel-ucode efibootmgr dosfstools os-prober mtools freetype2 grub sway nano git zip networkmanager openssh

# Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Copy post-install system cinfiguration script to new /root
cp -rfv post-install.sh /mnt/root
chmod a+x /mnt/root/post-install.sh

# Chroot into new system
echo "Press any key to chroot..."
read tmpvar
arch-chroot /mnt /bin/bash

# Finish
echo "Press any key to reboot or Ctrl+C to cancel..."
read tmpvar
reboot