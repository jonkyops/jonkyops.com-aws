output "site_bucket_arn" {
  value = "${aws_s3_bucket.site.arn}"
}

output "site_bucket_id" {
  value = "${aws_s3_bucket.site.id}"
}

output "logs_bucket_arn" {
  value = "${aws_s3_bucket.logs.arn}"
}

output "logs_bucket_id" {
  value = "${aws_s3_bucket.logs.id}"
}
