variable "stack" { }
variable "owner" { }
variable "vpc_id" { }
variable "region" { }
variable "availability_zones" { }
variable "vpc_cidr" { }
variable "subnet_cidrs"  { }
variable "route_table_id"  { }
variable "eip_ids" { }

provider "aws" {
  region = "${var.region}"
}

module subnets {
  source = "../subnet"

  name               = "${var.stack}-nat"
  stack              = "${var.stack}"
  owner              = "${var.owner}"
  vpc_id             = "${var.vpc_id}"
  cidrs              = "${var.subnet_cidrs}"
  region             = "${var.region}"
  availability_zones = "${var.availability_zones}"
  route_table_ids    = "${var.route_table_id}"
  subnet_type        = "public"
}


resource "aws_nat_gateway" "nat" {
  count         = "${length(split(",", var.availability_zones))}"
  allocation_id = "${element(split(",", var.eip_ids), count.index)}"
  subnet_id     = "${element(split(",", module.subnets.subnet_ids), count.index)}"

  lifecycle { create_before_destroy = true }
}

resource "aws_route_table" "private" {
  count  = "${length(split(",", var.availability_zones))}"
  vpc_id = "${var.vpc_id}"

  lifecycle { create_before_destroy = true }

  tags {
    Name        = "${var.stack}-private"
    Stack       = "${var.stack}"
    Owner       = "${var.owner}"
  }
}

resource "aws_route" "nat-gw-route" {
  count  = "${length(split(",", var.availability_zones))}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${element(aws_nat_gateway.nat.*.id, count.index)}"

  lifecycle { create_before_destroy = true }
}


output "private_ips"             { value = "${join(",", aws_nat_gateway.nat.*.private_ip)}" }
output "public_ips"              { value = "${join(",", aws_nat_gateway.nat.*.public_ip)}" }
output "private_route_table_ids" { value = "${join(",", aws_route_table.private.*.id)}" }
