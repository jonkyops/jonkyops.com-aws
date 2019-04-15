resource "aws_ssm_parameter" "site_bucket_url" {
  name      = "codebuild-siteBucketUrl"
  type      = "String"
  value     = "${aws_s3_bucket.site.id}"
  overwrite = true
}

resource "aws_ssm_parameter" "distribution_id" {
  name      = "codebuild-distributionId"
  type      = "String"
  value     = "${aws_cloudfront_distribution.distribution.id}"
  overwrite = true
}
