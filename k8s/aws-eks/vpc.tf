#
# VPC Resources
#  * VPC
#  * Subnets
#  * Internet Gateway
#  * Route Table
#

resource "aws_vpc" "sse" {
  cidr_block = "10.0.0.0/16"

  tags = "${
    map(
     "Name", "terraform-eks-sse-node",
     "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}

resource "aws_subnet" "sse" {
  count = 2

  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        = "10.0.${count.index}.0/24"
  vpc_id            = "${aws_vpc.sse.id}"

  tags = "${
    map(
     "Name", "terraform-eks-sse-node",
     "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}

resource "aws_internet_gateway" "sse" {
  vpc_id = "${aws_vpc.sse.id}"

  tags {
    Name = "terraform-eks-sse"
  }
}

resource "aws_route_table" "sse" {
  vpc_id = "${aws_vpc.sse.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.sse.id}"
  }
}

resource "aws_route_table_association" "sse" {
  count = 2

  subnet_id      = "${aws_subnet.sse.*.id[count.index]}"
  route_table_id = "${aws_route_table.sse.id}"
}
