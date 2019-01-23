variable "vpc_id" {}

variable "instance_name" {
  default = "jumpbox"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ingress_cidr_blocks" {
  type = "list"
}

variable "key_name" {}
