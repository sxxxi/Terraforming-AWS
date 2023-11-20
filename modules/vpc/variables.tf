variable "vpc_cidr" {
  type = string
}

variable "counter" {
  type    = number
  default = 1
}

variable "public_cidr_blocks" {
  type = list(any)
}

variable "private_cidr_blocks" {
  type = list(any)
}

variable "default_tags" {
  type        = map(string)
  description = "Tags for the associated VPC resources"
}

variable "tags" {
  type        = map(string)
  description = "Tags for the VPC"
}