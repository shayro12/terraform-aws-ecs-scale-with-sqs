



#------------------------------------------------------------------------------
# AWS Auto Scaling - Scaling Up Policy
#------------------------------------------------------------------------------

resource "aws_appautoscaling_policy" "scale_up_policy" {


  name               = "${var.name_prefix}-sqs-scale-out"
  policy_type        = "StepScaling"
  resource_id        = "service/${var.ecs_cluster_name}/${var.ecs_service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  step_scaling_policy_configuration {
    adjustment_type          = "ExactCapacity"
    cooldown                 = var.cooldown
    metric_aggregation_type  = "Average"
    min_adjustment_magnitude = 0

    dynamic "step_adjustment" {
      for_each = var.step_adjustment_upper_bound
      content {
        metric_interval_lower_bound = step_adjustment.value["metric_interval_lower_bound"]
        metric_interval_upper_bound = step_adjustment.value["metric_interval_upper_bound"]
        scaling_adjustment          = step_adjustment.value["scaling_adjustment"]
      }
    }
  }
  depends_on = [aws_appautoscaling_target.scale_target]

}

#------------------------------------------------------------------------------
# AWS Auto Scaling - Scaling Down Policy
#------------------------------------------------------------------------------

resource "aws_appautoscaling_policy" "scale_down_policy" {


  name               = "${var.name_prefix}-sqs-scale-in"
  policy_type        = "StepScaling"
  resource_id        = "service/${var.ecs_cluster_name}/${var.ecs_service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  step_scaling_policy_configuration {
    adjustment_type         = "ExactCapacity"
    cooldown                = var.cooldown
    metric_aggregation_type = "Average"

    dynamic "step_adjustment" {
      for_each = var.step_adjustment_lower_bound
      content {
        metric_interval_lower_bound = step_adjustment.value["metric_interval_lower_bound"]
        metric_interval_upper_bound = step_adjustment.value["metric_interval_upper_bound"]
        scaling_adjustment          = step_adjustment.value["scaling_adjustment"]
      }
    }
  }
  depends_on = [aws_appautoscaling_target.scale_target]
}

#------------------------------------------------------------------------------
# AWS Auto Scaling - CloudWatch Alarm SQS High
#------------------------------------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "custom_high" {
  alarm_name          = "${var.name_prefix}-sqs-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.max_evaluation_period
  metric_name         = var.metric_name
  namespace           = "AWS/SQS"
  period              = var.max_period
  statistic           = "Maximum"
  threshold           = var.max_threshold
  dimensions = {
    QueueName = "${var.queue_name}"
  }
  alarm_actions = [aws_appautoscaling_policy.scale_up_policy.arn]

}

#------------------------------------------------------------------------------
# AWS Auto Scaling - CloudWatch Alarm SQS Low
#------------------------------------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "custom_low" {
  alarm_name          = "${var.name_prefix}-sqs-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = var.min_evaluation_period
  metric_name         = var.metric_name
  namespace           = "AWS/SQS"
  period              = var.min_period
  statistic           = "Average"
  threshold           = var.min_threshold
  dimensions = {
    QueueName = "${var.queue_name}"
  }
  alarm_actions = [aws_appautoscaling_policy.scale_down_policy.arn]

}

#------------------------------------------------------------------------------
# AWS Auto Scaling - Scaling Target
#------------------------------------------------------------------------------
resource "aws_appautoscaling_target" "scale_target" {
  service_namespace  = "ecs"
  resource_id        = "service/${var.ecs_cluster_name}/${var.ecs_service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = var.scale_target_min_capacity
  max_capacity       = var.scale_target_max_capacity
}
