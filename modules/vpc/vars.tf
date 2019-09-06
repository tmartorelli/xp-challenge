variable "environment" {
  description = "the name of the environment this vpc is deployed into"
  type        = "string"
  default     = "production"
}

variable "region" {
  description = "the region to deploy to"
  type        = "string"
  default     = "eu-west-1"
}
