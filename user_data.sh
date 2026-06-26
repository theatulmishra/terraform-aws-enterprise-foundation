#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<h1>Deployed via Terraform Enterprise Foundation Module</h1>" > /var/www/html/index.html
