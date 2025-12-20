#!/bin/bash

if [[ ! "${FLAVOUR}" =~ "nvidia" ]] ; then
    exit 0
fi

set -ouex pipefail

RELEASE="${rpm -E %fedora}"
: "${AKMODS_PATH:=/tmp/akmods-nvidia}"

find "${AKMODS_PATH}"/

if dnf5 repolist --all | grep -q rpmfusion; then
    dnf5 config-manager setopt "rpmfusion*".enabled=0
fi

dnf5 config-manager setopt fedora-cisco-openh264.enabled=0

NEGATIVO17_MULT_PREV_ENABLED=N
if dnf5 repolist --enabled | grep -q "fedora-multimedia"; then
    NEGATIVO17_MULT_PREV_ENABLED=Y
    echo "disabling negativo17-fedora-multimedia to ensure negativo17-fedora-nvidia is used"
    dnf5 config-manager setopt fedora-multimedia.enabled=0
fi

dnf5 -y install "${AKMODS_PATH}"/ublue-os/ublue-os-nvidia-addons-*.rpm

dnf5 config-manager setopt fedora-nvidia.enabled=1

source "${AKMODS_PATH}"/kmods/nvidia-vars

dnf5 -y install \
    libnvidia-fbc \
    libva-nvidia-driver\
    nvidia-driver \
    nvidia-driver-cuda \
    nvidia-modprobe \
    nvidia-persistenced \
    nvidia-settings \
    "${AKMODS_PATH}"/kmods/kmod-nvidia-*.rpm

KMOD_VERSION="$(rpm -q --queryformat '%{VERSION}' kmod-nvidia)"
DRIVER_VERSION="$(rpm -q --queryformat '%{VERSION}' nvidia-driver)"
if [ "$KMOD_VERSION" != "$DRIVER_VERSION" ]; then
    echo "Error: kmod-nvidia version ($KMOD_VERSION) does not match nvidia-driver version ($DRIVER_VERSION)"
    exit 1
fi

dnf5 config-manager setopt fedora-nvidia.enabled=0

sed -i "s/^MODULE_VARIANT=.*/MODULE_VARIANT=$KERNEL_MODULE_TYPE/" /etc/nvidia/kernel.conf

cp /etc/modprobe.d/nvidia-modeset.conf /usr/lib/modprobe.d/nvidia-modeset.conf
sed -i 's@omit_drivers@force_drivers@g' /usr/lib/dracut/dracut.conf.d/99-nvidia.conf
sed -i 's@ nvidia @ i915 amdgpu nvidia @g' /usr/lib/dracut/dracut.conf.d/99-nvidia.conf

if [[ "${NEGATIVO17_MULT_PREV_ENABLED}" = "Y" ]]; then
    dnf5 config-manager setopt fedora-multimedia.enabled=1
fi