module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "~> 2.0"

  repository_name = var.repository_name
  repository_type = "private"

  repository_lifecycle_policy = jsonencode({
    rules = [
      for rule in var.rules : (
        {
          rulePriority = rule.rulePriority
          description  = rule.description
          selection = merge(
            {
              tagStatus   = rule.selection.tagStatus
              countType   = rule.selection.countType
              countNumber = rule.selection.countNumber
            },
            rule.selection.tagPrefixList != null ? { tagPrefixList = rule.selection.tagPrefixList } : {},
            rule.selection.tagPatternList != null ? { tagPatternList = rule.selection.tagPatternList } : {}
          )
          action = {
            type = "expire"
          }
        }
      )
    ]
  })

  tags = var.tags
}
