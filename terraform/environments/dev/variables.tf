variable "aws_region" {
  type        = string
  description = "AWS region for deployment."
}

variable "image_tag" {
  type        = string
  description = "Container image tag from GitVersion."
  default     = "latest"
}

variable "project_name" {
  type        = string
  description = "Project naming prefix."
  default     = "hospital-mgmt"
}
