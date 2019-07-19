provider "aws" {
  region     = "${var.aws_region}"
}


module "vpc" {
  source = "./modules/vpc"
  namePrefix = "${var.namePrefix}"
}

module "ec2" {
  source = "./modules/ec2"
  namePrefix = "${var.namePrefix}"
  keyName = "${var.keyName}"
  MyPublicSecurityGroup = "${module.vpc.MyPublicSecurityGroup}" 
  elb_sg = "${module.vpc.elb_sg}" 
  # subnet_ids = "${module.vpc.subnet_ids}"
  subnet_ids1 = "${module.vpc.subnet_ids1}"
  endpoint = "${module.database.endpoint}"  
  MyVPC = "${module.vpc.MyVPC}"     
}

module "database" {
  source = "./modules/database"
  namePrefix = "${var.namePrefix}"
  MyDBSecurityGroup = "${module.vpc.MyDBSecurityGroup}"
  # subnet_ids = "${module.vpc.subnet_ids}"
  subnet_group_id = "${module.vpc.subnet_group_id}"
}