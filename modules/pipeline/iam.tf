#------------------------------------
# roles/policies for codebuild
#------------------------------------

# assume role policy for build role
data "aws_iam_policy_document" "build_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

# role policy for build
resource "aws_iam_role_policy" "build" {
  name = "${var.github_repo}-build-policy"
  role = "${aws_iam_role.build.name}"

  policy = "${data.aws_iam_policy_document.build_policy.json}"
}

# role for build
resource "aws_iam_role" "build" {
  name               = "build-role"
  assume_role_policy = "${data.aws_iam_policy_document.build_assume_role_policy.json}"
}

# policy for codebuild
data "aws_iam_policy_document" "build_policy" {
  # access for things like listing buckets, creating logs, and starting builds
  statement {
    actions = [
      "logs:CreateLogStream",
      "s3:PutAccountPublicAccessBlock",
      "s3:GetAccountPublicAccessBlock",
      "s3:ListAllMyBuckets",
      "codebuild:StartBuild",
      "s3:HeadBucket",
      "logs:CreateLogGroup",
      "logs:PutLogEvents",
      "codebuild:BatchGetBuilds",
    ]

    resources = ["*"]
  }

  # give permission to the artifacts bucket
  statement {
    actions = ["s3:*"]

    resources = [
      "${aws_s3_bucket.artifacts.arn}/*",
      "${aws_s3_bucket.artifacts.arn}",
    ]
  }
}

#------------------------------------
# roles/policies for codepipeline
#------------------------------------

# assume role policy for pipeline role
data "aws_iam_policy_document" "pipeline_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

# role for pipeline
resource "aws_iam_role" "pipeline" {
  name = "pipeline-role"
  assume_role_policy = "${data.aws_iam_policy_document.pipeline_assume_role_policy.json}"
}

# pipeline policy
data "aws_iam_policy_document" "pipeline_policy" {
  statement {
    resources = ["*"]

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }

  statement {
    actions = ["*"]

    resources = [
      "${aws_s3_bucket.artifacts.arn}",
      "${aws_s3_bucket.artifacts.arn}/*",
    ]
  }

  statement {
    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
    ]

    resources = ["*"]
  }
}

# role policy for pipeline
resource "aws_iam_role_policy" "pipeline" {
  name = "${var.github_repo}-pipeline-policy"
  role = "${aws_iam_role.pipeline.name}"

  policy = "${data.aws_iam_policy_document.pipeline_policy.json}"
}
