# secyrity group configuration for SSH and HTTP access
resource "aws_security_group" "web_sg" {
    name = "allow_ssh_http"
    description = "Allow SSH and HTTP inbound traffic"
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}