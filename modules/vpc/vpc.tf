# Create VPC
resource "aws_vpc" "l3_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = merge(
    var.default_tags,
    var.tags
  )
}

module "public_subnets" {
  source      = "../subnet"
  vpc_id      = aws_vpc.l3_vpc.id
  cidr_blocks = var.public_cidr_blocks
  visibility  = "Public"
  tags = merge(
    var.default_tags
  )
}

module "private_subnets" {
  source      = "../subnet"
  vpc_id      = aws_vpc.l3_vpc.id
  cidr_blocks = var.private_cidr_blocks
  visibility  = "Private"
  tags = merge(
    var.default_tags
  )
}

# IGW
resource "aws_internet_gateway" "l3_igw" {
  vpc_id = aws_vpc.l3_vpc.id

  tags = merge(
    var.default_tags,
    tomap({
      Name = "L3 IGW"
    })
  )
}

# Elastic IP
resource "aws_eip" "l3_eip" {
  tags = merge(
    var.default_tags,
    tomap({
      Name = "L3 EIP"
    })
  )
}

# NAT
resource "aws_nat_gateway" "l3_nat" {
  allocation_id = aws_eip.l3_eip.id
  subnet_id     = module.public_subnets.subnets[0].id
  tags = merge(
    var.default_tags,
    tomap({
      Name = "L3 NAT"
    })
  )
}

# Declare Route Tables for the subnets
resource "aws_route_table" "l3_vpc_public_subnet_rt" {
  vpc_id = aws_vpc.l3_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.l3_igw.id
  }
  tags = merge(
    var.default_tags,
    tomap({
      Name = "L3 PublicSubnetRT"
    })
  )
}

resource "aws_route_table" "l3_vpc_private_subnet_rt" {
  vpc_id = aws_vpc.l3_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.l3_nat.id
  }
  tags = merge(
    var.default_tags,
    tomap({
      Name = "L3 PrivateSubnetRT"
    })
  )
}

# Associate Route Tables to subnets
resource "aws_route_table_association" "l3_public_rt_assoc" {
  count          = length(var.public_cidr_blocks)
  subnet_id      = module.public_subnets.subnets.*.id[count.index]
  route_table_id = aws_route_table.l3_vpc_public_subnet_rt.id
}

resource "aws_route_table_association" "l3_private_rt_assoc" {
  count          = length(var.private_cidr_blocks)
  subnet_id      = module.private_subnets.subnets.*.id[count.index]
  route_table_id = aws_route_table.l3_vpc_private_subnet_rt.id
}
