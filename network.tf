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
    Name = format("%s-vpc", var.project_name)
  }
}

resource "aws_internet_gateway" "test_original_igw" {
  vpc_id = aws_vpc.test_original_vpc.id
  tags = {
    Name = format("%s-igw", var.project_name)
  }
}

resource "aws_route_table" "test_original_isolated" {
  vpc_id = aws_vpc.test_original_vpc.id
  route {
    cidr_block = "192.168.1.0/24"
    gateway_id = aws_internet_gateway.test_original_igw.id
  }
  tags = {
    Name = format("%s-rtb", var.project_name)
  }
}

resource "aws_subnet" "test_subnet" {
  vpc_id = aws_vpc.test_original_vpc.id
  cidr_block = "192.168.129.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = format("%s-subnet", var.project_name)
  }
}

#cannot define tags
resource "aws_route_table_association" "test_subnet_assoc" {
  subnet_id = aws_subnet.test_subnet.id
  route_table_id = aws_route_table.test_original_isolated.id
}

#ingress : inbound
#egress : outbound
#no definition ingress because of isolated

resource "aws_security_group" "test_security_group" {
  name = format("%s-sg", var.project_name)
  vpc_id = aws_vpc.test_original_vpc.id
  egress { 
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
  description = format("%s-sg", var.project_name)
  tags = {
    Name = format("%s-sg", var.project_name)
  }
}
