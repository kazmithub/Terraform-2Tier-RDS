resource "aws_db_instance" "MyDatabase" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  name                   = "mydb"
  skip_final_snapshot    = true
  username               = "admin"
  password               = "0514457570"
  db_subnet_group_name   = "${var.subnet_group_id}"
  vpc_security_group_ids = ["${var.MyDBSecurityGroup}"]
}