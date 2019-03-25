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

# role policy for pipeline
resource "aws_iam_role_policy" "pipeline" {
  name = "${var.site_domain}-pipeline-policy"
  role = "${aws_iam_role.pipeline.name}"

  policy = "${data.aws_iam_policy_document.pipeline_policy.json}"
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
