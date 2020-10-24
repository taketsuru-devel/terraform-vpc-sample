# vpc(isolated) needs...
#  route_table
#  security_group
#  subnet
# optional
#  nat gateway

#tags.Name is used to display console
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  assign_generated_ipv6_cidr_block = "false"
  instance_tenancy = "default"
  enable_dns_hostnames = "true"
  enable_dns_support = "true"
  tags = {
    Name = format("%s-vpc", var.project_name)
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = format("%s-igw", var.project_name)
  }
}

resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = var.rtb_cidr
    gateway_id = aws_internet_gateway.this.id
  }
  tags = {
    Name = format("%s-rtb", var.project_name)
  }
}

resource "aws_subnet" "this" {
  vpc_id = aws_vpc.this.id
  cidr_block = var.subnet_cidr
  availability_zone = var.subnet_az
  tags = {
    Name = format("%s-subnet", var.project_name)
  }
}

#cannot define tags
resource "aws_route_table_association" "this" {
  subnet_id = aws_subnet.this.id
  route_table_id = aws_route_table.this.id
}

#ingress : inbound
#egress : outbound
#no definition ingress because of isolated

resource "aws_security_group" "this" {
  name = format("%s-sg", var.project_name)
  vpc_id = aws_vpc.this.id
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
