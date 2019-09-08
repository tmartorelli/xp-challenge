#creating autoscaling policy to spin up instances
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "autoscaling_up_ec2_instance"
  scaling_adjustment     = "${var.scaling_adjust_alarm}"
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.ec2_asg.name}"
}

#create CPU Utilization check (High)
resource "aws_cloudwatch_metric_alarm" "high_cpu_utilization" {
  alarm_name          = "joomla_scale_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "${var.cpu_alarm_metric}"
  namespace           = "AWS/EC2"
  period              = "${var.alarm_time}"
  statistic           = "Average"
  threshold           = "${var.scale_up_alarm_threshold}"

  dimensions = {
    AutoScalingGroupName = "${aws_lb_target_group.lb_targetgroup.name}"
  }
  alarm_description = "This metric monitor joomla webserver high CPU utilization"
  alarm_actions     = ["${aws_autoscaling_policy.scale_up.arn}"]
}

#creating autoscaling policy to scale down instances

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "autoscaling_down_ec2_instance"
  scaling_adjustment     = "${var.scaling_adjust_alarm}"
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.ec2_asg.name}"
}

#create CPU Utilization check (Low)

resource "aws_cloudwatch_metric_alarm" "low_cpu_utilization" {
  alarm_name          = "joomla_scale_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "${var.cpu_alarm_metric}"
  namespace           = "AWS/EC2"
  period              = "${var.alarm_time}"
  statistic           = "Average"
  threshold           = "${var.scale_down_alarm_threshold}"

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.ec2_asg.name}"
  }
  alarm_description = "This metric monitor joomla webserver low CPU utilization"
  alarm_actions     = ["${aws_autoscaling_policy.scale_down.arn}"]
}





