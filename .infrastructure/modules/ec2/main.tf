module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 6.0"

  name = var.ec2_name

  ami = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  monitoring             = var.ec2_monitoring
  vpc_security_group_ids = var.vpc_security_group_ids
  subnet_id              = var.subnet_id
  create_eip = var.create_eip
  user_data = var.ec2_user_data

  tags = var.tags
}