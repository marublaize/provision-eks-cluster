variable "region" {
  default = "us-east-1"
}

variable "cluster_name" {
  default = "eks-cluster"
}

variable "cluster_version" {
  default = "1.21"
}

variable "root_volume_type" {
  default = "gp2"
}

variable "asg_desired_capacity" {
  default     = "1"
  description = "Desired number of worker nodes"
}
