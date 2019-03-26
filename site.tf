module "pipeline" {
  source = "modules/pipeline"

  codebuild_project_name = "${var.codebuild_project_name}"
  codepipeline_name = "${var.codepipeline_name}"
  github_owner = "${var.github_owner}"
  github_repo = "${var.github_repo}"
  github_branch = "${var.github_branch}"
  codebuild_image = "${var.codebuild_image}"
  github_oauth_token = "${var.github_oauth_token}"
}

module "site" {
  source = "modules/serverless_site"

  site_domain = "${var.site_domain}"
}
