# Setup docker
# only if docker is not installed
if [ ! -x "$(command -v docker)" ]; then
  sudo apt-get update
  sudo apt-get install \
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
  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
fi

# Setup folders
mkdir -p ./nginx/conf
mkdir -p ./certbot/conf
mkdir -p ./certbot/www
mkdir -p ./portainer/data
mkdir -p ./minio/data
sudo chown 1001 ./minio/data

# Setup adguard
sudo mkdir -p /etc/systemd/resolved.conf.d/
mv ./adguard/adguardhome.conf /etc/systemd/resolved.conf.d/adguardhome.conf
mv /etc/resolv.conf /etc/resolv.conf.backup
ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf
systemctl reload-or-restart systemd-resolved

# Setup tailscale
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up --advertise-exit-node
grep 'net.ipv4.ip_forward = 1' /etc/sysctl.d/99-tailscale.conf || echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
grep 'net.ipv6.conf.all.forwarding = 1' /etc/sysctl.d/99-tailscale.conf || echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
sudo sysctl -p /etc/sysctl.d/99-tailscale.conf