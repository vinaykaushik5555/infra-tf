resource "aws_eks_node_group" "eks_nodes" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "eks-nodes"
  node_role_arn   = aws_iam_role.eks_cluster_role.arn
  subnet_ids      = [aws_subnet.eks_subnet_1.id, aws_subnet.eks_subnet_2.id]
  instance_types  = [var.node_instance_type]

  scaling_config {
    desired_size = 1
    min_size     = var.min_size
    max_size     = var.max_size
  }
}
