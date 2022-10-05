module "elb" {
  source         = "../../Modules/elb"
  vpc_id         = module.vpc.vpc_id
  public_subnet1_id = module.vpc.pub_subnet1_id
  public_subnet2_id = module.vpc.pub_subnet2_id
}
