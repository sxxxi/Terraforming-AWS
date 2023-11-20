variable "vpc_id" {
  type        = string
  description = "The ID of the VPC in which the subnet is going to be created"
}

variable "cidr_blocks" {
  type        = list(string)
  description = "List of subnet cidr blocks. First in the list is created first"
}

variable "tags" {
  type        = map(string)
  description = "Subnet resource tags"
  default     = {}
}

variable "visibility" {
  type = string
}

