### common
variable "company" {
  description = "Name of company"
  type        = string
}

variable "class" {
  description = "Name of class"
  type        = string
}

variable "id_trainee" {
  description = "Id of trainee"
  type        = string
  default     = "DE000081"
}

variable "env" {
  description = "Environment (such as: dev, staging, prod)"
  type        = string
}

variable "region" {
  description = "Code of Region"
  type        = string
}

### network
variable "vpc_cidr" {
  description = "VPC CIDR range"
  type        = string
}

variable "azs" {
  description = "A list of availability zones names"
  type        = list(string)
}

variable "public_subnets" {
  description = "Public subnet CIDRs"
  type        = list(string)
}

variable "private_subnets" {
  description = "Private subnet CIDRs"
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Want to provision NAT Gateways for each of your private networks"
  type        = bool
  default     = false
}

### ECR repo
variable "repository_name" {
  description = "ECR repository name"
  type        = string
}

variable "rules" {
  description = "List of rules for ECR repository"
  type = list(object({
    rulePriority = number
    description  = string
    selection = object({
      tagStatus      = string
      tagPrefixList  = optional(list(string))
      tagPatternList = optional(list(string))
      countType      = string
      countUnit      = optional(string, "days")
      countNumber    = number
    })
  }))
}

# EKS cluster
variable "cluster_name" {
  type = string
}

variable "enable_irsa" {
  description = "Determines enable IRSA"
  type        = bool
}

variable "enable_cluster_creator_admin_permissions" {
  description = "Indicates whether or not to add the cluster creator (the identity used by Terraform) as an administrator via access entry"
  type        = bool
}

variable "cluster_endpoint_public_access" {
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled"
  type        = bool
  default     = false
}

variable "cluster_endpoint_private_access" {
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled"
  type        = bool
  default     = true
}

variable "eks_managed_node_groups" {
  description = "Map of EKS managed node group definitions to create"
  type = map(object({
    ami_type       = string
    instance_types = list(string)
    min_size       = number
    max_size       = number
    desired_size   = number
  }))
}

### Key pair
variable "key_name" {
  description = "The name for the key pair"
  type        = string
}

variable "private_key_algorithm" {
  description = "Name of the algorithm to use when generating the private key. Currently-supported values are `RSA` and `ED25519`"
  type        = string
  default     = "RSA"
}

variable "private_key_rsa_bits" {
  description = "When algorithm is `RSA`, the size of the generated RSA key, in bits (default: `4096`)"
  type        = number
  default     = 4096
}

variable "create_private_key" {
  description = "Determines whether a private key will be created"
  type        = bool
  default     = false
}

### Security group
variable "sg_name" {
  description = "Name of security group"
  type        = string
}

variable "sg_description" {
  description = "Description of security group"
  type        = string
}

variable "ingress_with_cidr_blocks" {
  description = "List of ingress rules to create where 'cidr_blocks' is used"
  type        = list(map(string))
}

variable "egress_with_cidr_blocks" {
  description = "List of ingress rules to create where 'cidr_blocks' is used"
  type        = list(map(string))
}

### EC2 instance
# variable "ec2_name" {
#   description = "Name to be used on EC2 instance created"
#   type        = string
# }

# variable "ami" {
#   description = "ID of AMI to use for the instance"
#   type        = string
# }

# variable "instance_type" {
#   description = "	The type of instance to start"
#   type        = string
# }

variable "ec2_monitoring" {
  description = "Enable monitoring for the launched EC2 instance"
  type        = bool
  default     = null
}

variable "ec2_user_data" {
  description = "The user data to provide when launching the instance"
  type        = string
  default     = null
}

# variable "create_eip" {
#   description = "Determines whether a public EIP will be created and associated with the instance."
#   type = bool
# }

### S3 bucket
variable "bucket" {
  description = "Name of s3 bucket"
  type        = string
}

variable "acl" {
  description = "The canned ACL to apply. Conflicts with 'grant'"
  type        = string
}

variable "force_destroy" {
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error"
  type        = bool
}

variable "control_object_ownership" {
  description = "Whether to manage S3 Bucket Ownership Controls on this bucket."
  type        = string
}

variable "object_ownership" {
  description = "Object ownership. Valid values: BucketOwnerEnforced, BucketOwnerPreferred or ObjectWriter. 'BucketOwnerEnforced': ACLs are disabled, and the bucket owner automatically owns and has full control over every object in the bucket. 'BucketOwnerPreferred': Objects uploaded to the bucket change ownership to the bucket owner if the objects are uploaded with the bucket-owner-full-control canned ACL. 'ObjectWriter': The uploading account will own the object if the object is uploaded with the bucket-owner-full-control canned ACL."
  type        = string
  default     = "ObjectWriter"

  validation {
    condition     = contains(["ObjectWriter", "BucketOwnerPreferred", "BucketOwnerEnforced"], var.object_ownership)
    error_message = "Object_ownership must be one of: ObjectWriter, BucketOwnerPreferred, BucketOwnerEnforced"
  }
}

variable "versioning" {
  description = "Map containing versioning configuration."
  type        = map(string)
}

variable "block_public_acls" {
  description = "Whether Amazon S3 should block public ACLs for this bucket."
  type        = bool
}

variable "block_public_policy" {
  description = "	Whether Amazon S3 should block public bucket policies for this bucket."
  type        = bool
}

variable "ignore_public_acls" {
  description = "Whether Amazon S3 should ignore public ACLs for this bucket."
  type        = bool
}

variable "restrict_public_buckets" {
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket."
  type        = bool
}

variable "lifecycle_rule_s3" {
  description = "List of maps containing configuration of object lifecycle management."
  type = list(object({
    id     = string
    status = string
    filter = optional(object({
      prefix = optional(string)
    }))
    expiration = optional(object({
      days = optional(number)
    }))
  }))
}


