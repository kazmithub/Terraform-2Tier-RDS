variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  default     = "11.1.0.0/16"
}

variable "amis" {
  description = "AMIs by region"
  default = {
    us-west-2 = "ami-07b4f3c02c7f83d59" # ubuntu 18.04 LTS
  }
}

variable "awsRegion" {
  default = "us-west-2"
}

variable "subnetAZs" {
  default = "a,b"
}

variable "private_subnet1_cidr" {
  description = "CIDR for the Private Subnet"
  default     = "10.0.2.0/24"
}

variable "private_subnet2_cidr" {
  description = "CIDR for the Private Subnet"
  default     = "10.0.3.0/24"
}

variable "namePrefix" {
  
}

