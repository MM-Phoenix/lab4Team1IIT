provider "aws" {
  region = "eu-north-1"
}

resource "aws_key_pair" "lab4_key" {
  key_name   = "lab4-key"
  public_key = file("keyforlab4.pub")
}

resource "aws_security_group" "lab4_sg" {
  name        = "lab4-security-group"
  description = "Allow SSH and HTTP"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "lab4_instance" {
  ami           = "ami-0c1ac8a41498c1a9c"
  instance_type = "t3.micro"
  key_name      = aws_key_pair.lab4_key.key_name
  security_groups = [aws_security_group.lab4_sg.name]

  user_data = <<EOF
#!/bin/bash
apt update -y
apt install -y docker.io
systemctl start docker
systemctl enable docker
docker run -d -p 80:80 mariyamakasyeyeva/lab4:latest
EOF

  tags = {
    Name = "Lab4-Docker-App"
  }
}
