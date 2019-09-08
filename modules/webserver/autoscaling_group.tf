data "template_file" "userdata_webserver" {
  template = "${file("${path.module}/ec2_template/userdata.sh")}"

  #Define variables for dynamic DB credential configuration (configuration.php)
  vars = {
    db_endpoint = "${var.db_endpoint}"
    db_admin    = "${var.db_admin}"
    db_passwd   = "${var.db_passwd}"
    jml_mail    = "${var.jml_mail}"
    site_name   = "${var.site_name}"
    db_name     = "${var.db_name}"

  }
}


resource "aws_iam_instance_profile" "instance" {
  name = "instance_launcher"
  role = "${aws_iam_role.instance.name}"
}



resource "aws_launch_configuration" "ec2_webserver" {
  name                 = "ec2_webserver"
  image_id             = "${var.ami}"
  instance_type        = "${var.instance_type}"
  security_groups      = ["${aws_security_group.ssh_sg.id}", "${aws_security_group.public_sg.id}"]
  user_data            = "${data.template_file.userdata_webserver.rendered}"
  key_name             = "${var.key_pair}"
  iam_instance_profile = "${aws_iam_instance_profile.instance.name}"
}


resource "aws_iam_role" "instance" {
  name = "instance_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "s3_full_access" {
  role       = "${aws_iam_role.instance.name}"
  policy_arn = "${var.s3_full_access_policy}"
}


resource "aws_autoscaling_group" "ec2_asg" {
  launch_configuration = "${aws_launch_configuration.ec2_webserver.name}"
  min_size             = "${var.min_instances}"
  max_size             = "${var.max_instances}"

  vpc_zone_identifier = ["${var.public_subnet_1}", "${var.public_subnet_2}"]
  target_group_arns   = ["${aws_lb_target_group.lb_targetgroup.arn}"]

  lifecycle {
    create_before_destroy = true
  }
}

