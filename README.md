# VPS Docker Compose

## Setup

1. Clone this repo
   `git clone https://github.com/corliansa/vps`
1. Point your domain name to your vps
1. Create a `.env` file based on `.env.example`
1. Replace the domain name in `certbot.sh` with your own domain name
1. Replace the Dockerfile in `nextjs` directory with your own Dockerfile
1. Replace the server name in `default.conf` files with your own server name
1. Run `setup.sh` in the clone directory.
   This will setup docker, folders, adguard config and tailscale config. Currently tailscale is being run directly on host, but you can run it in docker if you want. You need to authenticate tailscale with your account in this step.
1. Run your docker compose `docker compose up`
1. Run `certbot.sh`. You only need to do this once, afther that uncomment the line in `docker-compose.yml`. This will setup automatic certificate renewal and reload nginx server
1. Replace `nginx/conf/default.conf` with `nginx/default.conf` to enable https
1. Reload your docker compose `docker compose down && docker compose up`

## Services

- `minio` is a self hosted s3 server. It exposes port 9000 for the s3 and 9001 for the admin console. You can also route it using nginx instead of exposing the ports
- `adguard` Go to port 3000 for first setup. This repo reuse port 3000 for adguard home console after first setup, and uses port 3030 for https admin console. Like `minio`, you can choose to route the ports using nginx instead of exposing the ports.
- `tailscale` creates a peer-to-peer mesh network, it can also be used as exit node so you can route your traffic to your vps, combined with adguard it can work as an ad blocking vpn.

## Adding new services

- You can add more service to the docker compose, or create a new `docker-compose.yml`. If you don't intend to route the exposed ports from the service using nginx, it's better to just create a new `docker-compose.yml`

## Troubleshooting

- The vps is not using adguard dns?\
  Make sure `etc/systemd/resolved.conf.d/adguardhome.conf` and `/etc/resolv.conf` is configured properly\
  Move `adguardhome.conf` to `etc/systemd/resolved.conf.d/adguardhome.conf` and `/etc/resolv.conf` needs to have 2 line, beginning with `nameserver` and `search`. This should be configured automatically by tailscale, but if it's messed up you need to correct it
