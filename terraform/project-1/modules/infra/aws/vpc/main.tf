variable "stack" { }
variable "owner" { }
variable "region" { }
variable "vpc_cidr" { }

provider "aws" {
  region = "${var.region}"
}

resource "aws_vpc" "main" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  lifecycle { create_before_destroy = true }

  tags {
    Name        = "${var.stack}-vpc"
    Stack        = "${var.stack}"
    Owner       = "${var.owner}"
  }
}

resource "aws_internet_gateway" "public" {
  vpc_id = "${aws_vpc.main.id}"

  lifecycle { create_before_destroy = true }

  tags {
    Name        = "${var.stack}-gateway"
    Stack       = "${var.stack}"
    Owner       = "${var.owner}"
  }
}

resource "aws_route_table" "public" {
  vpc_id       = "${aws_vpc.main.id}"

  lifecycle { create_before_destroy = true }

  tags {
    Name        = "${var.stack}-public"
    Stack       = "${var.stack}"
    Owner       = "${var.owner}"
  }
}

resource "aws_route" "igw-route" {
  route_table_id = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.public.id}"

  lifecycle { create_before_destroy = true }
}


output "vpc_id"                    { value = "${aws_vpc.main.id}" }
output "public_route_table_id"     { value = "${aws_route_table.public.id}" }
output "internet_gateway"          { value = "${aws_internet_gateway.public.id}" }
output "default_security_group_id" { value = "${aws_vpc.main.default_security_group_id}" }
