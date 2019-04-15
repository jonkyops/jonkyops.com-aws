resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "cloudfront origin access identity"
}

resource "aws_cloudfront_distribution" "distribution" {
  enabled         = true
  price_class     = "PriceClass_100"
  aliases         = ["${var.site_domain}"]
  is_ipv6_enabled = true

  origin {
    origin_id   = "origin-bucket-${aws_s3_bucket.site.id}"
    domain_name = "${aws_s3_bucket.site.bucket_regional_domain_name}"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
    }
  }

  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "origin-bucket-${aws_s3_bucket.site.id}"

    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    lambda_function_association {
      event_type   = "viewer-request"
      lambda_arn   = "${aws_lambda_function.edge_lambda.qualified_arn}"
      include_body = false
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = "${aws_acm_certificate.cert.arn}"
    minimum_protocol_version = "TLSv1.1_2016"
    ssl_support_method       = "sni-only"
  }
}

# DNS record pointing to the cloudfront distribution
resource "aws_route53_record" "site" {
  zone_id = "${data.aws_route53_zone.domain.zone_id}"
  name    = "${var.site_domain}"
  type    = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.distribution.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.distribution.hosted_zone_id}"
    evaluate_target_health = false
  }
}
