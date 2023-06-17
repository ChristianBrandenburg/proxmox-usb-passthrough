# proxmox-usb-passthrough

This script can be used for USB passhtrough to an LXC container on a Proxmox host.

My usecase for this script was to passthrough a Yubico HSM to a LXC container on Proxmox host startup.
Everytime the Proxmox host restarted the Yubico HSM would get a new bus and device ID, so this script was made to automate adding the ID to the container configuration file.

## Requirements
- Bash
- Script needs to run as root

## Usage

To run this script at server start create a systemd service file:<br>
`/etc/systemd/system/usb-startup.service`


Example service file:

      [Unit]
      Description=USB passthrough
      After=network.target

      [Service]
      ExecStart=/path/to/usb-startup.sh
      Type=oneshot
      RemainAfterExit=yes

      [Install]
      WantedBy=multi-user.target

Ensure that the script is executable<br>
`chmod +x /path/to/usb-startup.sh`

Enable the systemd service<br>
`systemctl enable usb-startup`

Start the systemd service<br>
`systemctl start usb-startup`

