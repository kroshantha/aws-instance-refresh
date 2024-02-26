resource "aws_vpc" "main" {
  cidr_block       = "15.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "activesgvpc"
  }
}

output "vpc_id" {
  value = aws_vpc.main.id
}

resource "aws_subnet" "public_subnets" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.public_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "Public Subnet ${count.index + 1}"
  }
}
resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "Private Subnet ${count.index + 1}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "activesgvpc_ig"
  }
}

resource "aws_route_table" "route_second" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "igw route"
  }
}
resource "aws_route_table_association" "pub_subnet_asso" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.route_second.id
}

resource "aws_eip" "nat_gateway" {
  domain = "vpc"
}
resource "aws_nat_gateway" "ng" {
  count         = 1
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = element(aws_subnet.public_subnets[*].id, count.index)

  tags = {
    Name = var.aws_nat_gateway
  }

  depends_on = [aws_internet_gateway.gw]
}
output "natgateway" {
  value = one(aws_nat_gateway.ng[*].id)
}
resource "aws_route_table" "route_nat" {
  vpc_id = aws_vpc.main.id

  route {

    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = one(aws_nat_gateway.ng[*].id)
  }

  tags = {
    Name = "nat_route"
  }
}
resource "aws_route_table_association" "prv_subnet_asso" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
  route_table_id = aws_route_table.route_nat.id
}

output "private_subents" {
  value = { for k, v in aws_subnet.private_subnets : k => v.id }
}

output "public_subents" {
  value = { for k, v in aws_subnet.public_subnets : k => v.id }
}