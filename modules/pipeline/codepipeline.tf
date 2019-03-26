# pipeline
resource "aws_codepipeline" "pipeline" {
  name     = "${var.codepipeline_name}"
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
        Owner      = "${var.github_owner}"
        Repo       = "${var.github_repo}"
        Branch     = "${var.github_branch}"

        # this needs to be here, even if it's a public repo
        OAuthToken = "${aws_ssm_parameter.github_oauth_token.value}"
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
        ProjectName = "${aws_codebuild_project.build.name}"
      }
    }
  }
}
