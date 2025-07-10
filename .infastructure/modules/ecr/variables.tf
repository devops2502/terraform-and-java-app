variable "repository_name" {
  description = "ECR repository name"
  type        = string
}

variable "rules" {
  description = "List of rules for ECR repository"
  type = list(object({
    rulePriority = number 
    description = string
    selection = object({
      tagStatus = string # any | tagged | untagged
      tagPrefixList = optional(list(string)) # only with "tagged" and tag_pattern_list isn't specified
      tagPatternList = optional(list(string)) # only with "tagged" and tag_prefix_list isn't specified
      countType = string  # "imageCountMoreThan" | "sinceImagePushed"
      countUnit = optional(string, "days") # only with "sinceImagePushed" (days)
      countNumber = number
    })
  }))
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type = map(string)
}