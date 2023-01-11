if [ -z $1 ] 
then
    echo "Invalid argument! Syntax: ./replacer.sh <YOUR_DOMAIN>"
    exit 1
fi

DOMAIN=$1

sed -i.bak "s/corliansa.xyz/${DOMAIN}/g" docker-compose.yml
sed -i.bak "s/corliansa.xyz/${DOMAIN}/g" certbot.sh 
sed -i.bak "s/corliansa.xyz/${DOMAIN}/g" nginx/default.stream.conf
sed -i.bak "s/corliansa.xyz/${DOMAIN}/g" nginx/conf/default.conf
sed -i.bak "s/corliansa.xyz/${DOMAIN}/g" nginx/app.conf 
find . -name "*.bak" -type f -delete