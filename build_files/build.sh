#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 -y install @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
# dnf5 -y install libva-nvidia-driver

dnf5 -y install \
    nautilus \
    ptyxis \
    gnome-software \
    xdg-desktop-portal-gnome \
    mate-polkit \
    gstreamer1-plugins-ugly \
    gstreamer1-plugins-bad-free-extras \
    gstreamer1-plugins-good-extras \
    adw-gtk3-theme \
    steam-devices \
	fish \
    gnome-keyring \
	gcr \
    desktop-file-utils \
    xdg-user-dirs \
    swayidle \
	iotop-c
    
    
dnf5 -y install --setopt=install_weak_deps=false \
    niri \
    fuzzel \
    gnome-control-center \
    NetworkManager-wifi \
    nm-connection-editor \
    ppd-service \
    power-profiles-daemon

dnf5 -y copr enable trixieua/morewaita-icon-theme
dnf5 -y install morewaita-icon-theme
dnf5 -y copr disable trixieua/morewaita-icon-theme

dnf5 -y copr enable solopasha/hyprland 
dnf5 -y install swww hyprlock
dnf5 -y copr disable solopasha/hyprland 


dnf5 -y remove firefox nvtop htop

#### Example for enabling a System Unit File

systemctl enable podman.socket

