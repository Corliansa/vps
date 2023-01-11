rm -f nginx/conf/default.conf
mv -f nginx/default.stream.conf nginx/conf/default.stream.conf
mv -f nginx/app.conf nginx/conf/app.conf
mv -f nginx/nginx.new.conf nginx/nginx.conf
sed -z 's/# uncomment after ssl certificate is generated\n\s*#\s*//g' -i docker-compose.yml