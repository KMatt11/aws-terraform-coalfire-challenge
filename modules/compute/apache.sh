#!/bin/bash
# update system and install apache
yum update -y
yum install -y httpd

# enable and start the apache
systemctl enable httpd
systemctl start httpd

echo "<h1>Welcome to Coalfire!</h1>" > /var/www/html/index.html
echo "<p>You should hire Kinsey Matthews. Seriously, look how well this server runs!</p>" >> /var/www/html/index.html