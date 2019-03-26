# give the pipeline role bucket permissions for the site. kept this outside the module so it could be used for other builds
data "aws_iam_policy_document" "build_site_policy" {
  # need to be able to change objects in the bucket where the site is hosted
  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:ListBucket",
    ]

    resources = [
      "${module.site.site_bucket_arn}",
      "${module.site.site_bucket_arn}/*",
    ]
  }
}

resource "aws_iam_policy" "build_site_policy" {
  name        = "build-site-policy"
  path        = "/"
  description = "Gives the build role permission to update files in the site bucket"

  policy = "${data.aws_iam_policy_document.build_site_policy.json}"
}

resource "aws_iam_role_policy_attachment" "build_site_attach" {
  role = "${module.pipeline.build_role_name}"
  policy_arn = "${aws_iam_policy.build_site_policy.arn}"
}
