# ==== The VPC ======
resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name    = "${var.vpc_name}"
    purpose = "ARC IAC"
  }
}

# Creating Public Subnet
resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnet_cidr)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.public_subnet_cidr, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet"
  }
}

# Creating Private Subnet
resource "aws_subnet" "private_subnet" {
  count                   = length(var.private_subnet_cidr)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.private_subnet_cidr, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name = "Private Subnet"
  }
}

# Creating Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name    = "default igw"
    purpose = "ARC IAC"
  }

}

# Creating Route Table
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name    = "Route Table"
    purpose = "ARC IAC"
  }

}

# Route Table Association
resource "aws_route_table_association" "public_subnet_asso" {
  count          = length(var.public_subnet_cidr)
  subnet_id      = element(aws_subnet.public_subnet[*].id, count.index)
  route_table_id = aws_route_table.rt.id
}

# Creating Private Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gtw.id
  }

  tags = {
    Name    = "Private Route Table"
    purpose = "ARC IAC"
  }

}

# Private Route Table Association
resource "aws_route_table_association" "private_subnet_asso" {
  count          = length(var.private_subnet_cidr)
  subnet_id      = element(aws_subnet.private_subnet[*].id, count.index)
  route_table_id = aws_route_table.private_rt.id
}

# Creating an Elastic IP for the NAT Gateway!
resource "aws_eip" "nat_gtw_eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.gw]

}

# Creating a NAT Gateway!
resource "aws_nat_gateway" "nat_gtw" {
  depends_on    = [aws_eip.nat_gtw_eip]
  allocation_id = aws_eip.nat_gtw_eip.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name = "nat-gtw"
  }

}

# Creating a Route Table for the Nat Gateway!
resource "aws_route_table" "NAT-Gateway-RT" {
  depends_on = [aws_nat_gateway.nat_gtw]
  vpc_id     = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gtw.id
  }

  tags = {
    Name = "nat-gtw-rt"
  }

}
