module "rds" {
  source           = "../../Modules/rds"
  db_subnet1       = module.vpc.private_subnet_data1_id
  db_subnet2       = module.vpc.private_subnet_data2_id
  vpc_id           = module.vpc.vpc_id
  ec2_sg           = module.asg.ec2_sg
  db_size          = 8
  db_name          = "TestDB"
  db_instance_type = "db.t3.micro"
}

