locals {
  iam_instance_profile       = "LabInstanceProfile"
  iam_role                   = "LabRole"
  vpc_cidr_block             = "10.1.0.0/16"
  public_subnet_cidr_blocks  = ["10.1.1.0/24", "10.1.3.0/24"]
  private_subnet_cidr_blocks = ["10.1.2.0/24", "10.1.4.0/24"]
  cats_repo_name             = "l3-cats-repo"
  dogs_repo_name             = "l3-dogs-repo"
  default_tags = {
    Owner       = "Seiji Akakabe"
    OwnerID     = "991617069"
    Environment = "Lab3"
  }
}
