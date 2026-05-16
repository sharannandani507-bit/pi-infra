# pi-infra

This creates a Raspberry Pi that:

auto-configures on first boot
sets static IP
installs Docker
installs Portainer
installs Tailscale
deploys apps from GitHub automatically
auto-updates containers
can be remotely managed forever

Open Raspberry Pi Imager:

Choose:

Raspberry Pi OS Lite (64-bit)

Before writing:
Press:

CTRL + SHIFT + X

Enable:

hostname
SSH
username/password
WiFi if needed
locale

Example:

Hostname: pi-node-01
Username: pi
Password: yourpassword

Write image.


PHASE 9 — Make firstboot Executable

On Linux/macOS:

chmod +x firstboot.sh
