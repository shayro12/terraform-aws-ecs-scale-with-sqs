


# terraform-aws-ecs-scale-with-sqs

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~>5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.41.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_appautoscaling_policy.scale_down_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_policy.scale_up_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_target.scale_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |
| [aws_cloudwatch_metric_alarm.custom_high](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.custom_low](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_cloudwatch_metric_alarm_config_high"></a> [aws\_cloudwatch\_metric\_alarm\_config\_high](#input\_aws\_cloudwatch\_metric\_alarm\_config\_high) | n/a | <pre>object({<br>    comparison_operator = string<br>    evaluation_periods  = number<br>    metric_name         = string<br>    namespace           = string<br>    period              = number<br>    statistic           = string<br>    threshold           = number<br>  })</pre> | <pre>{<br>  "comparison_operator": "GreaterThanOrEqualToThreshold",<br>  "evaluation_periods": 1,<br>  "metric_name": "ApproximateNumberOfMessagesVisible",<br>  "namespace": "AWS/SQS",<br>  "period": 10,<br>  "statistic": "Maximum",<br>  "threshold": 2<br>}</pre> | no |
| <a name="input_aws_cloudwatch_metric_alarm_config_low"></a> [aws\_cloudwatch\_metric\_alarm\_config\_low](#input\_aws\_cloudwatch\_metric\_alarm\_config\_low) | n/a | <pre>object({<br>    comparison_operator = string<br>    evaluation_periods  = number<br>    metric_name         = string<br>    namespace           = string<br>    period              = number<br>    statistic           = string<br>    threshold           = number<br>  })</pre> | <pre>{<br>  "comparison_operator": "LessThanOrEqualToThreshold",<br>  "evaluation_periods": 1,<br>  "metric_name": "ApproximateNumberOfMessagesVisible",<br>  "namespace": "AWS/SQS",<br>  "period": 10,<br>  "statistic": "Average",<br>  "threshold": 100<br>}</pre> | no |
| <a name="input_cooldown"></a> [cooldown](#input\_cooldown) | n/a | `number` | `60` | no |
| <a name="input_ecs_cluster_name"></a> [ecs\_cluster\_name](#input\_ecs\_cluster\_name) | name of the ECS cluster | `any` | n/a | yes |
| <a name="input_ecs_service_name"></a> [ecs\_service\_name](#input\_ecs\_service\_name) | name of the ECS service | `any` | n/a | yes |
| <a name="input_max_evaluation_period"></a> [max\_evaluation\_period](#input\_max\_evaluation\_period) | maximum evaluation period for the alarm | `number` | `1` | no |
| <a name="input_max_period"></a> [max\_period](#input\_max\_period) | maximum period for the alarm in seconds | `number` | `10` | no |
| <a name="input_max_threshold"></a> [max\_threshold](#input\_max\_threshold) | threshold for the scale up policy<br>  eg. if the threshold is 2 and the metric value is 3, the scale up policy will be triggered | `number` | `2` | no |
| <a name="input_metric_name"></a> [metric\_name](#input\_metric\_name) | value of the metric to be used for scaling , set to ApproximateNumberOfMessagesVisible for SQS by default but can be changed to any other metric | `string` | `"ApproximateNumberOfMessagesVisible"` | no |
| <a name="input_min_evaluation_period"></a> [min\_evaluation\_period](#input\_min\_evaluation\_period) | minimum evaluation period for the alarm | `number` | `1` | no |
| <a name="input_min_period"></a> [min\_period](#input\_min\_period) | minimum period for the alarm in seconds | `number` | `60` | no |
| <a name="input_min_threshold"></a> [min\_threshold](#input\_min\_threshold) | threshold for the scale down policy<br>  eg. if the threshold is 100 and the metric value is 90, the scale down policy will be triggered | `number` | `100` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | n/a | `string` | `"sqs"` | no |
| <a name="input_queue_name"></a> [queue\_name](#input\_queue\_name) | name of the SQS queue | `any` | n/a | yes |
| <a name="input_scale_down_step_scaling_policy_configuration"></a> [scale\_down\_step\_scaling\_policy\_configuration](#input\_scale\_down\_step\_scaling\_policy\_configuration) | Step Scaling Policy Configuration for Scale Down | <pre>object({<br>    adjustment_type          = string<br>    cooldown                 = number<br>    metric_aggregation_type  = string<br>    min_adjustment_magnitude = number<br>  })</pre> | <pre>{<br>  "adjustment_type": "ExactCapacity",<br>  "cooldown": 60,<br>  "metric_aggregation_type": "Average",<br>  "min_adjustment_magnitude": 0<br>}</pre> | no |
| <a name="input_scale_target_max_capacity"></a> [scale\_target\_max\_capacity](#input\_scale\_target\_max\_capacity) | maximum capacity for the target | `number` | `10` | no |
| <a name="input_scale_target_min_capacity"></a> [scale\_target\_min\_capacity](#input\_scale\_target\_min\_capacity) | minimum capacity for the target | `number` | `1` | no |
| <a name="input_scale_up_step_scaling_policy_configuration"></a> [scale\_up\_step\_scaling\_policy\_configuration](#input\_scale\_up\_step\_scaling\_policy\_configuration) | Step Scaling Policy Configuration for Scale Up | <pre>object({<br>    adjustment_type          = string<br>    cooldown                 = number<br>    metric_aggregation_type  = string<br>    min_adjustment_magnitude = number<br>  })</pre> | <pre>{<br>  "adjustment_type": "ExactCapacity",<br>  "cooldown": 60,<br>  "metric_aggregation_type": "Average",<br>  "min_adjustment_magnitude": 0<br>}</pre> | no |
| <a name="input_step_adjustment_lower_bound"></a> [step\_adjustment\_lower\_bound](#input\_step\_adjustment\_lower\_bound) | a list of maps containing the lower bound for the step adjustment (scaling down) <br>  metric\_interval\_lower\_bound: the lower bound for the metric interval<br>  metric\_interval\_upper\_bound: the upper bound for the metric interval<br>  scaling\_adjustment: the scaling adjustment to be applied when the metric is within the interval | `list` | <pre>[<br>  {<br>    "metric_interval_lower_bound": "",<br>    "metric_interval_upper_bound": "-90",<br>    "scaling_adjustment": "1"<br>  },<br>  {<br>    "metric_interval_lower_bound": "-90",<br>    "metric_interval_upper_bound": "-50",<br>    "scaling_adjustment": "5"<br>  },<br>  {<br>    "metric_interval_lower_bound": "-50",<br>    "metric_interval_upper_bound": "0",<br>    "scaling_adjustment": "10"<br>  }<br>]</pre> | no |
| <a name="input_step_adjustment_upper_bound"></a> [step\_adjustment\_upper\_bound](#input\_step\_adjustment\_upper\_bound) | a list of maps containing the upper bound for the step adjustment (scaling up) <br>  metric\_interval\_lower\_bound: the lower bound for the metric interval<br>  metric\_interval\_upper\_bound: the upper bound for the metric interval<br>  scaling\_adjustment: the scaling adjustment to be applied when the metric is within the interval | `list` | <pre>[<br>  {<br>    "metric_interval_lower_bound": "0",<br>    "metric_interval_upper_bound": "8",<br>    "scaling_adjustment": "1"<br>  },<br>  {<br>    "metric_interval_lower_bound": "8",<br>    "metric_interval_upper_bound": "48",<br>    "scaling_adjustment": "5"<br>  },<br>  {<br>    "metric_interval_lower_bound": "48",<br>    "metric_interval_upper_bound": "",<br>    "scaling_adjustment": "10"<br>  }<br>]</pre> | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
