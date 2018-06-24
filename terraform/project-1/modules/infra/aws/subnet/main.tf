variable "name" { }
variable "stack" { }
variable "owner" { }

variable "region" { }
variable "availability_zones" { }
variable "vpc_id" { }
variable "cidrs" { }
variable "route_table_ids" { }
variable "subnet_type" { default = "private" }

variable "public_ip_required" {
  default = {
    "private" = false
    "public" = true
  }
}


provider "aws" {
  region = "${var.region}"
}

resource "aws_subnet" "nets" {
  count             = "${length(split(",", var.cidrs))}"
  vpc_id            = "${var.vpc_id}"
  cidr_block        = "${element(split(",", var.cidrs), count.index)}"
  availability_zone = "${element(split(",", var.availability_zones), count.index)}"
  map_public_ip_on_launch = "${lookup(var.public_ip_required, var.subnet_type)}"

  lifecycle { create_before_destroy = true }

  tags {
    Name        = "${var.name}-${element(split(",", var.availability_zones), count.index)}-${var.subnet_type}"
    Stack       = "${var.stack}"
    Owner       = "${var.owner}"
  }
}

resource "aws_route_table_association" "rta" {
  count          = "${length(split(",", var.cidrs))}"
  subnet_id      = "${element(aws_subnet.nets.*.id, count.index)}"
  route_table_id = "${element(split(",", var.route_table_ids), count.index)}"

  lifecycle { create_before_destroy = true }
}


output "subnet_ids" { value = "${join(",", aws_subnet.nets.*.id)}" }
