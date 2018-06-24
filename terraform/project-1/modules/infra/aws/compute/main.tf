variable "stack" { }
variable "owner" { }
variable "account" { }
variable "region" { }
variable "availability_zones" { }
variable "vpc_id" { }
variable "image" { }
variable "flavor" { }
variable "subnet_cidrs" { }
variable "route_table_id" { }
variable "vpc_cidr" { }
variable "ssh_ingress_cidrs" { }
variable "ssh_egress_cidrs" { }
variable "default_sg_ids" { default = "" }
variable "iam_instance_profile" { }
variable "public_key_path" { }

provider "aws" {
  region = "${var.region}"
}

module subnets {
  source = "../subnet"

  name               = "${var.stack}-bastion"
  stack              = "${var.stack}"
  owner              = "${var.owner}"
  vpc_id             = "${var.vpc_id}"
  cidrs              = "${var.subnet_cidrs}"
  region             = "${var.region}"
  availability_zones = "${var.availability_zones}"
  route_table_ids    = "${var.route_table_id}"
  subnet_type        = "public"
}

data "template_file" "userdata" {
  template = "${file("${path.module}/userdata.sh.tpl")}"

  vars {
    region            = "${var.region}"
    stack             = "${var.stack}"
    account           = "${var.account}"
  }
}

resource "aws_key_pair" "auth" {
  key_name   = "${var.stack}-key"
  public_key = "${file(var.public_key_path)}"
}

resource "aws_instance" "nodes" {
  count                  = 1
  ami                    = "${var.image}"
  instance_type          = "${var.flavor}"
  availability_zone      = "${element(split(",",var.availability_zones),count.index)}"
  vpc_security_group_ids = ["${split(",", replace("${aws_security_group.sg.id},${var.default_sg_ids}", "/,$/", ""))}"]
  subnet_id              = "${element(split(",", module.subnets.subnet_ids), count.index)}"
  associate_public_ip_address = true
  iam_instance_profile   = "${var.iam_instance_profile}"
  key_name               = "${aws_key_pair.auth.id}"

  root_block_device {
    volume_type           = "gp2"
    delete_on_termination = true
  }

  user_data = "${data.template_file.userdata.rendered}"

  lifecycle { create_before_destroy = true }

  tags {
    Name        = "${var.stack}-bastion-${format("%02d", count.index+1)}"
    Stack       = "${var.stack}"
    App         = "bastion"
    Owner       = "${var.owner}"
  }
}


output "user"        { value = "centos" }
output "instance_id" { value = "${aws_instance.nodes.id}" }
output "private_ip"  { value = "${aws_instance.nodes.private_ip}" }
output "public_ip"   { value = "${aws_instance.nodes.public_ip}" }
