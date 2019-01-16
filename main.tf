provider "aws" {
  region = "${var.region}"
}

module "jumpbox01" {
  source        = "./jumpbox"
  instance_name = "jumpbox01"
}
