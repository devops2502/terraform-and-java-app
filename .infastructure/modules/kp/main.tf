module "key-pair" {
  source  = "terraform-aws-modules/key-pair/aws"
  version = "~> 2.0"

  key_name   = var.key_name
  private_key_algorithm = var.private_key_algorithm
  private_key_rsa_bits = var.private_key_algorithm == "RSA" ? var.private_key_rsa_bits : null
  create_private_key = true

  tags = var.tags
}
