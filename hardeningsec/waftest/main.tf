module "limit_admin_WAF" {
  source = "../modules/limit-the-admin-area_wafv2"
  alb_arn      = "arn:aws:elasticloadbalancing:us-east-1:695114505550:loadbalancer/app/playground/decfa1ef121a2ade"
  my_office_ip = "179.6.211.231/32"
  admin_suburl = "/subdir"
}
/*
module "ddos_protection_WAF" {
  source       = "github.com/giuseppeborgese/effective_devops_with_aws__second_edition//terraform-modules//ddos_protection"
  alb_arn      = "${module.webapp-playground.alb_arn}"
  url = "subdir"
}
*/