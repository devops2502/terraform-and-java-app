variable "prefix_name" {
  description = "Prefix name for all resource"
  type = string
}

variable "vpc_cidr" {
  description = "VPC CIDR range"
  type        = string
}

variable "azs" {
  description = "A list of availability zones names"
  type = list(string)
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
  type = bool
  default = false
}

variable "vpc_tags" {
  description = "Additional tags for the VPC"
  type = map(string)
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type = map(string)
}