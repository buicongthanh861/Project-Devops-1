terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

# Security Group
resource "aws_security_group" "demo-sg" {
  name        = "demo-sg"
  description = "Allow SSH, HTTP, HTTPS"
  vpc_id = aws_vpc.congthanh-vpc.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    description = "Jenkins port"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "demo-sg"
  }
}

resource "aws_vpc" "congthanh-vpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "congthanh-vpc"
  }
}

resource "aws_subnet" "congthanh-public-subnet-01" {
  vpc_id            = aws_vpc.congthanh-vpc.id
  cidr_block = "10.1.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "ap-southeast-1a"
  tags = {
    Name = "congthanh-public-subnet-01" 
  }
}

resource "aws_subnet" "congthanh-public-subnet-02" {
  vpc_id            = aws_vpc.congthanh-vpc.id
  cidr_block = "10.1.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "ap-southeast-1b"
  tags = {
    Name = "congthanh-public-subnet-02" 
  }
}

resource "aws_internet_gateway" "congthanh-igw" {
  vpc_id = aws_vpc.congthanh-vpc.id
  tags = {
    Name = "congthanh-igw"
  }
}

resource "aws_route_table" "congthanh-public-rt" {
  vpc_id = aws_vpc.congthanh-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.congthanh-igw.id
  } 
}

resource "aws_route_table_association" "congthanh-rta-public-subnet-01" {
  subnet_id      = aws_subnet.congthanh-public-subnet-01.id
  route_table_id = aws_route_table.congthanh-public-rt.id
  
}


resource "aws_route_table_association" "congthanh-rta-public-subnet-02" {
  subnet_id      = aws_subnet.congthanh-public-subnet-02.id
  route_table_id = aws_route_table.congthanh-public-rt.id
  
}

# EC2 Instance
resource "aws_instance" "demo-server" {
  ami                    = "ami-0933f1385008d33c4"
  instance_type          = "t3.micro"
  key_name               = "congthanh-devops"
  subnet_id = aws_subnet.congthanh-public-subnet-01.id
  vpc_security_group_ids = [aws_security_group.demo-sg.id]
  for_each =  toset(["Jenkins", "Server-tomcat", "Ansible","Docker","EKS_Bootrap_server"])
  tags = {
    Name = each.key
  }
}


