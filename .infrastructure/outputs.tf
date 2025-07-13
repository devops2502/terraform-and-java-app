# ### Network
output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subnets" {
  value = module.network.public_subnets
}

output "private_subnets" {
  value = module.network.private_subnets
}

# ### ECR repo
# output "ecr_url" {
#   value = module.ecr_repo.repository_url
# }

# ### EKS cluster
# output "eks_name" {
#   value = module.eks_cluster.cluster_name
# }

# ## EC2 instance
output "ip_jenkins_server" {
  value = module.ec2_jenkins_server.ec2_public_ip
}

output "ip_jenkins_agent" {
  value = module.ec2_jenkins_agent.ec2_public_ip
}

### S3 bucket
# output "s3_bucket_name" {
#   value = module.s3_bucket.s3_bucket_id
# }

# output "s3_bucket_domain_name" {
#   value = module.s3_bucket.s3_bucket_bucket_domain_name
# }

# output "s3_bucket_lifecycle_configuration_rules" {
#   value = module.s3_bucket.s3_bucket_lifecycle_configuration_rules
# }