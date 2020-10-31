variable "project_name" {
  description = "to name of resource"
}

variable "vpc_cidr" {
  description = "cidr of vpc, ex: 10.0.0.0/20"
}

variable "cidr_of_rtb_to_igw" {
  description = "cidr of access dest on rtb to igw , almost 0.0.0.0/0"
  default = "0.0.0.0/0"
}

variable "subnet_setting" {
  description = "cidr and az on subnet"
  type = list(object({
    az_name = string
    cidr    = string
  })) 
}

variable "public_ip_for_ec2" {
  description = "attach public ip to ec2 when they are launched"
  type = bool
  default = false
}
