module "vpc" {
  source                    = "../../Modules/vpc"
  vpc_cidr                  = "10.100.0.0/16"
  dns_support               = true
  dns_host_names            = true
  vpc_name                  = "HeleCloud"
  public_subnet1_cidr       = "10.100.10.0/24"
  public_subnet2_cidr       = "10.100.20.0/24"
  private_subnet1_cidr      = "10.100.1.0/24"
  private_subnet2_cidr      = "10.100.2.0/24"
  private_subnet_data1_cidr = "10.100.4.0/24"
  private_subnet_data2_cidr = "10.100.6.0/24"
}


