#Create VPC
resource "aws_vpc" "default" {
  cidr_block       = "192.168.0.0/19"
  instance_tenancy = "default"
}

# create IGW to allow traffic for the public subnet
resource "aws_internet_gateway" "gateway" {
  vpc_id = "${aws_vpc.default.id}"
  tags = {
    key                 = "Name"
    value               = "${var.environment}"
    propagate_at_launch = true
  }
}

resource "aws_eip" "nat_ip_1" {
  vpc = true
}

resource "aws_eip" "nat_ip_2" {
  vpc = true
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = "${aws_vpc.default.id}"
  availability_zone       = "${var.region}a"
  cidr_block              = "192.168.4.0/23"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = "${aws_vpc.default.id}"
  availability_zone       = "${var.region}b"
  cidr_block              = "192.168.6.0/23"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "dmz_subnet_1" {
  vpc_id            = "${aws_vpc.default.id}"
  availability_zone = "${var.region}a"
  cidr_block        = "192.168.0.0/23"
}

resource "aws_subnet" "dmz_subnet_2" {
  vpc_id            = "${aws_vpc.default.id}"
  availability_zone = "${var.region}b"
  cidr_block        = "192.168.2.0/23"
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = "${aws_vpc.default.id}"
  availability_zone = "${var.region}a"
  cidr_block        = "192.168.8.0/23"
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = "${aws_vpc.default.id}"
  availability_zone = "${var.region}b"
  cidr_block        = "192.168.10.0/23"
}

# create a NAT gateway for the private subnets
resource "aws_nat_gateway" "ngw_1" {
  allocation_id = "${aws_eip.nat_ip_1.id}"
  subnet_id     = "${aws_subnet.public_subnet_1.id}"
}

resource "aws_nat_gateway" "ngw_2" {
  allocation_id = "${aws_eip.nat_ip_2.id}"
  subnet_id     = "${aws_subnet.public_subnet_2.id}"
}


resource "aws_route_table" "vpc_route" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gateway.id}"
  }
}


# create the route table entry to use the IGW as default route

resource "aws_route_table" "dmz_route_table" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gateway.id}"
  }
}

resource "aws_route_table_association" "dmz_route_association_1" {
  subnet_id      = "${aws_subnet.dmz_subnet_1.id}"
  route_table_id = "${aws_route_table.dmz_route_table.id}"
}

resource "aws_route_table_association" "dmz_route_association_2" {
  subnet_id      = "${aws_subnet.dmz_subnet_2.id}"
  route_table_id = "${aws_route_table.dmz_route_table.id}"
}

# create the route table entry to use the IGW as default route
resource "aws_route_table" "public_route_table" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gateway.id}"

  }
}



resource "aws_route_table_association" "public_route_association_1" {
  subnet_id      = "${aws_subnet.public_subnet_1.id}"
  route_table_id = "${aws_route_table.public_route_table.id}"
}

resource "aws_route_table_association" "public_route_association_2" {
  subnet_id      = "${aws_subnet.public_subnet_2.id}"
  route_table_id = "${aws_route_table.public_route_table.id}"
}


#create a route to allow private instances to reach the internet via the NAT GW
resource "aws_route_table" "private_route_table_1" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.ngw_1.id}"

  }
}

resource "aws_route_table_association" "private_route_association1" {
  subnet_id      = "${aws_subnet.private_subnet_1.id}"
  route_table_id = "${aws_route_table.private_route_table_1.id}"
}

resource "aws_route_table" "private_route_table_2" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.ngw_2.id}"

  }
}

resource "aws_route_table_association" "private_route_association2" {
  subnet_id      = "${aws_subnet.private_subnet_2.id}"
  route_table_id = "${aws_route_table.private_route_table_2.id}"
}
