variable "codebuild_image" {
  description = "image used for the build, see https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-available.html"
  default     = "aws/codebuild/nodejs:8.11.0"
}

variable "codebuild_github_repo_url" {
  description = "url to the github repo being built"
  default     = "https://github.com/jonkyops/jonkyops.git"
}
