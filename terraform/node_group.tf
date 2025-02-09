resource "aws_eks_node_group" "eks_nodes" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "eks-nodes"
  node_role_arn   = aws_iam_role.eks_cluster_role.arn
  subnet_ids      = data.aws_subnets.existing.ids  # Fetching subnets dynamically

  scaling_config {
    desired_size = 1
    min_size     = var.min_size
    max_size     = var.max_size
  }

  depends_on = [aws_eks_cluster.eks]
}
