data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "aws_availability_zones" "azs" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

resource "tls_private_key" "ssh_key_generate" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.ssh_key
  public_key = tls_private_key.ssh_key_generate.public_key_openssh

  provisioner "local-exec" {
    command = "echo '${tls_private_key.ssh_key_generate.private_key_pem}' > ${var.path}/ssh_key.pem"
  }
}

resource "aws_instance" "web" {
  ami               = data.aws_ami.ubuntu.id
  instance_type     = var.instance_type
  for_each          = toset(data.aws_availability_zones.azs.names)
  availability_zone = each.key
  key_name          = aws_key_pair.generated_key.key_name
  security_groups   = [aws_security_group.sg.name]
  root_block_device {
    volume_type           = var.volume_type
    volume_size           = var.volume_size
    encrypted             = var.encrypted
    delete_on_termination = var.delete_on_termination
  }

  tags = {
    Name = "web-${each.value}"
  }
}


resource "aws_security_group" "sg" {
  name        = "web_sg"
  description = "Security group for EC2 instance"

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
}
