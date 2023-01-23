#! /bin/bash

# Replaces the domain name in the docker-compose.yml and replacer/data/data.js files, throw an error if no domain is provided
if [ -z $1 ] 
then
  echo "Invalid argument! Syntax: ./setup.sh <YOUR_DOMAIN>"
  exit 1
fi

DOMAIN=$1

sed -i.bak "s/corliansa.xyz/${DOMAIN}/g" docker-compose.yml
sed -i.bak "s/corliansa.xyz/${DOMAIN}/g" replacer/data/data.js

find . -name "*.bak" -type f -delete

# Setup docker if docker is not installed
if [ ! -x "$(command -v docker)" ]; then
  sudo apt-get update
  sudo apt-get -y install \
      ca-certificates \
      curl \
      gnupg \
      lsb-release
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update
  sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin
fi

# Setup adguard
if [ ! -f /etc/systemd/resolved.conf.d/adguardhome.conf ] 
then
  sudo mkdir -p /etc/systemd/resolved.conf.d/
  cp ./adguard/adguardhome.conf /etc/systemd/resolved.conf.d/adguardhome.conf
  mv /etc/resolv.conf /etc/resolv.conf.backup
  ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf
  systemctl reload-or-restart systemd-resolved
fi


# Setup tailscale
if [ ! -f /etc/sysctl.d/99-tailscale.conf ] 
then
  curl -fsSL https://tailscale.com/install.sh | sh
  sudo tailscale up --advertise-exit-node
  grep "net.ipv4.ip_forward = 1" /etc/sysctl.d/99-tailscale.conf || echo "net.ipv4.ip_forward = 1" | sudo tee -a /etc/sysctl.d/99-tailscale.conf
  grep "net.ipv6.conf.all.forwarding = 1" /etc/sysctl.d/99-tailscale.conf || echo "net.ipv6.conf.all.forwarding = 1" | sudo tee -a /etc/sysctl.d/99-tailscale.conf
  sudo sysctl -p /etc/sysctl.d/99-tailscale.conf
fi

# Create docker network
docker network create --driver bridge coolify --attachable || true

# Add coolify env variables
touch .env
grep "COOLIFY_APP_ID=" .env || echo "COOLIFY_APP_ID=$(cat /proc/sys/kernel/random/uuid)" >> .env
grep "COOLIFY_SECRET_KEY=" .env || echo "COOLIFY_SECRET_KEY=$(echo $(($(date +%s%N) / 1000000)) | sha256sum | base64 | head -c 32)" >> .env