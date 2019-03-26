variable "codebuild_project_name" {
  default = "jonkyops-build"
}

variable "codepipeline_name" {
  default = "jonkyops-pipeline"
}

variable "github_owner" {
  default = "jonkyops"
}

variable "github_repo" {
  default = "jonkyops.com"
}

variable "github_branch" {
  default = "master"
}

variable "codebuild_image" {
  description = "image used for the build, see https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-available.html"
  default     = "aws/codebuild/ruby:2.5.3"
}

variable "github_oauth_token" {
  description = "github oauth token for your repo, needed even if it's public"
}
