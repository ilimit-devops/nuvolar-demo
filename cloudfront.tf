resource "aws_cloudfront_distribution" "nuvolar" {
  origin {
    domain_name = aws_instance.nuvolar.public_dns
    origin_id   = aws_instance.nuvolar.public_dns
    custom_origin_config {
      http_port              = 8080
      https_port             = 8443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }


  enabled = true

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_instance.nuvolar.public_dns

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
  depends_on = [
    aws_instance.nuvolar
  ]
}

output "nuvolar-web" {
  value = "curl https://${aws_cloudfront_distribution.nuvolar.domain_name}"
}
