#!/bin/sh
# Schlobohm Bootstrapper. 2021. All rights reserved.

PACKAGES=("code" "discord" "dolphin-emu" "gnupg" "keepassxc" "neovim" "nodejs" "telegram-desktop" "tmux")

echo "
----------------------
Schlobohm Bootstrapper
----------------------

"

echo "Running pacman -Syy and -Syu ..."
sudo pacman -Syy
yes | sudo pacman -Syu
echo "Done!"

# Allow installing of arch packages
echo "Installing artix-archlinux-support ..."
yes | sudo pacman -S artix-archlinux-support
echo "Done!"
echo "Running pacman-key --populate archlinux ..."
sudo pacman-key --populate archlinux
echo "Adding Arch repos to /etc/pacman.conf ..."
sudo tee -a /etc/pacman.conf > /dev/null <<EOT
# ARCH
[extra]
Include = /etc/pacman.d/mirrorlist-arch

[community]
Include = /etc/pacman.d/mirrorlist-arch

[multilib]
Include = /etc/pacman.d/mirrorlist-arch"
EOT

echo "Running pacman -Syy and -Syu ..."
sudo pacman -Syy
yes | sudo pacman -Syu
echo "Done!"

# pip and bpytop
echo "Installing python-pip ..."
yes | sudo pacman -S python-pip
echo "Done!"

echo "Adding ~/.local/bin to PATH ..."
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc

echo "Installing bpytop ..."
yes | pip3 install --upgrade bpytop
echo "Done!"

# Packages from PACKAGES array
for p in ${PACKAGES[@]}; do
  echo "Installing $t ..."
  sudo pacman --noconfirm -S $t
  echo "Done!"
done

# Wallpaper
mkdir -p ~/Pictures/papes
cd ~/Pictures/papes

echo "Downloading wallpaper ..."
curl -LOJR https://schlobohm.github.io/bootstrap/papes/1601770590519.jpg

echo "Setting wallpaper ..."
qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "
    var allDesktops = desktops();
    print (allDesktops);
    for (i=0;i<allDesktops.length;i++) {
        d = allDesktops[i];
        d.wallpaperPlugin = 'org.kde.image';
        d.currentConfigGroup = Array('Wallpaper',
                                    'org.kde.image',
                                    'General');
        d.writeConfig('Image', 'file:///home/$(whoami)/Pictures/papes/1601770590519.jpg')
    }"

echo "Done!"
