data "template_file" "userdata" {
    template = "${file("./modules/ec2/templates/userdata.tpl")}"
    vars = {
      endpoint = "${var.endpoint}"
  }
}
