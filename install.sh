#!/bin/bash

# This is Arch Linux Installation Script.

echo "Ruhex Arch Installer"

# Set up time
timedatectl set-ntp true

# Initate pacman keyring
pacman-key --init
pacman-key --populate archlinux
pacman-key --refresh-keys

# to create the partitions
#echo ',,L' | sfdisk --wipe=always --label=gpt /dev/sda
#echo ",500M,U;" | sfdisk /dev/sda 0
#echo ",,,;" | sfdisk /dev/sda 1

# to create the partitions programatically (rather than manually)
# https://superuser.com/a/984637
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk ${TGTDEV}
  g # GPT lable
  o # clear the in memory partition table
  n # new partition
  p # primary partition
  1 # partition number 1
    # default - start at beginning of disk 
  +512M # 512 MB boot parttion
  n # new partition
  p # primary partition
  2 # partion number 2
    # default, start immediately after preceding partition
    # default, extend partition to end of disk
  a # make a partition bootable
  1 # bootable partition is partition 1 -- /dev/sda1
  p # print the in-memory partition table
  w # write the partition table
  q # and we're done
EOF


# Format the partitions
mkfs.fat -F32 /dev/sda1
mkfs.btrfs -L test -n 32k /dev/sda2


# Mount the partitions
mount /dev/sda2 /mnt
mkdir /boot/EFI
mount /dev/sda1 /boot/EFI

# Install Arch Linux
echo "Starting install.."
echo "Installing Arch Linux, GRUB2 as bootloader and other utils"
pacstrap /mnt base base-devel linux intel-ucode efibootmgr dosfstools os-prober mtools freetype2 grub sway nano git zip networkmanager openssh

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