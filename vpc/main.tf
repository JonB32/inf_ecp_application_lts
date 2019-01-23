module "vpc" {
  source = "git@github.com:JonB32/inf_ecp_networking.git//modules/vpc/"

  name = "poc_ecp_vpc"

  cidr = "10.10.0.0/16" #dev tier, would have to change for other environments/workspaces

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.10.1.0/24"]

  private_subnet_tags = {
    Tier = "private"
  }

  public_subnets = ["10.10.11.0/24"]

  public_subnet_tags = {
    Tier = "public"
  }

  tags = {
    Environment = "dev"
    Name        = "poc_ecp_vpc"
  }
}
