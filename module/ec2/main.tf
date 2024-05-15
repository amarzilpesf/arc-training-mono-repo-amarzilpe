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

resource "aws_key_pair" "ssh_key" {
  key_name   = "my-key"
  public_key = file("/home/amar.zilpe/Documents/learning_platform/Udemy/ssh_key/ssh_key.pub")
}


resource "aws_instance" "web" {
  ami               = data.aws_ami.ubuntu.id
  instance_type     = var.instance_type
  for_each          = toset(data.aws_availability_zones.azs.names)
  availability_zone = each.key
  key_name          = aws_key_pair.ssh_key.key_name

  tags = {
    Name = "web-${each.value}"
  }
}
