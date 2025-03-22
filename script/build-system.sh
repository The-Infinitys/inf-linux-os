#!/bin/bash

cd /

export DEBIAN_FRONTEND=noninteractive
echo "Building Infinity Linux!"

/config-chroot.sh before

# Update APT Packages

echo "Updating System..."
apt update
apt upgrade -y
apt full-upgrade -y
echo "Updated System."

# install for boot

# install plymouth theme
apt install -y plymouth plymouth-themes
cd /usr/share/plymouth/themes
git clone https://github.com/The-Infinitys/plymouth-infinite.git
update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/plymouth-infinite/plymouth-infinite.plymouth 250
update-alternatives --set default.plymouth /usr/share/plymouth/themes/plymouth-infinite/plymouth-infinite.plymouth

echo "Installing additional package manager..."
######################################################
apt install snapd flatpak aptitude -y
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
######################################################
echo "Complete additional package manager installation."

echo "Installing Docker..."
######################################################
# Add Docker's official GPG key:
apt update
apt install ca-certificates curl -y
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update
apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
######################################################
echo "Complete Docker Installation."

echo "Installing KVM"
######################################################
apt install qemu-kvm libvirt-daemon-system libvirt-daemon virtinst bridge-utils libosinfo-bin virt-manager -y
######################################################
echo "Complete KVM Installation."

echo "Installing browsers..."
######################################################
snap install firefox chromium-browser -y

curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge.list'
rm microsoft.gpg
apt update
apt install microsoft-edge-stable -y

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt install ./google-chrome-stable_current_amd64.deb -y
rm google-chrome-stable_current_amd64.deb
######################################################
echo "Complete browser installation."

echo "Installing IDEs..."
######################################################
apt install python3-full npm -y
apt install cargo rust-clippy rust-docs rustc rustfmt -y

# Install Visual Studio Code
apt install  wget gpg -y
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |tee /etc/apt/sources.list.d/vscode.list > /dev/null
rm -f packages.microsoft.gpg
apt install apt-transport-https -y
apt update
apt install code -y
######################################################
echo "Complete IDE installation."

echo "Installing Office Suite..."
######################################################
apt install libreoffice -y
######################################################
echo "Complete Office Suite installation."


# Install for Live CD
echo "Installing for Live CD..."
######################################################
apt install -y live-boot live-boot-initramfs-tools squashfs-tools grub2-common network-manager openssh-server openssh-client byobu emacs less lvm2 e2fsprogs net-tools

######################################################

# After Process
/config-chroot.sh after
exit 0