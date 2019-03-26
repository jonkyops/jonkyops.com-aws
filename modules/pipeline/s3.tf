# artifact bucket
resource "aws_s3_bucket" "artifacts" {
  bucket_prefix = "${var.github_repo}-artifacts"
  acl           = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}
