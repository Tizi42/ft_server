#!bin/bash

if [ $autoindex == 1 ]
then
   echo "autoindex on;" >> /etc/nginx/sites-enabled/myserver.conf
fi

service mysql start
#echo "CREATE DATABASE wpdb; GRANT ALL ON wpdb.* TO 'wpuser'@'localhost' IDENTIFIED BY '123456' WITH GRANT OPTION; FLUSH PRIVILEGES;" | mysql

service php7.3-fpm start

nginx -g "daemon off;"
