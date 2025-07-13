variable "bucket" {
  description = "Name of s3 bucket"
  type = string
}

variable "acl" {
  description = "The canned ACL to apply. Conflicts with 'grant'"
  type = string
}

variable "force_destroy" {
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error"
  type = bool
}

variable "control_object_ownership" {
  description = "Whether to manage S3 Bucket Ownership Controls on this bucket."
  type = string
}

variable "object_ownership" {
  description = "Object ownership. Valid values: BucketOwnerEnforced, BucketOwnerPreferred or ObjectWriter. 'BucketOwnerEnforced': ACLs are disabled, and the bucket owner automatically owns and has full control over every object in the bucket. 'BucketOwnerPreferred': Objects uploaded to the bucket change ownership to the bucket owner if the objects are uploaded with the bucket-owner-full-control canned ACL. 'ObjectWriter': The uploading account will own the object if the object is uploaded with the bucket-owner-full-control canned ACL."
  type        = string
  default     = "ObjectWriter"

  validation {
    condition     = contains(["ObjectWriter", "BucketOwnerPreferred", "BucketOwnerEnforced"], var.object_ownership)
    error_message = "Object_ownership must be one of: ObjectWriter, BucketOwnerPreferred, BucketOwnerEnforced"
  }
}

variable "versioning" {
  description = "Map containing versioning configuration."
  type = map(string)
}

variable "block_public_acls" {
  description = "Whether Amazon S3 should block public ACLs for this bucket."
  type = bool
}

variable "block_public_policy" {
  description = "	Whether Amazon S3 should block public bucket policies for this bucket."
  type = bool
}

variable "ignore_public_acls" {
  description = "Whether Amazon S3 should ignore public ACLs for this bucket."
  type = bool
}

variable "restrict_public_buckets" {
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket."
  type = bool
}

variable "lifecycle_rule_s3" {
  description = "List of maps containing configuration of object lifecycle management."
  type = list(object({
    id     = string
    status = string
    filter = optional(object({
      prefix = optional(string)
    }))
    expiration = optional(object({
      days = optional(number)
    }))
  }))
}

variable "tags" {
  description = "A mapping of tags to assign to the bucket"
  type = map(string)
}