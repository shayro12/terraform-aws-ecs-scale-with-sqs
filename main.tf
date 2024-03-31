



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
    adjustment_type          = var.scale_up_step_scaling_policy_configuration.adjustment_type
    cooldown                 = var.scale_up_step_scaling_policy_configuration.cooldown
    metric_aggregation_type  = var.scale_up_step_scaling_policy_configuration.metric_aggregation_type
    min_adjustment_magnitude = var.scale_up_step_scaling_policy_configuration.min_adjustment_magnitude

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
    adjustment_type          = var.scale_down_step_scaling_policy_configuration.adjustment_type
    cooldown                 = var.scale_down_step_scaling_policy_configuration.cooldown
    metric_aggregation_type  = var.scale_down_step_scaling_policy_configuration.metric_aggregation_type
    min_adjustment_magnitude = var.scale_down_step_scaling_policy_configuration.min_adjustment_magnitude

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
  comparison_operator = var.aws_cloudwatch_metric_alarm_config_high.comparison_operator
  evaluation_periods  = var.aws_cloudwatch_metric_alarm_config_high.evaluation_periods
  metric_name         = var.aws_cloudwatch_metric_alarm_config_high.metric_name
  namespace           = var.aws_cloudwatch_metric_alarm_config_high.namespace
  period              = var.aws_cloudwatch_metric_alarm_config_high.period
  statistic           = var.aws_cloudwatch_metric_alarm_config_high.statistic
  threshold           = var.aws_cloudwatch_metric_alarm_config_high.threshold
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
  comparison_operator = var.aws_cloudwatch_metric_alarm_config_low.comparison_operator
  evaluation_periods  = var.aws_cloudwatch_metric_alarm_config_low.evaluation_periods
  metric_name         = var.aws_cloudwatch_metric_alarm_config_low.metric_name
  namespace           = var.aws_cloudwatch_metric_alarm_config_low.namespace
  period              = var.aws_cloudwatch_metric_alarm_config_low.period
  statistic           = var.aws_cloudwatch_metric_alarm_config_low.statistic
  threshold           = var.aws_cloudwatch_metric_alarm_config_low.threshold
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

