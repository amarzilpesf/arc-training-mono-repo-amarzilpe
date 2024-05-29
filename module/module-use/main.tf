module "vpc" {
  source   = "../network/vpc"
  vpc_name = "arc-project"
}

module "ec2" {
  source        = "../ec2"
  instance_type = var.instance_type
  subnet_id     = module.vpc.pub_subnet_id[0]
  depends_on    = [module.vpc]
}

module "rds" {
  source               = "../rds"
  db_subnet_group_name = aws_db_subnet_group.custom_rds_group.name
  depends_on           = [module.ec2]
}

# Custom RDS Group
resource "aws_db_subnet_group" "custom_rds_group" {
  name       = "custom_rds_group"
  subnet_ids = module.vpc.pvt_subnet_id
  depends_on = [module.vpc]

  tags = {
    Name = "custom_rds_subnet_group"
  }
}
