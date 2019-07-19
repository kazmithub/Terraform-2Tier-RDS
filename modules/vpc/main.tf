resource "aws_vpc" "MyVPC" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  tags = {
    key = "Name"
    value = "${var.namePrefix}-vpc"
  }
}

resource "aws_eip" "MyEIP" {
  vpc = true
}

resource "aws_internet_gateway" "MyInternetGateway" {
  vpc_id = "${aws_vpc.MyVPC.id}"
}

resource "aws_subnet" "public" {
  vpc_id = "${aws_vpc.MyVPC.id}"
  count = 2
  cidr_block = "11.1.${count.index}.0/24"
  map_public_ip_on_launch = true
  availability_zone = "${var.awsRegion}${element(split(",", var.subnetAZs), count.index)}"
  tags = {
    key = "Name"
    value = "${var.namePrefix}-webServer-subnet"
    }
}

resource "aws_subnet" "private" {
  vpc_id = "${aws_vpc.MyVPC.id}"
  count = 2
  cidr_block = "11.1.${count.index+64}.0/24"
  map_public_ip_on_launch = true
  availability_zone = "${var.awsRegion}${element(split(",", var.subnetAZs), count.index)}"
  tags = {
    key = "Name"
    value = "${var.namePrefix}-subnet"
  } 
} 



resource "aws_db_subnet_group" "PrivateSubnetGroup" {
  name       = "privatesubnetgroup"
  subnet_ids =["${aws_subnet.private.0.id}", "${aws_subnet.private.1.id}"]
  # subnet_ids = ["${join(",", aws_subnet.private.*.id)}"]
  # subnet_ids = ["${aws_subnet.private.0.id},${aws_subnet.private.1.id}"]
  # subnet_ids = ["${element(aws_subnet.private.*.id,0)},${element(aws_subnet.private.*.id,1)}"]
  # "${element(aws_subnet.private.[count.index.id), count.index}"
  tags = {
    key = "name"
    value = "${var.namePrefix}-subnet-group"
  }
}

resource "aws_route_table" "MyInternetRouteOutTable" {
  vpc_id = "${aws_vpc.MyVPC.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.MyInternetGateway.id}"
  }
  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = "${aws_internet_gateway.MyInternetGateway.id}"
  }
  tags = {
    Name = "${var.namePrefix}-public"
  }


}

resource "aws_route_table_association" "MySubnetRouteTableAssociation" {
  count = 2
  subnet_id      = "${aws_subnet.public[count.index].id}"
  route_table_id = "${aws_route_table.MyInternetRouteOutTable.id}"
}


resource "aws_route_table" "MyPrivateRouteTable" {
  vpc_id = "${aws_vpc.MyVPC.id}"
  tags = {
    Name = "${var.namePrefix}-private"
  }
}

resource "aws_route_table_association" "MyPrivateSubnetRouteTableAssociation" {
  count = 2
  subnet_id      = "${aws_subnet.private[count.index].id}"
  route_table_id = "${aws_route_table.MyPrivateRouteTable.id}"
}

resource "aws_security_group" "MyPublicSG" {

  name        = "Public SG"
  description = "Allow inbound traffic at 80 and 22"
  vpc_id      = "${aws_vpc.MyVPC.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.namePrefix}-public"
  }
}

resource "aws_security_group" "MyDBSecurityGroup" {

  name        = "Public Security Group"
  description = "Allow inbound traffic at 3306 from public instance"
  vpc_id      = "${aws_vpc.MyVPC.id}"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  tags = {
    Name = "${var.namePrefix}-dbSg"
  }
}

resource "aws_security_group" "elb_sg" {
  name = "web-elb-sg"
  vpc_id      = "${aws_vpc.MyVPC.id}"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["11.0.0.0/16"]
  }
  tags = {
    Name = "${var.namePrefix}-lbSg"
  }
}

# resource "aws_nat_gateway" "MyNatGateway" {
#   allocation_id = "${aws_eip.MyEIP.id}"
#   subnet_id     = "${aws_subnet.PublicSubnet.id}"
#   tags = {
#     Name = "${var.namePrefix}-natGw"
#   }
# }