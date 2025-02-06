# MySQL EC2 instance
resource "aws_instance" "mysql" {
  ami                    = "ami-04b4f1a9cf54c11d0" # Ubuntu 24.04
  instance_type          = "t2.micro"
  key_name               = "vockey"
  vpc_security_group_ids = [aws_security_group.db_sg.id]

  # Install MySQL and create Gestion database
  user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install mysql-server -y
    sudo sed -i 's/^bind-address\s*=.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf

    sudo systemctl start mysql
    sudo systemctl enable mysql

    mysql -u root -e "CREATE DATABASE Gestion;"
    mysql -u root -e "CREATE USER '${var.db_username}'@'%' IDENTIFIED BY '${var.db_password}';"
    mysql -u root -e "GRANT ALL PRIVILEGES ON Gestion.* TO '${var.db_username}'@'%';"
    mysql -u root -e "FLUSH PRIVILEGES;"

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
    # Security group, "aws_security_group" "apache_php_sg" is created in securitygroup.tf
    vpc_security_group_ids = [aws_security_group.apache_php_sg.id]

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