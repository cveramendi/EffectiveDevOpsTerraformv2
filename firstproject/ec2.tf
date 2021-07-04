provider "aws" {
  region     = "us-east-1"
}

# Resource Configuration for AWS
resource "aws_instance" "myserver" {
  ami                    = "ami-cfe4b2b0"
  instance_type          = "t2.micro"
  key_name               = "EffectiveDevOpsAWS"
  vpc_security_group_ids = ["sg-010850e373b7f921f"]

  //ha cambiado la version v1.0 necesita tags = {} en lugar de solo tags {}
  tags = {
    Name = "helloworld"
  }
}
