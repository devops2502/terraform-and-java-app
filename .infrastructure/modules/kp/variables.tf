variable "key_name" {
  description = "The name for the key pair"
  type = string
}

variable "private_key_algorithm" {
  description = "Name of the algorithm to use when generating the private key. Currently-supported values are `RSA` and `ED25519`"
  type = string
  default = "RSA"
}

variable "private_key_rsa_bits" {
  description = "When algorithm is `RSA`, the size of the generated RSA key, in bits (default: `4096`)"
  type = number
  default = 4096
}

variable "create_private_key" {
  description = "Determines whether a private key will be created"
  type = bool
  default = false
}

variable "tags" {
  description = "A map of tags to add to all resource"
  type = map(string)
}