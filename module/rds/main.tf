locals {
  engine         = var.engine[0]
  engine_version = var.engine_version[0]
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
  password              = var.password
  publicly_accessible   = false
  multi_az              = true
  skip_final_snapshot   = true

  tags = {
    Name = "${local.engine}-rds-instance"
  }
}
