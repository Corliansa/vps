# Shard VPS Docker Compose

## Setup

1. Clone this repo
   `git clone https://github.com/corliansa/vps`
1. Point your domain name to your shard vps
1. Run `setup.sh <YOUR_DOMAIN>` in the clone directory to replace current domain and server name configuration with your own domain and setup docker, folders, and tailscale config. You need to authenticate tailscale with your account in this step.
1. Point the http path env variables in `docker-compose.yml` to your coolify traefik webhook
1. Run your docker compose `docker compose up`. Use -d flag to run docker compose in detached mode

## Services

- `tailscale` creates a peer-to-peer mesh network, it can also be used as exit node so you can route your traffic to your vps
  - To enable use as exit node, Go to tailscale admin and click on Machines. Open your node's route settings and switch on `Use as exit node`
- `portainer` is a container manager. It exposes port 9443 for its admin console.
  - For security reason, portainer's admin console first setup will shut down if you don't set it up for some time. You will need to restart portainer to do the first setup
  - Portainer is really helpful to access container logs, you can also run commands inside of the container using portainer admin console
- `coolify` is self hosted alternative to netlify, you can host your applications, services and databases using coolify

## Adding new services

- You can add more service to the docker compose, or create a new `docker-compose.yml`. If you don't intend to route the exposed ports from the service using nginx, it's better to just create a new `docker-compose.yml`
- You can add new stack or container using portainer
- You can add applications and services using coolify
