docker compose run --rm certbot certonly --webroot --webroot-path /var/www/certbot/ -d corliansa.xyz
docker compose run --rm certbot certonly --webroot --webroot-path /var/www/certbot/ -d dns.corliansa.xyz
find . -name 'privkey.pem' -execdir cp {} 'private.key' ';'
find . -name 'fullchain.pem' -execdir cp {} 'public.crt' ';'