locals {
  tags = {
    id_trainee = var.id_trainee
    env        = var.env
  }

  prefix_name = "${var.company}-${var.class}-${var.id_trainee}-${var.env}"
}

module "network" {
  source = "./modules/networking"

  prefix_name = local.prefix_name
  vpc_cidr    = var.vpc_cidr
  azs         = var.azs

  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  enable_nat_gateway = var.enable_nat_gateway

  vpc_tags = merge(local.tags, {
    Name = "${local.prefix_name}-vpc-${var.region}"
  })
  tags = local.tags
}

# module "ecr_repo" {
#   source = "./modules/ecr"

#   repository_name = var.repository_name
#   rules           = var.rules
#   tags            = local.tags
# }

# module "eks_cluster" {
#   source = "./modules/eks"

#   cluster_name = var.cluster_name

#   vpc_id     = module.network.vpc_id
#   subnet_ids = module.network.private_subnets

#   enable_irsa                              = var.enable_irsa
#   enable_cluster_creator_admin_permissions = var.enable_cluster_creator_admin_permissions

#   cluster_endpoint_public_access  = var.cluster_endpoint_public_access
#   cluster_endpoint_private_access = var.cluster_endpoint_private_access

#   eks_managed_node_groups = var.eks_managed_node_groups

#   tags = local.tags
# }

module "kp" {
  source = "./modules/kp"

  key_name              = var.key_name
  private_key_algorithm = var.private_key_algorithm
  private_key_rsa_bits  = var.private_key_rsa_bits
  create_private_key    = var.create_private_key

  tags = merge(local.tags, {
    Name = "${local.prefix_name}-kp"
  })
}

resource "local_sensitive_file" "private_key_public_ec2" {
  content         = module.kp.private_key_pem
  filename        = "${path.module}/key_private/private_key_public_ec2.pem"
  file_permission = "400"
}

module "sg" {
  source = "./modules/sg"

  sg_name        = var.sg_name
  sg_description = var.sg_description
  vpc_id         = module.network.vpc_id

  ingress_with_cidr_blocks = var.ingress_with_cidr_blocks
  egress_with_cidr_blocks  = var.egress_with_cidr_blocks

  tags = merge(local.tags, {
    Name = "${local.prefix_name}-sg"
  })
}

module "ec2_jenkins_server" {
  source = "./modules/ec2"

  ec2_name               = "jenkins-server"
  ami                    = "ami-01f23391a59163da9"
  instance_type          = "t3.medium"
  key_name               = module.kp.key_name
  ec2_monitoring         = var.ec2_monitoring
  vpc_security_group_ids = [module.sg.sg_id]
  subnet_id              = module.network.public_subnets[0]
  ec2_user_data          = file("${path.module}/tools/jenkins_install.sh")

  tags = merge(local.tags, {
    Name = "${local.prefix_name}-ec2-jenkins-server"
  })
}

module "ec2_jenkins_agent" {
  source = "./modules/ec2"

  ec2_name               = "jenkins-agent"
  ami                    = "ami-01f23391a59163da9"
  instance_type          = "t3.medium"
  key_name               = module.kp.key_name
  ec2_monitoring         = var.ec2_monitoring
  vpc_security_group_ids = [module.sg.sg_id]
  subnet_id              = module.network.public_subnets[1]

  tags = merge(local.tags, {
    Name = "${local.prefix_name}-ec2-jenkins-agent"
  })
}

module "s3_bucket" {
  source = "./modules/s3_bucket"

  bucket        = var.bucket
  acl           = var.acl
  force_destroy = var.force_destroy

  control_object_ownership = var.control_object_ownership
  object_ownership         = var.object_ownership

  versioning = var.versioning

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets

  lifecycle_rule_s3 = var.lifecycle_rule_s3

  tags = merge(local.tags, {
    Name = "${local.prefix_name}-my-s3-bucket"
  })
}
