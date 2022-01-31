provider "aws" {
  access_key = "AKIA2LFCMUAVX45XU2L6"
  secret_key = "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"
  region     = "us-east-1"
}

## Create VPC ##
resource "aws_vpc" "terraform-vpc" {
  cidr_block           = "172.16.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "terraform-demo-vpc"
  }
}

## Security Group##
resource "aws_security_group" "terraform_private_sg" {
  description = "Allow limited inbound external traffic"
  vpc_id      = aws_vpc.terraform-vpc.id
  name        = "terraform_ec2_private_sg"

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
  }

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8080
    to_port     = 8080
  }

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    to_port     = 443
  }

  egress {
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
  }

  tags = {
    Name = "ec2-private-sg"
  }
}

## Create Subnets ##
resource "aws_subnet" "terraform-subnet_1" {
  vpc_id            = aws_vpc.terraform-vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "terraform-subnet_1"
  }
}

resource "aws_instance" "terraform_wapp" {
  ami                         = "ami-0ed9277fb7eb570c9"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = ["${aws_security_group.terraform_private_sg.id}"]
  subnet_id                   = aws_subnet.terraform-subnet_1.id
  count                       = 1
  associate_public_ip_address = true
  tags = {
     "Schedule" : "Bangalore-office-hours"
  }
}

