output "ec2_public_ip" {
  description = "The public IP address assigned to the instance"
  value = module.ec2-instance.public_ip
}