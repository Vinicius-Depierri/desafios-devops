terraform {
  required_version = "~>1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Creating VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc_desafio"
  cidr = "10.0.0.0/16"

  azs = [data.aws_availability_zones.available.names[0]]
  public_subnets = ["10.0.101.0/24"]

  #NACL
  default_network_acl_egress = [
    {
      "action" : "allow",
      "cidr_block" : "0.0.0.0/0",
      "from_port" : 0,
      "protocol" : "-1",
      "rule_no" : 100,
      "to_port" : 0
    }
  ]
  default_network_acl_ingress = [
    {
      "action" : "allow",
      "cidr_block" : "0.0.0.0/0",
      "from_port" : 0,
      "protocol" : "-1",
      "rule_no" : 100,
      "to_port" : 0
    }
  ]
  default_network_acl_name = "nacl_desafio"
  default_network_acl_tags = {
    Name = "NACL Desafio"
  }
}

#Creating AWS EC2 Instance
module "instance_desafio" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "instance_desafio"

  ami                         = "ami-084568db4383264d4"
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.kp_desafio.key_name
  vpc_security_group_ids      = [module.sg_desafio.security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  user_data                   = <<-EOF
              #!/bin/bash
              exec > /var/log/user-data.log 2>&1
              set -x

              # Atualiza pacotes
              apt-get update -y

              # Instala dependências
              apt-get install -y \
                apt-transport-https \
                ca-certificates \
                curl \
                software-properties-common

              # Adiciona GPG key e repositório do Docker
              curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
              add-apt-repository \
                "deb [arch=amd64] https://download.docker.com/linux/ubuntu noble stable"

              apt-get update -y
              apt-get install -y docker-ce docker-ce-cli containerd.io

              # Habilita Docker
              systemctl start docker
              systemctl enable docker

              # Executa container Apache
              docker run -d -p 80:80 httpd
              EOF
  user_data_replace_on_change = true


  tags = {
    Name = "Instância Desafio"
  }
}

# Creating the Key Pair
resource "aws_key_pair" "kp_desafio" {
  key_name   = "kp_desafio"
  public_key = file("~/.ssh/desafio.pub")
}

module "sg_desafio" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "sg_desafio"
  description = "Security group with custom ports open within VPC."
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "ssh"
      cidr_blocks = var.ip_range_ssh
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "HTTP"
      cidr_blocks = "0.0.0.0/0"

    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "HTTPS"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "all"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  tags = {
    Name = "SG Desafio"
  }
}