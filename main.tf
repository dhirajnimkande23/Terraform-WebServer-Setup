#Create VPC
resource "aws_vpc" "Webserver-VPC" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Webserver-VPC"
  }
}
#create subnet
resource "aws_subnet" "Webserver-Subnet" {
  vpc_id                  = aws_vpc.Webserver-VPC.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "Webserver-Subnet"
  }
}

#Create Security group
resource "aws_security_group" "http-web-sg" {
  name        = "http-web-sg"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.Webserver-VPC.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.Webserver-VPC.cidr_block]
  }

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.Webserver-VPC.cidr_block]
  }
  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.Webserver-VPC.cidr_block]
  }
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "http-web-sg"
  }
}

#Launch EC2 Instance
resource "aws_instance" "web-server" {
  ami                    = "ami-0ecb62995f68bb549"
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.webserver.key_name
  vpc_security_group_ids = [aws_security_group.http-web-sg.id]
  subnet_id              = aws_subnet.Webserver-Subnet.id

  tags = {
    Name = "Web-Server-Instance"
  }

  user_data = <<-EOF
                #!/bin/bash
                apt-get update
                apt-get install -y apache2
                systemctl start apache2
                systemctl enable apache2
                usermod -a -G apache ec2-user
                echo "Welcome to the webserver $(hostname -f)" > /var/www/html/index.html
                EOF 
}
