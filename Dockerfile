# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: tyuan <marvin@42.fr>                       +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/08/21 12:51:01 by tyuan             #+#    #+#              #
#    Updated: 2020/09/23 01:20:29 by tyuan            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian:buster
LABEL maintainer="tyuan@student.42.fr"

#Donlowding, installing and set up
RUN apt-get update && apt-get install -y \
	nginx mariadb-server php-fpm php-mysql php-mbstring\
	&& rm -rf /var/lib/apt/lists/* \
	&& service mysql start \
	&& echo "CREATE DATABASE wpdb; \
	GRANT ALL ON wpdb.* TO 'wpuser'@'localhost' IDENTIFIED BY 'wppassword' WITH GRANT OPTION; \
	FLUSH PRIVILEGES;" | mysql
ADD --chown=www-data:www-data srcs/wordpress-5.5.1.tar.gz /var/www/html
ADD --chown=www-data:www-data srcs/phpMyAdmin-5.0.2-all-languages.tar.gz /var/www/html
RUN mv /var/www/html/phpMyAdmin-5.0.2-all-languages /var/www/html/phpmyadmin \
	&& chown -R www-data:www-data /var/www/html

#Configuration files for nginx server and phpmyadmin
COPY srcs/config.inc.php /var/www/html/phpmyadmin
COPY srcs/myserver.conf /etc/nginx/sites-enabled

#SSL certificate
COPY srcs/server.key srcs/server.crt /opt/

#Autoindex and its testing files
COPY srcs/site1.html srcs/site2.html /var/www/html/autotest/
ENV autoindex 1

#Ports
EXPOSE 80 443

#Start
COPY srcs/start.sh .
CMD ["./start.sh", "&&", "nginx", "-g", "daemon off;"]
