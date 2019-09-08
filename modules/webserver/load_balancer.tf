resource "aws_lb" "loadbalancer" {
  name = "jml-alb"
  internal = false
  security_groups = ["${aws_security_group.external_sg.id}"]
  subnets = ["${var.dmz_subnet_1}", "${var.dmz_subnet_2}"]

   enable_deletion_protection = false

  tags = {
      Name = "Application Load Balancer"
      Enviroment = "Production"
  }
}

resource "aws_security_group" "external_sg" {
  name = "external_sg"
  description = "Allow external HTTP inbound traffic and outbound traffic to api-servers"
  vpc_id = "${var.vpc_id}"

  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks     = ["0.0.0.0/0"] 
  }
}


resource "aws_lb_target_group" "lb_targetgroup" {
  name = "tg-loadbalancer-prod"
  port = 80
  protocol = "HTTP"
  vpc_id = "${var.vpc_id}"

  health_check {
      interval = "30"
      path = "/"
      protocol = "HTTP"
      healthy_threshold = "2"
      unhealthy_threshold = "5"
      timeout = "28"
      matcher = "200"    //fixed the unhealthy issue on console setting the success code to 302 instead of 200
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = "${aws_lb.loadbalancer.arn}"
  port = 80
  protocol = "HTTP"

   default_action {
       target_group_arn = "${aws_lb_target_group.lb_targetgroup.arn}"
       type = "forward"

#     # redirect {
#     #   port        = "443"
#     #   protocol    = "HTTPS"
#     #   status_code = "HTTP_301"
#     # }
   }
}

# resource "aws_lb_listener" "https_listener" {
#   load_balancer_arn = "${aws_lb.loadbalancer.arn}"
#   port = 443
#   protocol = "HTTPS"
#   ssl_policy = "ELBSecurityPolicy-2016-08"
  

#   default_action {
#       target_group_arn = "${aws_lb_target_group.lb_targetgroup.arn}"
#       type = "forward"
#   }
# }
