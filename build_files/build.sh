#!/bin/bash

set -ouex pipefail

### Install packages

dnf5 -y install @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin

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

dnf5 -y copr enable yalter/niri
dnf5 -y install --setopt=install_weak_deps=false niri
dnf5 -y copr disable yalter/niri

dnf5 -y install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra43' terra-release
dnf5 -y install opentabletdriver

dnf5 -y remove firefox nvtop htop qt5-qtbase

### Example for enabling a System Unit File

systemctl enable podman.socket

