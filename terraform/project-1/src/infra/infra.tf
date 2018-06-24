
provider "aws" {
  region = "${var.region}"
}

resource "aws_eip" "nat" {
  vpc      = true
  lifecycle { create_before_destroy = true }
}

module "network" {
  source = "../../modules/infra/aws"

  stack                        = "${var.stack}"
  owner                        = "${var.owner}"
  region                       = "${var.region}"
  vpc_domain                   = "${var.vpc_domain}"
  vpc_cidr                     = "${var.vpc_cidr}"
  account                      = "${var.account}"

  nat_azs                      = "${var.nat_azs}"
  nat_cidrs                    = "${var.nat_cidrs}"
  nat_eip_ids                  = "${aws_eip.nat.id}"

  bastion_azs                  = "${var.bastion_azs}"
  bastion_cidrs                = "${var.bastion_cidrs}"
  bastion_flavor               = "${var.bastion_flavor}"
  bastion_image                = "${var.bastion_image}"
  ssh_ingress_cidrs            = "${data.terraform_remote_state.global.myip_cidrs}"
  bastion_iam_instance_profile = "${data.terraform_remote_state.global.bastion_iam_instance_profile}"
  public_key_path              = "${path.module}/local_sshkey_${var.stack}.pub"
}
