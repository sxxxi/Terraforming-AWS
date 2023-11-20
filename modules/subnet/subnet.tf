# List of currently available AZs
data "aws_availability_zones" "available_zones" {
  state = "available"
}

resource "aws_subnet" "l3_subnet" {
  vpc_id            = var.vpc_id
  count             = length(var.cidr_blocks)
  availability_zone = data.aws_availability_zones.available_zones.names[count.index]
  cidr_block        = var.cidr_blocks[count.index]
  tags = merge(
    tomap({
      Name = "L3 ${var.visibility}Subnet${count.index}"
    }),
    var.tags
  )
}