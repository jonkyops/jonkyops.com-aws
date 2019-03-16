provider "aws" {
  region     = "us-east-1"
}

resource "aws_iam_role" "build" {
  name = "build"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "build" {
  role = "${aws_iam_role.build.name}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    }
  ]
}
POLICY
}

resource "aws_codebuild_project" "build" {
  name          = "jonkyops"
  description   = "jonkyops.com project"
  service_role  = "${aws_iam_role.build.arn}"

  artifacts {
    type = "NO_ARTIFACTS"
  }

  source {
    type            = "GITHUB"
    location        = "${var.codebuild_github_repo_url}"
    git_clone_depth = 1
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "${var.codebuild_image}"
    type         = "LINUX_CONTAINER"
  }
}

