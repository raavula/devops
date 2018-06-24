variable "stack" { }
variable "owner" { }
variable "account" { }
variable "region" { }
variable "vpc_domain" { }
variable "vpc_cidr" { }
variable "zone_count" { default = 1 }
variable "bastion_image" { }
variable "bastion_flavor" { }
variable "bastion_azs" { }
variable "bastion_cidrs" { }
variable "bastion_iam_instance_profile" { }
variable "nat_azs" { }
variable "nat_cidrs" { }
variable "ssh_ingress_cidrs" { default = "0.0.0.0/0" }
variable "nat_eip_ids" { }
variable "default_sg_ids" { default = ""}
variable "public_key_path" {  }

provider "aws" {
  region = "${var.region}"
}

resource "aws_route53_zone" "root" {
  count      = "${var.zone_count}"
  name       = "${var.vpc_domain}"
  comment    = "${var.stack} private domain"
  vpc_id     = "${module.vpc.vpc_id}"
  vpc_region = "${var.region}"

  lifecycle { create_before_destroy = true }

  tags {
    Name        = "${var.stack}-dns"
    Stack       = "${var.stack}"
  }
}

module "vpc" {
  source = "./vpc"

  stack               = "${var.stack}"
  owner               = "${var.owner}"
  region              = "${var.region}"
  vpc_cidr            = "${var.vpc_cidr}"
}

module "bastion" {
  source = "./compute"

  stack                 = "${var.stack}"
  owner                 = "${var.owner}"
  account               = "${var.account}"
  region                = "${var.region}"
  availability_zones    = "${var.bastion_azs}"
  vpc_id                = "${module.vpc.vpc_id}"
  vpc_cidr              = "${var.vpc_cidr}"
  subnet_cidrs          = "${var.bastion_cidrs}"
  iam_instance_profile  = "${var.bastion_iam_instance_profile}"
  route_table_id        = "${module.vpc.public_route_table_id}"
  image                 = "${var.bastion_image}"
  flavor                = "${var.bastion_flavor}"
  default_sg_ids        = "${var.default_sg_ids}"
  ssh_ingress_cidrs     = "${var.ssh_ingress_cidrs}"
  ssh_egress_cidrs      = "${var.vpc_cidr}"
  public_key_path       = "${var.public_key_path}" 
}

module "nat" {
  source = "./nat"

  stack                 = "${var.stack}"
  owner                 = "${var.owner}"
  region                = "${var.region}"
  availability_zones    = "${var.nat_azs}"
  vpc_cidr              = "${var.vpc_cidr}"
  vpc_id                = "${module.vpc.vpc_id}"
  subnet_cidrs          = "${var.nat_cidrs}"
  route_table_id        = "${module.vpc.public_route_table_id}"
  eip_ids               = "${var.nat_eip_ids}"
}


# VPC
output "vpc_id"                  { value = "${module.vpc.vpc_id}" }
output "vpc_zone_id"             { value = "${aws_route53_zone.root.zone_id}" }
output "vpc_default_sg_id"       { value = "${module.vpc.default_security_group_id}" }
output "public_route_table_id"   { value = "${module.vpc.public_route_table_id}" }
output "private_route_table_ids" { value = "${module.nat.private_route_table_ids}" }

# NAT
output "nat_private_ips"  { value = "${module.nat.private_ips}" }
output "nat_public_ips"   { value = "${module.nat.public_ips}" }

# Bastion
output "bastion_user"        { value = "${module.bastion.user}" }
output "bastion_instance_id" { value = "${module.bastion.instance_id}" }
output "bastion_private_ip"  { value = "${module.bastion.private_ip}" }
output "bastion_public_ip"   { value = "${module.bastion.public_ip}" }
