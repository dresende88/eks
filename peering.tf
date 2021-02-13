resource "aws_vpc_peering_connection" "peering_lab" {
  peer_owner_id = "00000000"
  peer_region   = "us-east-1"
  peer_vpc_id   = "vpc-00000000"
  vpc_id        = aws_vpc.vpc_eks_lab.id

  tags = {
    Name           = "VPC Peering lab cluster and default vpc"
  }
}