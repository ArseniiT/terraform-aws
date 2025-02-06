# This file contains the configuration to create an EC2 instance in AWS
resource "aws_instance" "apache_php" {
    # AMI ID for Ubuntu 24.04
    ami = "ami-04b4f1a9cf54c11d0"
    # Instance type
    instance_type = "t2.micro"
    # Key pair name for SSH access
    key_name = "vockey"
    # Security group, "aws_security_group" "web_sg" is created in securitygroup.tf
    vpc_security_group_ids = [aws_security_group.web_sg.id]

    # script to install apache server and PHP
    user_data = <<-EOF
        #!/bin/bash
        sudo apt update -y
        sudo apt install apache2 -y
        sudo systemctl start apache2
        sudo systemctl enable apache2
        sudo apt install php libapache2-mod-php php-mysql -y
        sudo systemctl restart apache2
        echo "<?php phpinfo(); ?>" > /var/www/html/index.php
    EOF

    tags = {
        Name = "apache_php"
    }
}