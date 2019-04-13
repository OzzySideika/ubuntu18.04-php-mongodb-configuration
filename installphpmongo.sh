#!/bin/bash
cd /;
# Initial update of packages
sudo apt-get upgrade -y;
sudo apt-get update -y;

# Installing required packages for mongo-php
sudo apt-get install mongodb apache2 php7.2 libapache2-mod-php7.2 php7.2-mongodb php7.2-dev -y;

# Creating symlinks
sudo systemctl enable mongodb;
sudo systemctl enable apache2;

# Download, compile and install mongo-php-driver from the git repo
echo "Installing mongo-php-driver...";
sudo git clone https://github.com/mongodb/mongo-php-driver.git;
cd mongo-php-driver;
git submodule sync && git submodule update --init;
phpize;
./configure;
make; 
sudo make install;
echo "mongo-php-driver Installed...";

# Append settings to php.ini file
echo "extension=mongodb.so;" >> /etc/php/7.2/apache2/php.ini;

# Restart Apache2
sudo systemctl restart apache2;

# Creates a php directory and a phpinfo file
sudo mkdir /var/www/html/php;
sudo touch /var/www/html/php/info.php;
sudo echo "<?php phpinfo(); ?>" >> /var/www/html/php/info.php;

echo "PHP and MongDB installed and configured...";
