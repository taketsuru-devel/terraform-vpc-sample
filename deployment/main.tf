terraform {
  backend "s3" {
    bucket = "terraform-tfstate-s3"
    region = "ap-northeast-1"
    key = "vpc-sample"
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

module "module_vpc" {
  source = "../module/"

  project_name = "vpc-sample"
  vpc_cidr = "10.0.16.0/20"
  rtb_cidr = "10.0.48.0/20"
  subnet_cidr = "10.0.17.0/24"
  subnet_az = "ap-northeast-1a"
}
