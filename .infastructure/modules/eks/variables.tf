variable "cluster_name" {
  description = "Name of the EKS cluster"
  type = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs where the nodes/node groups will be provisioned"
  type = list(string)
}

variable "enable_irsa" {
  description = "Determines enable IRSA"
  type = bool
}

variable "enable_cluster_creator_admin_permissions" {
  description = "Indicates whether or not to add the cluster creator (the identity used by Terraform) as an administrator via access entry"
  type = bool
}

variable "cluster_endpoint_public_access" {
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled"
  type = bool
  default = false
}

variable "cluster_endpoint_private_access" {
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled"
  type = bool
  default = true
}

variable "eks_managed_node_groups" {
  description = "Map of EKS managed node group definitions to create"
  type = map(object({
    ami_type = string
    instance_types = list(string)
    min_size = number 
    max_size = number 
    desired_size = number
  }))
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type = map(string)
}