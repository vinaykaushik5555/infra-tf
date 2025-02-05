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
