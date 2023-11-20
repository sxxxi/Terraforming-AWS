output "vpc_id" {
  value = aws_vpc.l3_vpc.id
}


output "private_subnets" {
  value = module.private_subnets.subnets
}

output "public_subnets" {
  value = module.public_subnets.subnets
}

#output "ssh_sg" {
#  value = aws_security_group.ssh_sg.id
#}