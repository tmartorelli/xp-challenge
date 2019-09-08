#Create HTTP 4xx request check

resource "aws_cloudwatch_metric_alarm" "http_error_request" {
  alarm_name                = "4xx_request"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  threshold                 = "10"
  alarm_description         = "Request error rate has exceeded 10%"
  insufficient_data_actions = []


  metric_query {
    id          = "e1"
    expression  = "m2/m1*100"
    label       = "Error Rate"
    return_data = "true"
  }

  metric_query {
    id = "m1"

    metric {
      metric_name = "RequestCount"
      namespace   = "AWS/ApplicationELB"
      period      = "120"
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        LoadBalancer = "app/jml-alb/${element(split("/", aws_lb.loadbalancer.id), length(split("/", aws_lb.loadbalancer.id)) - 1)}"
      }
    }
  }

  metric_query {
    id = "m2"

    metric {
      metric_name = "HTTPCode_ELB_4XX_Count"
      namespace   = "AWS/ApplicationELB"
      period      = "120"
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        LoadBalancer = "app/jml-alb/${element(split("/", aws_lb.loadbalancer.id), length(split("/", aws_lb.loadbalancer.id)) - 1)}"
      }
    }
  }
}