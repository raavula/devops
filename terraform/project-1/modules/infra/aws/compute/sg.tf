#
# Security group for Bastion
#
resource "aws_security_group" "sg" {
  name = "${var.stack}-bastion"
  description = "Bastion security group"
  vpc_id = "${var.vpc_id}"

  lifecycle { create_before_destroy = true }

  ingress { # SSH
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${split(",", var.ssh_ingress_cidrs)}"]
  }
  egress { # SSH
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${split(",", var.ssh_egress_cidrs)}"]
  }
  tags {
    Name        = "${var.stack}-bastion"
    Stack       = "${var.stack}"
    Owner       = "${var.owner}"
  }
}
