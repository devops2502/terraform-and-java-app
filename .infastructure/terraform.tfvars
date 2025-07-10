### common
company    = "vti"
class      = "2502"
id_trainee = "DE000081"
env        = "dev"
region     = "ew1"

### network
vpc_cidr           = "10.0.0.0/16"
azs                = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets    = ["10.0.3.0/24", "10.0.4.0/24"]
enable_nat_gateway = true

### ECR repo
repository_name = "my-app-repo"
rules = [
  {
    rulePriority = 1
    description  = "Keep last 30 images"
    selection = {
      tagStatus   = "any"
      countType   = "imageCountMoreThan"
      countNumber = 30
    }
  }
]

### EKS cluster
cluster_name                             = "my-eks-cluster"
enable_irsa                              = true
enable_cluster_creator_admin_permissions = true
cluster_endpoint_public_access           = true
cluster_endpoint_private_access          = true
eks_managed_node_groups = {
  main = {
    ami_type       = "AL2_x86_64"
    instance_types = ["t3.medium"]
    min_size       = 2
    max_size       = 3
    desired_size   = 2
  }
}

### Key pair
key_name              = "key DO2502"
private_key_algorithm = "RSA"
private_key_rsa_bits  = 4096
create_private_key    = true

### Security group
sg_name        = "SG EC2 public"
sg_description = "SG for EC2 public"
ingress_with_cidr_blocks = [
  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = "0.0.0.0/0"
  },
  {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = "0.0.0.0/0"
    description = "Allow SSH"
  },
  {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = "0.0.0.0/0" 
    description = "Jenkins Web UI"
  },
  {
    from_port   = 50000
    to_port     = 50000
    protocol    = "tcp"
    cidr_blocks = "10.0.0.0/16"
    description = "Jenkins JNLP Agent"
  },
]

egress_with_cidr_blocks = [
  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = "0.0.0.0/0"
  }
]

### EC2 instance
# ec2_name       = "ec2 instance DO2502"
# ami            = "ami-0db1de538d84beea0"
# instance_type  = "t2.micro"
ec2_monitoring = true

### S3 bucket
bucket        = "s3-bucket-devops2502"
acl           = "private"
force_destroy = true

control_object_ownership = true
object_ownership         = "ObjectWriter"

versioning = {
  enabled = true
}

block_public_acls       = true
block_public_policy     = true
ignore_public_acls      = true
restrict_public_buckets = true

lifecycle_rule_s3 = [
  {
    id     = "rule_1"
    status = "Enabled"
    filter = {}
    expiration = {
      days = 30
    }
  }
]