provider "aws" {
  region = var.region
}

resource "aws_vpc" "k8s_vpc" {
  cidr_block = "10.10.0.0/16"
}

resource "aws_subnet" "k8s_subnet" {
  vpc_id = aws_vpc.k8s_vpc.id
  cidr_block = "10.10.1.0/24"
  map_public_ip_on_launch = true
}


resource "aws_internet_gateway" "k8s_igw" {
  vpc_id = aws_vpc.k8s_vpc.id
}

resource "aws_route_table" "k8s_rt" {
  vpc_id = aws_vpc.k8s_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.k8s_igw.id
    }
}

resource "aws_route_table_association" "k8s_rt_assoc" {
    subnet_id = aws_subnet.k8s_subnet.id
    route_table_id = aws_route_table.k8s_rt.id  
}

resource "aws_security_group" "k8s_sg" {
  name          = "k8s_sg"
  description   = "Allow SSH, kubernetes Ports"
  vpc_id        = aws_vpc.k8s_vpc.id


  ingress {
    description     = "SSH"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  ingress {
    description         = "K8s API Server"
    from_port           = 6443
    to_port             = 6443
    protocol            = "tcp"
    cidr_blocks         = ["0.0.0.0/0"]

  }

  ingress {
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    cidr_blocks     = ["10.0.0.0/16"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "master" {
  count = var.master_count
  ami =  var.ami
  instance_type = var.instance_type
  subnet_id = aws_subnet.k8s_subnet.id
  key_name = var.key_name
  security_groups = [aws_security_group.k8s_sg.id]

  tags  = {
    Name = "k8s-master-${count.index + 1}"
  }
}

resource "aws_instance" "worker" {
  count = var.worker_count
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = aws_subnet.k8s_subnet.id
  key_name = var.key_name
  security_groups = [aws_security_group.k8s_sg.id]

  tags = {
    Name  = "k8s-worker-${count.index + 1}"
  }
}