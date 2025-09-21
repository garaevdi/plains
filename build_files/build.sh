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
    gnome-text-editor \
    gnome-calculator \
    gnome-clocks baobab \
    gnome-contacts \
    simple-scan papers \
    loupe \
    showtime \
    decibels \
    file-roller \
    python3-pygit2 \
    python3-dbus \
    nautilus-python \
    gstreamer1-plugins-ugly \
    gstreamer1-plugins-bad-free-extras \
    gstreamer1-plugins-good-extras \
    adw-gtk3-theme \
    steam-devices \
    pop-launcher \
    btop

dnf5 -y install --setopt=install_weak_deps=false gnome-calendar

dnf5 -y copr enable trixieua/morewaita-icon-theme
dnf5 -y install morewaita-icon-theme
dnf5 -y copr disable trixieua/morewaita-icon-theme

dnf5 -y remove firefox yelp gnome-tour nvtop htop

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket