module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.31"

  vpc_id          = var.vpc_id
  subnet_ids      = var.subnet_ids
  control_plane_subnet_ids = var.subnet_ids

  ### IRSA
  enable_irsa = var.enable_irsa
  enable_cluster_creator_admin_permissions = var.enable_cluster_creator_admin_permissions

  ### Access EKS API server
  cluster_endpoint_public_access = var.cluster_endpoint_public_access # Cho phép truy cập EKS API server qua internet
  cluster_endpoint_private_access = var.cluster_endpoint_private_access # Cho phép truy cập EKS API server từ bên trong VPC (ec2, pod) thông qua Private IP (không đi qua Internet)

  ### add on
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    eks-pod-identity-agent = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
      configuration_value = jsonencode({
        env = {
          ENABLE_PREFIX_DELEGATION = "true"
        }
      })
    }
    aws-ebs-csi-driver = {
      most_recent = true
    }
  }

  ### manager node
  eks_managed_node_groups = {
    for name, node in var.eks_managed_node_groups : name => {
      ami_type = node.ami_type
      instance_types = node.instance_types
      min_size = node.min_size 
      max_size = node.max_size 
      desired_size = node.desired_size

      iam_role_additional_policies = {
        AmazonEKSWorkerNodePolicy = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
        AmazonEC2ContainerRegistryReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
        AmazonEKS_CNI_Policy = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
        AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
      }
    }
  }

  tags = var.tags

  ### RBAC
  # access_entries = {
  #   devops_admin = {
  #     kubernetes_groups = ["main"]
  #     principal_arn     = "arn:aws:iam::2341391836724:user/AdminUser"
  #     policy_associations = {
  #       admin = {
  #         policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  #         access_scope = {
  #           type = "cluster"
  #         }
  #       }
  #     }
  #   }

  #   devops_viewer = {
  #     kubernetes_groups = ["main"]
  #     principal_arn     = "arn:aws:iam::2341391836724:user/ViewerUser"
  #     policy_associations = {
  #       view = {
  #         policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
  #         access_scope = {
  #           type       = "namespace"
  #           namespaces = ["default"]
  #         }
  #       }
  #     }
  #   }
  # }
}