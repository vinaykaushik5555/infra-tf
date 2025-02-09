# IAM Role for EKS Cluster
resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })
}

# Attach necessary EKS policy to IAM Role
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

# Fetch existing VPC details
data "aws_vpc" "existing" {
  id = var.vpc_id
}

# Fetch existing Subnets from the VPC
data "aws_subnets" "existing" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

# Fetch detailed subnet information
data "aws_subnet" "subnet_details" {
  for_each = toset(data.aws_subnets.existing.ids)
  id       = each.value
}

# EKS Cluster Creation using existing VPC and Subnets
resource "aws_eks_cluster" "eks" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = data.aws_subnets.existing.ids
  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy]
}
