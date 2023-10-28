provider "aws" {
  region     = "ap-south-1"
  
}

# Create VPC

resource "aws_vpc" "myvpc1" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "myvpc"
  }
}

# Create Subnet 

resource "aws_subnet" "mysubnet" {
  vpc_id     = aws_vpc.myvpc1.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "mysubnet"
  }
}

# Internet Gateway

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.myvpc1.id

  tags = {
    Name = "IGW"
  }
}

# Route Table

resource "aws_route_table" "myrt" {
  vpc_id = aws_vpc.myvpc1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    Name = "myrt"
  }
}

# Route Table Association

resource "aws_route_table_association" "myrta" {
  subnet_id      = aws_subnet.mysubnet.id
  route_table_id = aws_route_table.myrt.id
}

# Security Groups

resource "aws_security_group" "mysg" {
  name        = "mysg"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.myvpc1.id

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
 
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "mysg"
  }
}

# Create Network Interface

resource "aws_network_interface" "mynic" {
  subnet_id       = aws_subnet.mysubnet.id
  security_groups = [aws_security_group.mysg.id]

  attachment {
    instance     = aws_instance.sadinstance2.id
    device_index = 1
  }
}

  
# Create Elastic IP

resource "aws_eip" "myeip" {
  instance = aws_instance.sadinstance2.id
  domain   = "vpc"
}

# Create Instance

resource "aws_instance" "sadinstance2" {
  ami           = "ami-08e5424edfe926b43"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  subnet_id = aws_subnet.mysubnet.id
  vpc_security_group_ids = [aws_security_group.mysg.id]
  key_name = "Mumbai"
}
  
user_data = <<-EOF
#!/bin/bash
sudo apt-get update -y
sudo apt install docker.io -y
sudo systemctl enable docker
sudo docker run -itd -p 8086:8081 vineethkvr1/project1:latest
sudo docker start $(docker ps -aq)
EOF
 tags = {
    Name = "Infra-Server"
   }
}



