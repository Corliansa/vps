# VPS Docker Compose

## Setup

1. Clone this repo
   `git clone https://github.com/corliansa/vps`
1. Point your domain name to your vps
1. Replace the nextjs image in the `docker-compose.yml` with your own image (Remember to expose port 3000 in the image)
1. Run `setup.sh <YOUR_DOMAIN>` in the clone directory to replace current domain and server name configuration with your own domain and setup docker, folders, adguard config and tailscale config. You need to authenticate tailscale with your account in this step.
1. Create a `.env` file based on `.env.example`, currently everything will already be setup by `setup.sh`, but you can customize it if you want
1. Run your docker compose `docker compose up`. Use -d flag to run docker compose in detached mode
1. Wait until all ssl certificates are generated by traefik

## Services

- `adguard` is a self hostable dns server. You can use it to block ads & tracker network wide
  - Adguard's port 3000 is exposed on port 5000 on host network
  - Go to port 5000 on host for first setup. You can choose to reuse port 3000 for adguard home console in first setup, it will then still be exposed on port 5000 on host. You can choose to route the ports using nginx instead of exposing the ports.
  - It is recommended to setup a ssl certificate, go to Settings > Encryption to set it up. The path to the ssl certificate should be `/certs/live/YOUR_DOMAIN/fullchain.pem` and `/certs/live/YOUR_DOMAIN/privkey.pem` for the private key. replace `YOUR_DOMAIN` with your own domain name. Currently the configured port in the docker compose is 3443:443
- `tailscale` creates a peer-to-peer mesh network, it can also be used as exit node so you can route your traffic to your vps, combined with adguard it can work as an ad blocking vpn.
  - To enable use as exit node, Go to tailscale admin and click on Machines. Open your node's route settings and switch on `Use as exit node`
- `portainer` is a container manager. It exposes port 9443 for its admin console.
  - For security reason, portainer's admin console first setup will shut down if you don't set it up for some time. You will need to restart portainer to do the first setup
  - Portainer is really helpful to access container logs, you can also run commands inside of the container using portainer admin console
- `coolify` is self hosted alternative to netlify, you can host your applications, services and databases using coolify
- `minio` is a self hosted s3 server. minio has been removed from the default stack but you can use coolify to deploy it instead
  - You can install `mc` to manage minio. Use `mc alias set ALIAS HOSTNAME ACCESS_KEY SECRET_KEY` to create an alias for s3 compatible service
  - Use `mc admin config set ALIAS notify_webhook:IDENTIFIER endpoint="<ENDPOINT>" auth_token="<string>"` to create new webhook notifier and run `mc admin service restart ALIAS` to restart the service
  - Run `mc event list ALIAS/BUCKET_NAME` to view all the set events in a bucket
  - replace `ALIAS`, `HOSTNAME`, `ACCESS_KEY`, `SECRET_KEY`, `IDENTIFIER`, `BUCKET_NAME` with your own data. `ACCESS_KEY` should be minio admin username and `SECRET_KEY` should be minio admin password
  - Read the documentation for [mc](https://min.io/docs/minio/linux/reference/minio-mc.html) and [mc-admin](https://min.io/docs/minio/linux/reference/minio-mc-admin.html)

## Adding new services

- You can add more service to the docker compose, or create a new `docker-compose.yml`. If you don't intend to route the exposed ports from the service using nginx, it's better to just create a new `docker-compose.yml`
- You can add new stack or container using portainer
- You can add applications and services using coolify

## Troubleshooting

- The vps is not using adguard dns?\
  Make sure `etc/systemd/resolved.conf.d/adguardhome.conf` and `/etc/resolv.conf` and `/etc/systemd/resolved.conf` is configured properly\
  Move `adguardhome.conf` to `/etc/systemd/resolved.conf.d/adguardhome.conf` and `/etc/resolv.conf` needs to have 2 line, beginning with `nameserver` and `search`. This should be configured automatically by tailscale, but if it's messed up you may need to correct it manually. Remember to check the values in `/etc/systemd/resolved.conf` too
