# Install docker engine
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

# Create folder
mkdir -p ./nginx/conf
mkdir -p ./certbot/conf
mkdir -p ./certbot/www
mkdir -p ./minio/data
sudo chown 1001 ./minio/data

# Download tailscale
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up --advertise-exit-node