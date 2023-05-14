variable "env_prefix" {
  description = "Env Prefix"
  type        = string
}

variable "region" {
  description = "Region"
  type        = string
}

variable "codestar_connection_arn" {
  description = "Codestar Connection Arn"
  type        = string
}

variable "github_organization"  {
  description = "Github Organization Name"
  type        = string
}
variable "github_repository" {
  description = "Github Repository Name"
  type        = string
}

variable "github_branch" {
  description = "Github Branch Name"
  type        = string
}

variable "codepipeline_artifacts_bucket" {
  description = "Codepipeline Artifacts Bucket Name"
  type        = string
}

variable "tf_command" {
  description = "Codepipeline command for build stage"
  type        = string
}