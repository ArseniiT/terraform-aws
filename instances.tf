# MySQL EC2 instance
resource "aws_instance" "mysql" {
  ami                    = "ami-04b4f1a9cf54c11d0" # Ubuntu 24.04
  instance_type          = "t2.micro"
  key_name               = "vockey"
  subnet_id              = aws_subnet.private_1.id
  vpc_security_group_ids = [aws_security_group.db_sg.id]

  depends_on = [aws_nat_gateway.nat]

  # Install MySQL and create Gestion database
  user_data = <<-EOF
    #!/bin/bash

    # Wait for internet сщттусешщт to be available
    while ! ping -c 1 -W 1 8.8.8.8; do
        echo "Waiting for internet access..."
        sleep 5
    done

    sudo apt update -y
    sudo apt install mysql-server -y
    sudo systemctl start mysql
    sudo systemctl enable mysql

    sudo systemctl status mysql > /var/log/mysql_status.log

    sudo sed -i 's/^bind-address\s*=.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf
    sudo sed -i 's/^mysqlx-bind-address\s*=.*/mysqlx-bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf
    sudo systemctl restart mysql

    sudo systemctl status mysql >> /var/log/mysql_status.log

    mysql -u root -e "CREATE DATABASE Gestion;"
    mysql -u root -e "CREATE USER '${var.db_username}'@'%' IDENTIFIED BY '${var.db_password}';"
    mysql -u root -e "GRANT ALL PRIVILEGES ON Gestion.* TO '${var.db_username}'@'%';"
    mysql -u root -e "FLUSH PRIVILEGES;"

    mysql -u root -e "SHOW DATABASES;" >> /var/log/mysql_create_db.log 2>&1

    mysql -u ${var.db_username} -p${var.db_password} -e "
      USE Gestion;
      CREATE TABLE Personne (
        id INT AUTO_INCREMENT PRIMARY KEY,
        nom VARCHAR(100),
        prenom VARCHAR(100)
      );
    INSERT INTO Personne (nom, prenom) VALUES ('Thornton', 'Bob');
    "
  EOF

  tags = {
    Name = "mysql_server"
  }
}

# Apache and PHP EC2 instance
resource "aws_instance" "apache_php" {
    # AMI ID for Ubuntu 24.04
    ami = "ami-04b4f1a9cf54c11d0"
    # Instance type
    instance_type = "t2.micro"
    # Key pair nom for SSH access
    key_name = "vockey"
    subnet_id                   = aws_subnet.public_1.id
    vpc_security_group_ids      = [aws_security_group.apache_php_sg.id]
    associate_public_ip_address = true

    # script to install apache server and PHP
    user_data = <<-EOF
        #!/bin/bash
        sudo apt update -y
        sudo apt install apache2 -y
        sudo systemctl start apache2
        sudo systemctl enable apache2
        sudo apt install php libapache2-mod-php php-mysql -y
        sudo systemctl restart apache2
        
        cat <<EOT > /var/www/html/index.php
        <?php
        \$servername = "${aws_instance.mysql.private_ip}";
        \$username = "${var.db_username}";
        \$password = "${var.db_password}";
        \$dbname = "Gestion";

        \$conn = new mysqli(\$servername, \$username, \$password, \$dbname);

        if (\$conn->connect_error) {
            die("Connection failed: " . \$conn->connect_error);
        }

        \$sql = "SELECT * FROM Personne";
        \$result = \$conn->query(\$sql);

        while(\$row = \$result->fetch_assoc()) {
            echo "Utilisateur: " . \$row["nom"] . " - Prenom: " . \$row["prenom"] . "<br>";
        }

        \$conn->close();
        ?>
        EOT
    EOF

    tags = {
        Name = "apache_php"
    }
}

# Output the URL of the deployed Apache-PHP server for easy access
output "website_url" {
  description = "URL of the deployed Apache-PHP server"
  value       = "http://${aws_instance.apache_php.public_ip}/index.php"
}
