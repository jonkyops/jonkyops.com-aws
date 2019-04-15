resource "aws_s3_bucket" "logs" {
  bucket_prefix = "${var.site_domain}-site-logs"
  acl           = "log-delivery-write"
  force_destroy = true

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket" "site" {
  bucket_prefix = "${var.site_domain}"

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
