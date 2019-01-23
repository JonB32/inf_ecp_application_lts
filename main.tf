locals {
  vpc_id = "${module.vpc.this_vpc_id}"
}

provider "aws" {
  region = "${var.region}"
}

module "vpc" {
  source = "./vpc"
}

module "jumpbox01" {
  vpc_id              = "${local.vpc_id}"
  source              = "./jumpbox"
  instance_name       = "jumpbox01"
  key_name            = "AWSJenkinsWS-pem"
  ingress_cidr_blocks = ["0.0.0.0/0"]
}

module "vault01" {
  vpc_id              = "${local.vpc_id}"
  source              = "./vault"
  instance_name       = "vault01"
  key_name            = "AWSJenkinsWS-pem"
  ingress_cidr_blocks = "${module.vpc.this_public_subnets_cidr_blocks}"
}
