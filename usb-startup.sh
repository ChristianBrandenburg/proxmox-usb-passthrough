#!/bin/bash

# Script needs to run with root privileges

# Define the USB device name - fx "Yubico.com YubiHSM"
USB_DEV_NAME="Name of USB device

# Get the Bus and Device ID of the USB device
USB_BUS_DEV=$(lsusb | grep "${USB_DEV_NAME}" | awk '{print $2,$4}' | sed 's/://')

# Check if the USB device is detected
if [ -z "${USB_BUS_DEV}" ]; then
    logger -p user.err -t usb-lxc-setup "The specified USB device ${USB_DEV_NAME} is not detected."
    echo "The specified USB device is not detected."
    exit 1
fi

echo " The device has the following Bus and Device ID ${USB_BUS_DEV}"

# Define the configuration file path
LXC_CONFIG_PATH="/etc/pve/lxc/000.conf"

# Backup the original configuration file
cp "${LXC_CONFIG_PATH}" "${LXC_CONFIG_PATH}.bak"

# Replace the existing lxc.mount.entry line
sed -i "/lxc.mount.entry: \/dev\/bus\/usb\//d" "${LXC_CONFIG_PATH}"
echo "lxc.mount.entry: /dev/bus/usb/${USB_BUS_DEV// /\/} dev/bus/usb/${USB_BUS_DEV// /\/} none bind,optional,create=file" >> "${LXC_CONFIG_PATH}"

logger -p user.info -t usb-lxc-setup "The USB device ${USB_DEV_NAME} has been successfully added to the LXC configuration."
