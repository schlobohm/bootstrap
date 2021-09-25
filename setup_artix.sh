#!/bin/sh
# Schlobohm Bootstrapper. 2021. All rights reserved.

PACKAGES=("code" "discord" "dolphin-emu" "gnupg" "jdk-openjdk" "keepassxc" "neovim" "nodejs" "telegram-desktop" "texlive-most" "texmaker" "tickrs" "tmux")

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
curl -LOJR https://bootstrap.schlobohm.one/papes/1601770590519.jpg

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

echo "Optimizing Artix ..."

echo "Making adjustments to grub user settings (backup copied to /tmp/etc_default_grub.bak) ..."
cp /etc/default/grub /tmp/etc_default_grub.bak
RESUME=$(cat /etc/default/grub | grep GRUB_CMDLINE_LINUX_DEFAULT | awk -F'resume=' '{print $2}')
sudo sed -i "/GRUB_CMDLINE_LINUX_DEFAULT=/c\ GRUB_CMDLINE_LINUX_DEFAULT=\"loglevel=0 console=tty2 udev.log_level=0 vt.global_cursor_default=0 mitigations=off nowatchdog msr.allow_writes=on pcie_aspm=force module.sig_unenforce intel_idle.max_cstate=1 cryptomgr.notests initcall_debug intel_iommu=igfx_off no_timer_check noreplace-smp page_alloc.shuffle=1 rcupdate.rcu_expedited=1 tsc=reliable resume=$RESUME" /etc/default/grub
echo "Done!"

echo "Running update-grub ..."
sudo update-grub
echo "Done!"

echo "Removing Artix logo during boot ..."
sudo rm /etc/issue
echo "Done!"

echo "Done Optimizing Artix !"
