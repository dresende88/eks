variable "aws_region" {
  description = "EC2 Region for the VPC"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  default     = "172.16.0.0/16"
}

variable "cluster_name" {
  default = "lab-cluster"
  type    = string
}