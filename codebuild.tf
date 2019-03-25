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
  name = "${var.site_domain}-build-policy"
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

  # need to be able to change objects in the bucket where the site is hosted
  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:ListBucket",
    ]

    resources = [
      "${aws_s3_bucket.site.arn}",
      "${aws_s3_bucket.site.arn}/*",
    ]
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
