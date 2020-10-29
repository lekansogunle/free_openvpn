terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.server_region
}

output "access_vpn_url" {
  value       = "https://${aws_instance.openvpn.public_ip}:943/admin"
  description = "The public url address of the vpn server"
}

locals {
  images = {
    us-east-1      = "ami-037ff6453f0855c46"
    eu-central-1   = "ami-0764964fdfe99bc31"
    ap-northeast-1 = "ami-04f47c2ec43830d77"
  }
}

resource "aws_instance" "openvpn" {
  ami                    = local.images[var.server_region]
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
              admin_user=${var.server_username}
              admin_pw=${var.server_password}
              EOF

  tags = {
    Name = var.server_name
  }
}

resource "aws_security_group" "instance" {
  name        = "openvpn-default"
  description = "OpenVPN security group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 943
    to_port     = 943
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 945
    to_port     = 945
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
