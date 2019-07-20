variable "keyName" {
  default = "Kazmi-Oregon"
}
variable "amis" {
  description = "AMIs by region"
  default = {
    us-west-2 = "ami-07b4f3c02c7f83d59" # ubuntu 18.04 LTS
  }
}

variable "aws_region" {
  default = "us-west-2"
}
variable "MyPublicSecurityGroup" {}

variable "elb_sg" {}

variable "subnet_ids1" {}

variable "namePrefix" {
  
}

variable "endpoint" {
}
variable "MyVPC" {
  
}

