##################################################################
# Data sources to get VPC, subnet, security group and AMI details
##################################################################
data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = "${data.aws_vpc.default.id}"
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

module "ssh_security_group" {
  source = "git@github.com:JonB32/inf_ecp_networking.git//modules/security-group/ssh/"

  name        = "sgECP_ssh_incoming"
  description = "Security group with SSH ports open for everybody (IPv4 CIDR), egress ports are all world open"
  vpc_id      = "${data.aws_vpc.default.id}"

  ingress_cidr_blocks = ["0.0.0.0/0"]

  tags = {
    Name = "sgSSH"
  }
}

module "ec2" {
  source = "../modules/ec2"

  instance_count = 1

  name                        = "${var.instance_name}"
  ami                         = "${data.aws_ami.amazon_linux.id}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${element(data.aws_subnet_ids.all.ids, 0)}"
  vpc_security_group_ids      = ["${module.ssh_security_group.this_security_group_id}"]
  associate_public_ip_address = true

  tags = {
    Name = "jumpbox"
  }
}
