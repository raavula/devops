variable "account" { }

#
# IAM roles for bastion
#
module "iam_network" {
  source            = "../../modules/global/aws/iam/"
}

output "bastion_iam_instance_profile"          { value = "${module.iam_network.bastion_instance_profile}" }
