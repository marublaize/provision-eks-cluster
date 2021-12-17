module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = local.cluster_name
  cluster_version = var.cluster_version
  subnets         = module.vpc.private_subnets

  tags = {
    Environment = "continuous-integration"
    GithubRepo  = "terraform-aws-eks"
    GithubOrg   = "terraform-aws-modules"
  }

  vpc_id = module.vpc.vpc_id

  workers_group_defaults = {
    root_volume_type = var.root_volume_type
  }

  worker_groups = [
    # {
    #   name                          = "worker-group-1"
    #   instance_type                 = "t2.small"
    #   asg_desired_capacity          = 1
    #   # additional_userdata           = "echo foo bar"
    #   # additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
    # },
    # {
    #   name                          = "worker-group-2"
    #   instance_type                 = "t2.small"
    #   asg_desired_capacity          = 1
    #   # additional_userdata           = "echo foo bar"
    #   # additional_security_group_ids = [aws_security_group.worker_group_mgmt_two.id]
    # },
    # {
    #   name                          = "worker-group-3"
    #   instance_type                 = "t2.small"
    #   asg_desired_capacity          = 1
    #   # additional_userdata           = "echo foo bar"
    #   # additional_security_group_ids = [aws_security_group.worker_group_mgmt_three.id]
    # },
    {
      name                 = "worker-group"
      instance_type        = "t2.small"
      asg_desired_capacity = var.asg_desired_capacity
    },
  ]
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
