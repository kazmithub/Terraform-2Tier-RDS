output "MyPublicSecurityGroup" {
  value = "${aws_security_group.MyPublicSG.id}"
}
output "elb_sg" {
  value = "${aws_security_group.elb_sg.id}"
}

output "subnet_ids" {
  value = "${aws_subnet.private.*.id}"
  # value = “${join(“,”, aws_subnet.private.*.id)}”
}


output "subnet_ids1" {
  value = "${aws_subnet.public.*.id}"
  # value = “${join(“,”, aws_subnet.private.*.id)}”
}

output "subnet_group_id" {
  value = "${aws_db_subnet_group.PrivateSubnetGroup.id}"
}

output "MyDBSecurityGroup" {
  value = "${aws_security_group.MyDBSecurityGroup.id}"
}

output "MyVPC" {
  value = "${aws_vpc.MyVPC.id}"
}
