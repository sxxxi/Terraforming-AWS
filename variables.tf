variable "default_tags" {
  type        = map(string)
  description = "Default tags for AWS resources"
  default = {
    Owner       = "Seiji Akakabe"
    OwnerID     = "991617069"
    Environment = "Lab3"
  }
}