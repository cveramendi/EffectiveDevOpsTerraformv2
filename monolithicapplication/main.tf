//????
provider "aws" {
  region = "us-east-1"
}

module "monolith_application" {
  source         = "github.com/giuseppeborgese/effective_devops_with_aws__second_edition//terraform-modules//monolith-playground"
  //my_vpc_id      = "${var.my_default_vpcid}"
  my_vpc_id      = "vpc-d2f151af"
  my_subnet      = "subnet-944b93a5"
  my_ami_id      = "ami-0ab4d1e9cf9a1215a"
  //my_pem_keyname = "effectivedevops"
  my_pem_keyname = "EffectiveDevOpsAWS"
}
output "monolith_url" { value = "${module.monolith_application.url}"}

resource "aws_security_group" "rds" {
  name        = "allow_from_my_vpc"
  description = "Allow from my vpc"
  //vpc_id      = "${var.my_default_vpcid}"
  vpc_id      = "vpc-d2f151af"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
  }
}

module "db" {
  source = "terraform-aws-modules/rds/aws"
  identifier = "demodb"
  engine            = "mysql"
  engine_version    = "5.7.19"
  instance_class    = "db.t2.micro"
  allocated_storage = 5
  name     = "demodb"
  username = "monty"
  password = "some_pass"
  port     = "3306"

  vpc_security_group_ids = ["${aws_security_group.rds.id}"]
  # DB subnet group
  subnet_ids = ["subnet-68622c66", "subnet-23fbdf6e"]
  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"
  # DB parameter group
  family = "mysql5.7"
  # DB option group
  major_engine_version = "5.7"
}