variable "region" {
  default     = "us-east-1"
  description = "AWS region"
}

variable "cluster_name" {
  default     = "eks-cluster"
  description = "EKS Cluster name"
}

variable "cluster_version" {
  default     = "1.21"
  description = "EKS Cluster version"
}

variable "root_volume_type" {
  default = "gp2"
}

variable "asg_desired_capacity" {
  default     = "1"
  description = "Desired number of worker nodes"
}
