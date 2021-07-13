/*
module "flow-log-prerequisite" {
  source = "github.com/giuseppeborgese/effective_devops_with_aws__second_edition//terraform-modules//vpc-flow-logs-prerequisite"
  prefix = "devops2nd"
}

output "role" { value = "${module.flow-log-prerequisite.rolename}" }
output "loggroup" { value = "${module.flow-log-prerequisite.cloudwatch_log_group_arn}" }
*/

module "webapp-playground" {
  source = "./modules/webapp-playground"
  subnet_public_A = "subnet-23fbdf6e"
  subnet_public_B = "subnet-0852c357"
  subnet_private  = "subnet-0e6677ce624d4f2bf"
  vpc_id          = "vpc-d2f151af"
  my_ami          = "ami-0dc2d3e4c0f9ebd18"
  pem_key_name    = "EffectiveDevOpsAWS"
}
/*
module "limit_admin_WAF" {
  source = "./modules/limit-the-admin-area"
  alb_arn      = "${module.webapp-playground.alb_arn}"
  my_office_ip = "179.6.211.230/32"
  admin_suburl = "/subdir"
}

module "ddos_protection_WAF" {
  source       = "github.com/giuseppeborgese/effective_devops_with_aws__second_edition//terraform-modules//ddos_protection"
  alb_arn      = "${module.webapp-playground.alb_arn}"
  url = "subdir"
}
*/