resource "aws_vpn_gateway" "vpn_gateway" {
  vpc_id = aws_vpc.vpc_eks_lab.id

  tags = {
    Name = "VPG-LAB"
  }
}

resource "aws_customer_gateway" "lab" {
  bgp_asn    = 65000
  ip_address = "0.0.0.0"
  type       = "ipsec.1"

  tags = {
    Name = "lab-customer-gateway"
  }
}

resource "aws_vpn_connection" "lab" {
  vpn_gateway_id      = aws_vpn_gateway.vpn_gateway.id
  customer_gateway_id = aws_customer_gateway.lab.id
  type                = "ipsec.1"
  static_routes_only  = true

  tags = {
    Name = "LAB-VPN"
  }
}

resource "aws_vpn_connection_route" "matriz" {
  destination_cidr_block = "0.0.0.0/0"
  vpn_connection_id      = aws_vpn_connection.lab.id
}