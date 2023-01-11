mv -f nginx/default.stream.conf nginx/conf/default.stream.conf
mv -f nginx/app.conf nginx/conf/app.conf
sed -z 's/# uncomment after ssl certificate is generated\n\s*#\s*//g' -i docker-compose.yml