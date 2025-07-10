variable "sg_name" {
  description = "Name of security group"
  type = string
}

variable "sg_description" {
  description = "Description of security group"
  type = string
}

variable "vpc_id" {
  description = "ID of the VPC where to create security group"
  type = string
}

variable "ingress_with_cidr_blocks" {
  description = "List of ingress rules to create where 'cidr_blocks' is used"
  type = list(map(string))
}

variable "egress_with_cidr_blocks" {
  description = "List of ingress rules to create where 'cidr_blocks' is used"
  type = list(map(string))
}

variable "tags" {
  description = "A mapping of tags to assign to security group"
  type = map(string)
}