module "alb_lab_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "ALB-LAB"
  cidr = "10.0.0.0/16"

  azs             = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]

  enable_nat_gateway   = true
  create_igw           = true
  enable_dns_hostnames = true
  single_nat_gateway   = true

  tags = {
    GeneratedBy = "terraform"
    Environment = "dev"
  }
}


