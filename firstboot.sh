#!/bin/bash
set -e

source /opt/bootstrap/config.env

LOG=/var/log/firstboot.log

exec > >(tee -a $LOG)
exec 2>&1

echo "==== START FIRSTBOOT ===="

hostnamectl set-hostname $HOSTNAME

apt update
apt upgrade -y

apt install -y \
  curl \
  git \
  vim \
  htop \
  ca-certificates

# ------------------------------------------------
# Static Ethernet
# ------------------------------------------------

mkdir -p /etc/systemd/network

cat > /etc/systemd/network/20-wired.network <<EOF
[Match]
Name=eth0

[Network]
Address=${ETH_ADDRESS}
Gateway=${ETH_GATEWAY}
DNS=${ETH_DNS}
EOF

systemctl enable systemd-networkd
systemctl restart systemd-networkd

# ------------------------------------------------
# Docker
# ------------------------------------------------

curl -fsSL https://get.docker.com | sh

systemctl enable docker
systemctl start docker

usermod -aG docker souvikroy

apt install -y docker-compose-plugin

# ------------------------------------------------
# Tailscale
# ------------------------------------------------

curl -fsSL https://tailscale.com/install.sh | sh

tailscale up --authkey=${TAILSCALE_AUTHKEY}

# ------------------------------------------------
# GitOps Deploy
# ------------------------------------------------

mkdir -p /opt/apps

git clone -b ${GIT_BRANCH} ${GIT_REPO} /opt/apps

cd /opt/apps

docker compose up -d

# ------------------------------------------------
# Cleanup
# ------------------------------------------------

systemctl disable firstboot.service

echo "==== COMPLETE ===="

reboot
