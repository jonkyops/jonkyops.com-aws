variable "site_domain" {
  description = "site url"
  default     = "jonkyops.com"
}

variable "codebuild_owner" {
  default = "jonkyops"
}

variable "codebuild_repo" {
  default = "jonkyops.com"
}

variable "codebuild_image" {
  description = "image used for the build, see https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-available.html"
  default     = "aws/codebuild/ruby:2.5.3"
}

variable "codebuild_github_repo_url" {
  description = "url to the github repo being built"
  default     = "https://github.com/jonkyops/jonkyops.git"
}
