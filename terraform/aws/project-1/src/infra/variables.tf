variable "account" { }
variable "region" { }
variable "default_azs" { }
variable "vpc_domain" { default = "ssp.com" }
variable "vpc_dns_resolver" { }
variable "vpc_cidr" { }
variable "bastion_cidrs" { }
variable "application_cidrs" { }
variable "nat_cidrs" { }
variable "default_flavor" { default = "t2.small" }
variable "small_flavor" { default = "t2.small" }
variable "medium_flavor" { default = "t2.medium" }
variable "bastion_flavor" { }
variable "multi_region" { default = "false" }
variable "active_region" { default = "true" }
variable "stack" { }
variable "owner" { }
variable "nat_azs" { }
variable "bastion_image" { }
variable "bastion_azs" { }
variable "public_key_path" {default = "" }
