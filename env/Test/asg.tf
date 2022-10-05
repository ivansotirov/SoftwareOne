module "asg" {
  source             = "../../Modules/asg"
  instance_type      = "t3.medium"
  vpc_id             = module.vpc.vpc_id
  private_subnet1_id = module.vpc.private_subnet1_id
  private_subnet2_id = module.vpc.private_subnet2_id
  sgr_alb            = module.elb.sgr_alb
  ami_id             = "ami-05ff5eaef6149df49"
  tgr_alb_arn        = module.elb.tgr_alb_arn
}
