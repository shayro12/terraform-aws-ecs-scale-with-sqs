variable "metric_name" {
  default     = "ApproximateNumberOfMessagesVisible"
  description = "value of the metric to be used for scaling , set to ApproximateNumberOfMessagesVisible for SQS by default but can be changed to any other metric"
  type        = string
}
variable "min_evaluation_period" {
  default     = 1
  description = "minimum evaluation period for the alarm"
}
variable "min_period" {
  default     = 60
  description = "minimum period for the alarm in seconds"
  type        = number
}
variable "max_evaluation_period" {
  default     = 1
  description = "maximum evaluation period for the alarm"
  type        = number

}
variable "max_period" {
  default     = 10
  description = "maximum period for the alarm in seconds"
  type        = number
}
variable "scale_target_max_capacity" {
  default     = 10
  description = "maximum capacity for the target"
  type        = number
}
variable "scale_target_min_capacity" {
  default     = 1
  description = "minimum capacity for the target"
  type        = number
}
variable "min_threshold" {
  default     = 100
  description = <<EOT
  threshold for the scale down policy
  eg. if the threshold is 100 and the metric value is 90, the scale down policy will be triggered
  EOT
}
variable "max_threshold" {
  default     = 2
  description = <<EOT
  threshold for the scale up policy
  eg. if the threshold is 2 and the metric value is 3, the scale up policy will be triggered
  EOT

}
variable "ecs_cluster_name" {
  description = "name of the ECS cluster"


}
variable "ecs_service_name" {
  description = "name of the ECS service"
}
variable "name_prefix" {
  default = "sqs"
}
variable "cooldown" {
  default = 60
}
variable "step_adjustment_lower_bound" {
  default = [
    { # because Min therehold is 100 
      # when SQS messages are lower than 20 scale to 2
      metric_interval_lower_bound = ""
      metric_interval_upper_bound = "-90"
      scaling_adjustment          = "1"
    },
    { # when SQS messages are between 50 to 10 scale to 4
      metric_interval_lower_bound = "-90"
      metric_interval_upper_bound = "-50"
      scaling_adjustment          = "5"
    },
    { # when SQS messages are between 100 to 50 scale to 8
      metric_interval_lower_bound = "-50"
      metric_interval_upper_bound = "0"
      scaling_adjustment          = "10"
    }
  ]
  description = <<EOT
  a list of maps containing the lower bound for the step adjustment (scaling down) 
  metric_interval_lower_bound: the lower bound for the metric interval
  metric_interval_upper_bound: the upper bound for the metric interval
  scaling_adjustment: the scaling adjustment to be applied when the metric is within the interval
  EOT
}
variable "step_adjustment_upper_bound" {
  default = [
    { # start from 2 because this is the max theresold
      # when SQS messages are between 2 to 10 scale to 1
      metric_interval_lower_bound = "0"
      metric_interval_upper_bound = "8"
      scaling_adjustment          = "1"
    },
    { # when SQS messages are between 10 to 50 scale to 5
      metric_interval_lower_bound = "8"
      metric_interval_upper_bound = "48"
      scaling_adjustment          = "5"
    },
    { # when SQS messages are between 50 to infinity scale to 10
      metric_interval_lower_bound = "48"
      metric_interval_upper_bound = ""
      scaling_adjustment          = "10"
    }
  ]
  description = <<EOT
  a list of maps containing the upper bound for the step adjustment (scaling up) 
  metric_interval_lower_bound: the lower bound for the metric interval
  metric_interval_upper_bound: the upper bound for the metric interval
  scaling_adjustment: the scaling adjustment to be applied when the metric is within the interval
  EOT
}
variable "queue_name" {
  description = "name of the SQS queue"
}


variable "scale_up_step_scaling_policy_configuration" {
  description = "Step Scaling Policy Configuration for Scale Up"
  type = object({
    adjustment_type          = string
    cooldown                 = number
    metric_aggregation_type  = string
    min_adjustment_magnitude = number
  })
  default = {
    adjustment_type          = "ExactCapacity"
    cooldown                 = 60
    metric_aggregation_type  = "Average"
    min_adjustment_magnitude = 0
  }



}
variable "scale_down_step_scaling_policy_configuration" {
  description = "Step Scaling Policy Configuration for Scale Down"
  type = object({
    adjustment_type          = string
    cooldown                 = number
    metric_aggregation_type  = string
    min_adjustment_magnitude = number
  })
  default = {
    adjustment_type          = "ExactCapacity"
    cooldown                 = 60
    metric_aggregation_type  = "Average"
    min_adjustment_magnitude = 0
  }
}
variable "aws_cloudwatch_metric_alarm_config_high" {
  default = {
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods  = 1
    metric_name         = "ApproximateNumberOfMessagesVisible"
    namespace           = "AWS/SQS"
    period              = 10
    statistic           = "Maximum"
    threshold           = 2

  }
  type = object({
    comparison_operator = string
    evaluation_periods  = number
    metric_name         = string
    namespace           = string
    period              = number
    statistic           = string
    threshold           = number
  })

}
variable "aws_cloudwatch_metric_alarm_config_low" {
  default = {
    comparison_operator = "LessThanOrEqualToThreshold"
    evaluation_periods  = 1
    metric_name         = "ApproximateNumberOfMessagesVisible"
    namespace           = "AWS/SQS"
    period              = 10
    statistic           = "Average"
    threshold           = 100

  }
  type = object({
    comparison_operator = string
    evaluation_periods  = number
    metric_name         = string
    namespace           = string
    period              = number
    statistic           = string
    threshold           = number
  })

}