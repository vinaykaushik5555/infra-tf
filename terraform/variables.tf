variable "region" {
  default = "us-east-1"
}

variable "cluster_name" {
  default = "my-eks-cluster"
}

variable "node_instance_type" {
  default = "t3.medium"
}

variable "min_size" {
  default = 1
}

variable "max_size" {
  default = 2
}
variable "vpc_id" {
  description = "VPC ID where EKS will be deployed"
  default     = ""
}

variable "subnet_ids" {
  description = "List of subnet IDs for EKS"
  type        = list(string)
  default     = []
}
