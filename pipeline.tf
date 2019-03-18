data "aws_ssm_parameter" "github_token" {
  name = "GitHubOath"
}

resource "aws_codebuild_project" "build" {
  name         = "jonkyops"
  description  = "jonkyops.com project"
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

resource "aws_codepipeline" "site" {
  name     = "${var.site_domain}-pipeline"
  role_arn = "${aws_iam_role.pipeline.arn}"

  artifact_store {
    location = "${aws_s3_bucket.artifacts.bucket}"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["artifacts"]

      configuration = {
        Owner      = "${var.codebuild_owner}"
        Repo       = "${var.codebuild_repo}"
        Branch     = "master"
        OAuthToken = "${data.aws_ssm_parameter.github_token.value}"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["artifacts"]
      version         = "1"

      configuration = {
        ProjectName = "jonkyops"
      }
    }
  }
}
