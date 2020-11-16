
terraform {
  backend "s3" {
    bucket = "mybucket"
    key    = "path"
    region = "us-east-1"
  }
}


provider "aws" {
  region = var.aws_region
}

locals {
  workstation-external-cidr = "${chomp(data.http.workstation-external-ip.body)}/32"
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "http" "workstation-external-ip" {
  url = "http://ipv4.icanhazip.com"
}




