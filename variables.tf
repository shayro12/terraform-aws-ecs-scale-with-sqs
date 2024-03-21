variable "metric_name" {
  default = "ApproximateNumberOfMessagesVisible"

}
variable "min_evaluation_period" {
  default = 2
}
variable "min_period" {
  default = 10
}
variable "max_evaluation_period" {
  default = 2
}
variable "max_period" {
  default = 10
}
variable "scale_target_max_capacity" {
  default = 12
}
variable "scale_target_min_capacity" {
  default = 1
}
variable "min_threshold" {
  default = 100
}
variable "max_threshold" {
  default = 20

}
variable "ecs_cluster_name" {
  default = "dev-cluster"
}
variable "ecs_service_name" {
  default = "dev-MonitorWorker"
}
variable "name_prefix" {
  default = "sqs"
}
variable "cooldown" {
  default = 300
}
variable "step_adjustment_lower_bound" {
  default = [
    {
      metric_interval_lower_bound = ""
      metric_interval_upper_bound = "-80"
      scaling_adjustment          = "2"
    },
    {
      metric_interval_lower_bound = "-80"
      metric_interval_upper_bound = "-50"
      scaling_adjustment          = "4"
    },
    {
      metric_interval_lower_bound = "-50"
      metric_interval_upper_bound = "0"
      scaling_adjustment          = "8"
    }
  ]
}
variable "step_adjustment_upper_bound" {
  default = [
    {
      metric_interval_lower_bound = "0"
      metric_interval_upper_bound = "30"
      scaling_adjustment          = "4"
    },
    {
      metric_interval_lower_bound = "30"
      metric_interval_upper_bound = "80"
      scaling_adjustment          = "8"
    },
    {
      metric_interval_lower_bound = "80"
      metric_interval_upper_bound = ""
      scaling_adjustment          = "10"
    }
  ]
}
