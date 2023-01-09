mv -f nginx/default.conf nginx/conf/default.conf
mv -f nginx/app.conf nginx/conf/app.conf
sed -z 's/# uncomment after ssl certificate is generated\n\s*#\s*//g' -i docker-compose.yml