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
    okular \
    gwenview \
    kcalc \
    ksystemlog \
    elisa-player \
    merkuro \
    gstreamer1-plugins-ugly \
    gstreamer1-plugins-bad-free-extras \
    gstreamer1-plugins-good-extras \
    adw-gtk3-theme \
    steam-devices \
    pop-launcher \
	fish
    
# dnf5 -y install --setopt=install_weak_deps=false gnome-calendar

# dnf5 -y copr enable trixieua/morewaita-icon-theme
# dnf5 -y install morewaita-icon-theme
# dnf5 -y copr disable trixieua/morewaita-icon-theme

dnf5 -y copr enable matinlotfali/KDE-Rounded-Corners
dnf5 -y install kwin-effect-roundcorners
dnf5 -y copr disable matinlotfali/KDE-Rounded-Corners

dnf5 -y copr enable deltacopy/darkly 
dnf5 -y install darkly
dnf5 -y copr disable deltacopy/darkly 

dnf5 -y config-manager addrepo --from-repofile=https://download.opensuse.org/repositories/home:paul4us/Fedora_42/home:paul4us.repo
dnf5 -y install --setopt=install_weak_deps=false klassy
dnf5 -y config-manager setopt home_paul4us.enabled=0

dnf5 -y remove firefox nvtop htop supergfxctl kdebugsettings fcitx5 ibus

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket

