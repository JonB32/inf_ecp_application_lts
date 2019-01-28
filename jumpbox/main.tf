##################################################################
# Data sources to get VPC, subnet, security group and AMI details
##################################################################
data "aws_vpc" "selected" {
  id = "${var.vpc_id}"
}

data "aws_subnet_ids" "public" {
  vpc_id = "${data.aws_vpc.selected.id}"

  tags = {
    Tier = "public"
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

module "jumpbox_security_group" {
  source = "git@github.com:JonB32/inf_ecp_networking.git//modules/security-group/ssh/"

  name        = "sgECP_ssh_incoming"
  description = "Security group with SSH ports open for everybody (IPv4 CIDR), egress ports are all world open"
  vpc_id      = "${data.aws_vpc.selected.id}"

  ingress_cidr_blocks = "${var.ingress_cidr_blocks}"
  ingress_rules       = ["ssh-tcp"]

  ingress_with_cidr_blocks = [
    {
      from_port   = 3128
      to_port     = 3128
      protocol    = "tcp"
      description = "User-service ports"
      cidr_blocks = "10.10.0.0/16"
    },
  ]

  egress_rules = ["all-all"]

  tags = {
    Name = "sgSSHProxy"
  }
}

module "ec2" {
  source = "../modules/ec2_instance"

  instance_count = 1

  name                        = "${var.instance_name}"
  ami                         = "${data.aws_ami.amazon_linux.id}"
  key_name                    = "${var.key_name}"
  is_jump                     = "${var.is_jump}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${element(data.aws_subnet_ids.public.ids, 0)}"
  vpc_security_group_ids      = ["${module.jumpbox_security_group.this_security_group_id}"]
  associate_public_ip_address = true

  tags = {
    Name = "${var.instance_name}"
    App  = "jumpbox"
  }
}
