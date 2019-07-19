# terraform {
#   backend "s3" {
#     bucket = "ahsan-tf"
#     key = "terraform.tfstate"
#     region = "us-west-2"
#     dynamodb_table= "ahsan-tf"
#   }
# } 

# resource "aws_s3_bucket" "bucket" {
#   bucket = "ahsan-tf"
#   region = "us-west-2"
#   lifecycle {
#     prevent_destroy = true
#   }
# }

# resource "aws_dynamodb_table" "terraform_state_lock" {
#   name           = "terraform-lock"
#   read_capacity  = 5
#   write_capacity = 5
#   hash_key       = "LockID"
#   lifecycle {
#     prevent_destroy = true
#   }
# attribute {
#     name = "LockID"
#     type = "S"
#   }
# }