##################################################################
# Data sources to get VPC, subnet, security group and AMI details
##################################################################
data "aws_vpc" "selected" {
  id = "${var.vpc_id}"
}

data "aws_subnet_ids" "private" {
  vpc_id = "${data.aws_vpc.selected.id}"

  tags = {
    Tier = "private"
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name = "name"

    values = [
      "amzn-ami-hvm-*-x86_64-gp2",
    ]
  }

  filter {
    name = "owner-alias"

    values = [
      "amazon",
    ]
  }
}

module "vault_security_group" {
  source = "git@github.com:JonB32/inf_ecp_networking.git//modules/security-group/ssh/"

  name        = "sgECP_vault"
  description = "Security group for vault server, egress ports are all world open"
  vpc_id      = "${data.aws_vpc.selected.id}"

  ingress_cidr_blocks = "${var.ingress_cidr_blocks}" #["172.31.248.0/28"]
  ingress_rules       = ["ssh-tcp"]

  ingress_with_cidr_blocks = [
    {
      from_port   = 8500
      to_port     = 8500
      protocol    = "tcp"
      description = "User-service ports"
      cidr_blocks = "${var.ingress_cidr_blocks[0]}"
    },
    {
      from_port   = 8200
      to_port     = 8200
      protocol    = "tcp"
      description = "User-service ports"
      cidr_blocks = "${var.ingress_cidr_blocks[0]}"
    },
  ]

  egress_rules = ["all-all"]

  tags = {
    Name = "sgVault"
  }
}

module "ec2" {
  source = "../modules/ec2_instance"

  instance_count = 1

  name                   = "${var.instance_name}"
  ami                    = "${data.aws_ami.amazon_linux.id}"
  key_name               = "${var.key_name}"
  instance_type          = "${var.instance_type}"
  subnet_id              = "${element(data.aws_subnet_ids.private.ids, 0)}"
  vpc_security_group_ids = ["${module.vault_security_group.this_security_group_id}"]

  tags = {
    Name = "${var.instance_name}"
    App  = "vault"
  }
}
