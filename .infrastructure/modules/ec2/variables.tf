variable "ec2_name" {
  description = "Name to be used on EC2 instance created"
  type = string
}

variable "ami" {
  description = "ID of AMI to use for the instance"
  type = string
}

variable "instance_type" {
  description = "	The type of instance to start"
  type = string
}

variable "key_name" {
  description = "Key name of the Key Pair to use for the instance"
  type = string
}

variable "ec2_monitoring" {
  description = "Enable monitoring for the launched EC2 instance"
  type = bool
  default = null
}

variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate with"
  type = list(string)
}

variable "subnet_id" {
  description = "The VPC Subnet ID to launch in"
  type = string
}

variable "ec2_user_data" {
  description = "The user data to provide when launching the instance"
  type = string
  default     = null
}

variable "create_eip" {
  description = "Determines whether a public EIP will be created and associated with the instance."
  type = bool
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type = map(string)
}
