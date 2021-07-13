resource "aws_wafv2_ip_set" "ipset" {
  name               = "allow_ips"
  description        = "allow_ips IP set"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = ["${var.my_office_ip}"]

  tags = {
    Env = "PROD"
    Owner = "cV"
  }
}

resource "aws_wafv2_rule_group" "wafrules" {
  name        = "adminrulesgroup"
  description = "An rule group containing all statements"
  scope       = "REGIONAL"
  capacity    = 500

  rule {
    name     = "adminrule"
    priority = 1

    action {
      block {}
    }

    statement {
      and_statement {
        statement {
          not_statement {
            statement {
              ip_set_reference_statement {
                arn = aws_wafv2_ip_set.ipset.arn
              }   
            }
          }
        }

        statement {
          byte_match_statement {
            field_to_match {
              uri_path {}
            }
            positional_constraint = "STARTS_WITH"
            search_string         = "${var.admin_suburl}"

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
      metric_name                = "adminrule"
      sampled_requests_enabled   = false
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "adminrulesgroup"
    sampled_requests_enabled   = false
  }

  tags = {
    Name = "adminrulesgroup"
    Owner = "CV"
  }
}

resource "aws_wafv2_web_acl" "waf_acl" {
  name        = "adminprotection"
  description = "adminprotection managed rule."
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "adminrule"
    priority = 1

    override_action {
      none {}
    }

    statement {
      rule_group_reference_statement {
        arn = aws_wafv2_rule_group.wafrules.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "adminrule"
      sampled_requests_enabled   = false
    }
  }

  tags = {
    Owner = "CV"
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "adminprotection"
    sampled_requests_enabled   = false
  }
}


resource "aws_wafv2_web_acl_association" "my_alb" {
  resource_arn = "${var.alb_arn}"
  web_acl_arn = "${aws_wafv2_web_acl.waf_acl.arn}"
}