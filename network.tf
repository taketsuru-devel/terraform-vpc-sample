# vpc(isolated) needs...
#  route_table
#  security_group
#  subnet
# optional
#  nat gateway

#tags.Name is used to display console
resource "aws_vpc" "test_original_vpc" {
  cidr_block = "192.168.128.0/20"
  assign_generated_ipv6_cidr_block = "false"
  instance_tenancy = "default"
  enable_dns_hostnames = "true"
  enable_dns_support = "true"
  tags = {
    Name = "terraform-vpc"
  }
}

resource "aws_internet_gateway" "test_original_igw" {
  vpc_id = "${aws_vpc.test_original_vpc.id}"
  tags = {
    Name = "terraform-igw"
  }
}

resource "aws_route_table" "test_original_isolated" {
  vpc_id = "${aws_vpc.test_original_vpc.id}"
  route {
    cidr_block = "192.168.1.0/24"
    gateway_id = "${aws_internet_gateway.test_original_igw.id}"
  }
  tags = {
    Name = "terraform-rt"
  }
}

resource "aws_subnet" "test_public_a" {
  vpc_id = "${aws_vpc.test_original_vpc.id}"
  cidr_block = "192.168.129.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = "terraform-subnet"
  }
}

#cannot define tags
resource "aws_route_table_association" "test_public_a_assoc" {
  subnet_id = "${aws_subnet.test_public_a.id}"
  route_table_id = "${aws_route_table.test_original_isolated.id}"
}

#ingress : inbound
#egress : outbound
#no definition ingress because of isolated

resource "aws_security_group" "test_security_group" {
  name = "TEST_VPC"
  vpc_id = "${aws_vpc.test_original_vpc.id}"
  egress { 
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
  description = "terraform-sg"
  tags = {
    Name = "terraform-sg"
  }
}
