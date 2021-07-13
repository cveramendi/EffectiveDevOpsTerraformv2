/*resource "aws_wafv2_rule_group" "startrulegroup" {
  name        = "startrulegroup"
  description = "An rule group containing all statements"
  scope       = "REGIONAL"
  capacity    = 500

  rule {
    name     = "startrule"
    priority = 1

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = "${var.limit}"
        aggregate_key_type = "IP"
        
        scope_down_statement {
          byte_match_statement {
            field_to_match {
              uri_path {}
            }
            positional_constraint = "STARTS_WITH"
            search_string         = "/${var.url}"

            text_transformation  {
              priority = 0
              type     = "LOWERCASE"
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "startrule"
      sampled_requests_enabled   = false
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "startrulegroup"
    sampled_requests_enabled   = false
  }

  tags = {
    Name = "adminrulesgroup"
    Owner = "CV"
  }
}*/

resource "aws_wafv2_web_acl" "waf_acl" {
  name        = "playground"
  description = "playground managed rule."
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "startrule"
    priority = 1

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = "${var.limit}"
        aggregate_key_type = "IP"
        
        scope_down_statement {
          byte_match_statement {
            field_to_match {
              uri_path {}
            }
            positional_constraint = "STARTS_WITH"
            search_string         = "/${var.url}"

            text_transformation  {
              priority = 0
              type     = "LOWERCASE"
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "startrule"
      sampled_requests_enabled   = false
    }
  }

  tags = {
    Owner = "CV"
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "${var.url}"
    sampled_requests_enabled   = false
  }
}


resource "aws_wafv2_web_acl_association" "my_alb" {
  resource_arn = "${var.alb_arn}"
  web_acl_arn = "${aws_wafv2_web_acl.waf_acl.arn}"
}
