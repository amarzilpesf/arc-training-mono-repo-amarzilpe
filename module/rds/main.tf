locals {
  engine         = var.engine[0]
  engine_version = var.engine_version[0]
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!@#$%^&*()_+"
}

resource "aws_ssm_parameter" "password_param" {
  name  = "rds-password"
  type  = "SecureString"
  value = random_password.password.result
}

resource "aws_db_instance" "rds_instance" {
  identifier            = "postgres-db"
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = "gp3"
  engine                = local.engine
  engine_version        = local.engine_version
  instance_class        = var.instance_class
  db_name               = "mydatabase"
  username              = var.username[0]
  password              = aws_ssm_parameter.password_param.value
  publicly_accessible   = false
  multi_az              = true
  skip_final_snapshot   = true

  tags = {
    Name = "${local.engine}-rds-instance"
  }
}
