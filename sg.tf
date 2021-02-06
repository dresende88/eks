# EC2 Security Group to allow networking traffic with EKS cluster

resource "aws_security_group" "eks_cluster" {
  name        = "eks-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.vpc_eks_lab.id

  tags = {
    Name           = "eks-cluster"
  }
}

# EC2 Security Group to allow networking traffic with EKS nodes

resource "aws_security_group" "node_sg" {
  name        = "node-sg"
  description = "Communication between the control plane and worker nodes"
  vpc_id      = aws_vpc.vpc_eks_lab.id

  tags = {
    Name           = var.cluster_name
  }

  ingress {
    from_port       = 1025
    to_port         = 65535
    protocol        = "tcp"
    description     = "Allow worker nodes to communicate with control plane (kubelet and workload TCP ports)"
    security_groups = [aws_security_group.eks_cluster.id]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    description     = "Allow worker nodes to communicate with control plane (workloads using HTTPS port, commonly used with extension API servers)"
    security_groups = [aws_security_group.eks_cluster.id]
  }

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    description     = "Allow load balancer to communicate with worker nodes"
    security_groups = [aws_security_group.ingress_sg.id, aws_security_group.ingress_private_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# EC2 Security Group to allow networking traffic with EKS nodes

resource "aws_security_group" "ingress_sg" {
  name        = "ingress-sg"
  description = "Ingress Security Group"
  vpc_id      = aws_vpc.vpc_eks_lab.id

  tags = {
    Name           = var.cluster_name
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Security Group to allow networking traffic with Private Ingress

resource "aws_security_group" "ingress_private_sg" {
  name        = "private-ingress-sg"
  description = "Private Ingress Security Group"
  vpc_id      = aws_vpc.vpc_eks_lab.id

  tags = {
    Name           = "Private Ingress SG"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc_eks_lab.cidr_block]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc_eks_lab.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

