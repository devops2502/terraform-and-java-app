output "key_name" {
  description = "The name for the key pair"
  value = module.key-pair.key_pair_name
}

output "private_key_pem" {
  description = "Private key"
  value = module.key-pair.private_key_pem
}