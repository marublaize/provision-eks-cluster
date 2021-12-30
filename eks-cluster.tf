module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = local.cluster_name
  cluster_version = var.cluster_version
  subnets         = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  workers_group_defaults = {
    root_volume_type = var.root_volume_type
  }

  worker_groups = [
    {
      name                 = "worker-group"
      instance_type        = "t2.small"
      asg_desired_capacity = var.asg_desired_capacity
      # additional_userdata           = "echo foo bar"
    },
  ]
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}