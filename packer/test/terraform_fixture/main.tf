resource "aws_instance" "ptfe-test" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.ptfe_instance.id]
  key_name                    = aws_key_pair.test-ptfe.key_name
  associate_public_ip_address = true
  volume_tags                 = var.common_tags
  tags                        = merge({ Name = "packer-test-ptfe-instance-${formatdate("YYMMDD-HHmm", timestamp())}" }, var.common_tags)
}

resource "aws_security_group" "ptfe_instance" {
  name        = "packer-ptfe-test-${formatdate("YYMMDD-HHmm", timestamp())}"
  description = "Allow needed needed traffic for PTFE."
  vpc_id      = var.vpc_id
  tags        = var.common_tags
}

resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.ptfe_instance.id
}

resource "aws_security_group_rule" "allow_all_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.ptfe_instance.id
}

resource "tls_private_key" "test-ptfe" {
  algorithm = "RSA"
}

resource "aws_key_pair" "test-ptfe" {
  key_name_prefix = "test-ptfe-"
  public_key      = tls_private_key.test-ptfe.public_key_openssh
  tags            = var.common_tags
}

terraform {
  required_version = "~> 0.12.20"
  required_providers {
    aws = "~> 2.49"
    tls = "~> 2.1"
  }
}

provider "aws" {
  region = var.aws_region
}

output "public_ip" {
  value = aws_instance.ptfe-test.public_ip
}

output "public_dns" {
  value = aws_instance.ptfe-test.public_dns
}

output "private_key" {
  value = tls_private_key.test-ptfe.private_key_pem
}

output "public_key" {
  value = tls_private_key.test-ptfe.public_key_pem
}
