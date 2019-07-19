## Creating Launch Configuration
resource "aws_launch_configuration" "web_lc" {
  image_id                    = "${lookup(var.amis,var.aws_region)}"
  instance_type               = "t2.micro"
  security_groups             = ["${var.MyPublicSecurityGroup}"]
  key_name                    = "${var.keyName}"
  associate_public_ip_address = true
  user_data                   = "${data.template_file.userdata.rendered}"
  lifecycle {
    create_before_destroy = true
  }
}

## Creating ASG

resource "aws_autoscaling_group" "web_asg" {
  launch_configuration = "${aws_launch_configuration.web_lc.id}"
  # availability_zones = ["us-west-2a", "us-west-2b"]
  vpc_zone_identifier = ["${var.subnet_ids1[0]}", "${var.subnet_ids1[1]}"]
  # vpc_zone_identifier = ["${element(var.subnet_ids, 0)}", "${element(var.subnet_ids, 1)}"]
  min_size = 2
  max_size = 4
  target_group_arns = ["${aws_alb_target_group.alb_target_group.arn}"]
  tag {
    key = "Name"
    value = "${var.namePrefix}-lc"
    propagate_at_launch = true
  }
}

# # ## Creating ALB

resource "aws_alb" "app_lb" {
  name               = "web-app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${var.elb_sg}"]
  subnets            = ["${element(var.subnet_ids1, 0)}", "${element(var.subnet_ids1, 1)}"]
 // subnets = ["${var.subnet_ids.0.id}", "${aws_subnet.private.1.id}"]

  enable_deletion_protection = false
  tags = {
    key = "Name"
    value = "${var.namePrefix}-alb"
  }
}

# ## Creating Listener for ALB

resource "aws_alb_listener" "alb_listener" {  
  load_balancer_arn = "${aws_alb.app_lb.arn}"  
  port              = "80"  
  protocol          = "HTTP"
  
  default_action {    
    target_group_arn = "${aws_alb_target_group.alb_target_group.arn}"
    type             = "forward"  
  }
}

# ## Creating Target Group for ALB
resource "aws_alb_target_group" "alb_target_group" {  
  name     = "web-alb-tg"  
  port     = "80"  
  protocol = "HTTP"  
  vpc_id   = "${var.MyVPC}"   
}