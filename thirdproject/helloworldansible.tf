provider "aws" {
  region = "us-east-1"
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

  # Helloworld Appication code
  provisioner "remote-exec" {
    connection {
      user = "ec2-user"
      //private_key = file("/root/.ssh/EffectiveDevOpsAWS.pem")
      private_key = file("/home/christiand/.ssh/EffectiveDevOpsAWS.pem")
      host        = self.public_ip
    }
    inline = [
      "echo SSH Connection validated!"
    ]
  }

  provisioner "local-exec" {
    command = "sudo echo '${self.public_ip}' > ./myinventory"
  }

  provisioner "local-exec" {
    command = "sudo ansible-playbook -i myinventory --private-key=/home/christiand/.ssh/EffectiveDevOpsAWS.pem helloworld.yml"
  }
}

# IP address of newly created EC2 instance
output "myserver" {
  value = aws_instance.myserver.public_ip
}
