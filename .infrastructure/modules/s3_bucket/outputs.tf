output "s3_bucket_id" {
  description = "The name of the S3 bucket"
  value       = module.s3_bucket.s3_bucket_id
}

output "s3_bucket_bucket_domain_name" {
  description = "The bucket domain name. Will be of format bucketname.s3.amazonaws.com."
  value       = module.s3_bucket.s3_bucket_bucket_domain_name
}

output "s3_bucket_lifecycle_configuration_rules" {
  description = "The lifecycle rules of the bucket"
  value       = module.s3_bucket.s3_bucket_lifecycle_configuration_rules
}