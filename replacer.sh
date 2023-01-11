DOMAIN=example.com

sed -i.bak "s/corliansa.xyz/${DOMAIN}/g" docker-compose.yml
sed -i.bak "s/corliansa.xyz/${DOMAIN}/g" certbot.sh 
sed -i.bak "s/corliansa.xyz/${DOMAIN}/g" nginx/default.stream.conf
sed -i.bak "s/corliansa.xyz/${DOMAIN}/g" nginx/conf/default.conf
sed -i.bak "s/corliansa.xyz/${DOMAIN}/g" nginx/app.conf 
find . -name "*.bak" -type f -delete