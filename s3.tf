resource "aws_s3_bucket" "logs" {
  bucket = "${var.site_domain}-site-logs"
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket" "site" {
  bucket = "${var.site_domain}"

  logging {
    target_bucket = "${aws_s3_bucket.logs.bucket}"
    target_prefix = "${var.site_domain}/"
  }

  website {
    index_document = "index.html"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_policy" "site" {
  bucket = "${aws_s3_bucket.site.id}"
  policy = "${data.aws_iam_policy_document.s3_policy.json}"
}

# artifact bucket
resource "aws_s3_bucket" "artifacts" {
  bucket = "${var.site_domain}-artifacts"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}
