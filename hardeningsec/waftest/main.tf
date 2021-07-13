/*
module "limit_admin_WAF" {
  source = "../modules/limit-the-admin-area_wafv2"
  alb_arn      = "arn:aws:elasticloadbalancing:us-east-1:695114505550:loadbalancer/app/playground/decfa1ef121a2ade"
  my_office_ip = "179.6.211.231/32"
  admin_suburl = "/subdir"
}
*/
module "ddos_protection_WAF" {
  source       = "../modules/ddos_protection_wafv2"
  alb_arn      = "arn:aws:elasticloadbalancing:us-east-1:695114505550:loadbalancer/app/playground/decfa1ef121a2ade"
  url = "subdir"
  limit = "120"
}
