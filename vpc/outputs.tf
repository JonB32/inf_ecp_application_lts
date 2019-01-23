output "this_vpc_id" {
  description = "The ID of the VPC"
  value       = "${module.vpc.vpc_id}"
}

output "this_public_subnets_cidr_blocks" {
  description = "List of cidr_blocks of public subnets"
  value       = ["${module.vpc.public_subnets_cidr_blocks}"]
}

output "this_public_subnets" {
  description = "List of IDs of public subnets"
  value       = ["${module.vpc.public_subnets}"]
}

output "this_private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = ["${module.vpc.private_subnets_cidr_blocks}"]
}

output "this_private_subnets" {
  description = "List of IDs of private subnets"
  value       = ["${module.vpc.private_subnets}"]
}
