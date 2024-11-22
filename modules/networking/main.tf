# networking main.tf

# create VPC
resource "aws_vpc" "coalfire_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "coalfire-vpc"
  }
}

# public subnet
resource "aws_subnet" "coalfire_public_subnet" {
  count                   = length(var.public_cidrs)
  vpc_id                  = aws_vpc.coalfire_vpc.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zones[count.index]

  tags = {
    Name = "coalfire-public-subnet-${count.index + 1}"
  }
}

# private subnet
resource "aws_subnet" "coalfire_private_subnet" {
  count             = length(var.private_cidrs)
  vpc_id            = aws_vpc.coalfire_vpc.id
  cidr_block        = var.private_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "coalfire-private-subnet-${count.index + 1}"
  }
}

# internet gateway and NAT gateway
resource "aws_internet_gateway" "coalfire_internet_gateway" {
  vpc_id = aws_vpc.coalfire_vpc.id

  tags = {
    Name = "coalfire-igw"
  }
}

resource "aws_eip" "coalfire_eip" {
  vpc = true
}

resource "aws_nat_gateway" "coalfire_nat_gateway" {
  allocation_id = aws_eip.coalfire_eip.id
  subnet_id     = aws_subnet.coalfire_public_subnet[0].id

  tags = {
    Name = "coalfire-nat-gateway"
  }
}

# route tables and association
resource "aws_route_table" "coalfire_public_rt" {
  vpc_id = aws_vpc.coalfire_vpc.id

  tags = {
    Name = "coalfire-public-rt"
  }
}

resource "aws_route" "default_public_route" {
  route_table_id         = aws_route_table.coalfire_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.coalfire_internet_gateway.id
}

resource "aws_route_table_association" "coalfire_public_assoc" {
  count          = length(var.public_cidrs)
  subnet_id      = aws_subnet.coalfire_public_subnet[count.index].id
  route_table_id = aws_route_table.coalfire_public_rt.id
}

resource "aws_route_table" "coalfire_private_rt" {
  vpc_id = aws_vpc.coalfire_vpc.id

  tags = {
    Name = "coalfire-private-rt"
  }
}

resource "aws_route" "default_private_route" {
  route_table_id         = aws_route_table.coalfire_private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.coalfire_nat_gateway.id
}

resource "aws_route_table_association" "coalfire_private_assoc" {
  count          = length(var.private_cidrs)
  subnet_id      = aws_subnet.coalfire_private_subnet[count.index].id
  route_table_id = aws_route_table.coalfire_private_rt.id
}

# security group
resource "aws_security_group" "coalfire_public_sg" {
  name        = "coalfire-public-sg"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.coalfire_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.access_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "coalfire_private_sg" {
  name        = "coalfire-private-sg"
  description = "Allow SSH from bastion and HTTP from web"
  vpc_id      = aws_vpc.coalfire_vpc.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.coalfire_public_sg.id]
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
