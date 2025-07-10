module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 5.0"

  bucket = var.bucket
  acl    = var.acl # Chỉ tài khoản tạo bucket (owner) có quyền FULL_CONTROL.
  force_destroy = var.force_destroy # Cho phép xóa bucket ngay cả khi nó đang chứa object (Cẩn thận dùng trong production, nên sd trong dev/test)

  control_object_ownership = var.control_object_ownership
  object_ownership         = var.object_ownership # (nếu chọn giá trị BucketOwnerEnforced thì ACL bị vô hiệu hóa)

  versioning = var.versioning

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets

  lifecycle_rule = var.lifecycle_rule_s3

  tags = var.tags
}

# s3 bucket chứa object
# acl là quyền truy cập
# object_ownership là quyền sở hữu thực tế của object

# => nên bật block_public_access
# giúp ngăn dữ liệu trong S3 bị public ra Internet, dù do ACL hay bucket policy.
# trừ khi thực sự cần public dữ liệu qua Internet (vd Host website tĩnh: public file HTML/CSS/JS cho Internet truy cập)