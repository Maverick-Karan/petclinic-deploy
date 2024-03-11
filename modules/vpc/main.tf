# create VPC
resource "aws_vpc" "infra" {
  cidr_block              = var.vpc_cidr
  instance_tenancy        = "default"
  enable_dns_hostnames    = true

  tags      = {
    Name    = "${var.project_name}-vpc"
  }
}

# create INTERNET GATEWAY and attach it to vpc
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id    = aws_vpc.infra.id

  tags      = {
    Name    = "${var.project_name}-igw"
  }
}

# create PUBLIC SUBNET az1
resource "aws_subnet" "public_subnet_az1" {
  vpc_id                  = aws_vpc.infra.id
  cidr_block              = var.public_subnet_az1_cidr
  availability_zone       = var.az1
  map_public_ip_on_launch = true

  tags      = {
    Name    = "public subnet az1"
  }
}
# create PUBLIC SUBNET az2
resource "aws_subnet" "public_subnet_az2" {
  vpc_id                  = aws_vpc.infra.id
  cidr_block              = var.public_subnet_az2_cidr
  availability_zone       = var.az2
  map_public_ip_on_launch = true

  tags      = {
    Name    = "public subnet az2"
  }
}

# create PRIVATE SUBNET az1
resource "aws_subnet" "private_subnet_az1" {
  vpc_id                   = aws_vpc.infra.id
  cidr_block               = var.private_subnet_az1_cidr
  availability_zone        = var.az1
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "private subnet az1"
  }
}

# create PRIVATE SUBNET az2
resource "aws_subnet" "private_subnet_az2" {
  vpc_id                   = aws_vpc.infra.id
  cidr_block               = var.private_subnet_az2_cidr
  availability_zone        = var.az2
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "private subnet az2"
  }
}

# create SECURE SUBNET az1
resource "aws_subnet" "secure_subnet_az1" {
  vpc_id                   = aws_vpc.infra.id
  cidr_block               = var.secure_subnet_az1_cidr
  availability_zone        = var.az1
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "secure subnet az1"
  }
}

# create SECURE SUBNET az2
resource "aws_subnet" "secure_subnet_az2" {
  vpc_id                   = aws_vpc.infra.id
  cidr_block               = var.secure_subnet_az2_cidr
  availability_zone        = var.az2
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "secure subnet az2"
  }
}

# create ROUTE TABLE and add public route
resource "aws_route_table" "public_route_table" {
  vpc_id       = aws_vpc.infra.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags       = {
    Name     = "public route table"
  }
}

# associate public subnet az1 to "public route table"
resource "aws_route_table_association" "public_subnet_az1_route_table_association" {
  subnet_id           = aws_subnet.public_subnet_az1.id
  route_table_id      = aws_route_table.public_route_table.id
}

# associate public subnet az2 to "public route table"
resource "aws_route_table_association" "public_subnet_az2_route_table_association" {
  subnet_id           = aws_subnet.public_subnet_az2.id
  route_table_id      = aws_route_table.public_route_table.id
}