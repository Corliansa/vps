if [ -z $1 ] 
then
    echo "Invalid argument! Syntax: ./replacer.sh <YOUR_DOMAIN>"
    exit 1
fi

DOMAIN=$1

sed -i.bak "s/corliansa.xyz/${DOMAIN}/g" docker-compose.yml
sed -i.bak "s/corliansa.xyz/${DOMAIN}/g" replacer/data/data.js

find . -name "*.bak" -type f -delete