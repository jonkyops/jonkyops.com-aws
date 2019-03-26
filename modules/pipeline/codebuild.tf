# code build project, triggers and all that are going to be in the pipeline resource
resource "aws_codebuild_project" "build" {
  name         = "${var.codebuild_project_name}"
  description  = "${var.github_repo} project"
  service_role = "${aws_iam_role.build.arn}"

  artifacts {
    type     = "CODEPIPELINE"
    location = "CODEPIPELINE"
  }

  source {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "${var.codebuild_image}"
    type         = "LINUX_CONTAINER"
  }
}
