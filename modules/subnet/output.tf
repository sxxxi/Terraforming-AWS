output "subnets" {
  value = aws_subnet.l3_subnet
}

output "count" {
  value = length(aws_subnet.l3_subnet)
}