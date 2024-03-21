data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}
output "is_localstack" {
  value = data.aws_caller_identity.current.id == "000000000000"
}

locals {
  name     = "test-autoscaling"
  region   = "us-east-1"
  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)
  tags = {
    Example    = local.name
    GithubRepo = "terraform-aws-vpc"
    GithubOrg  = "terraform-aws-modules"
  }
}

################################################################################
# VPC Module
################################################################################

module "vpc" {
  source          = "terraform-aws-modules/vpc/aws"
  version         = "5.6.0"
  name            = "${local.name}-vpc"
  cidr            = local.vpc_cidr
  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 4)]
  tags            = local.tags
}

module "cluster" {
  source = "cn-terraform/ecs-cluster/aws"
  name   = "test-cluster"
}

module "td" {
  source          = "cn-terraform/ecs-fargate-task-definition/aws"
  name_prefix     = "test-td"
  container_image = "ubuntu"
  container_name  = "test"
}

module "service" {
  source              = "cn-terraform/ecs-fargate-service/aws"
  name_prefix         = "test-service"
  vpc_id              = module.vpc.vpc_id
  ecs_cluster_arn     = module.cluster.aws_ecs_cluster_cluster_arn
  task_definition_arn = module.td.aws_ecs_task_definition_td_arn
  public_subnets      = module.vpc.public_subnets
  private_subnets     = module.vpc.private_subnets
  container_name      = "test"
  enable_autoscaling  = false
}
module "sqs" {
  source  = "terraform-aws-modules/sqs/aws"
  version = "4.1.1"
  name    = "${local.name}-sqs"

  tags = local.tags
}

module "ecs-service-autoscaling" {
  source           = "../../"
  name_prefix      = local.name
  ecs_cluster_name = module.cluster.aws_ecs_cluster_cluster_name
  ecs_service_name = module.service.aws_ecs_service_service_name
  queue_name       = module.sqs.queue_name
  # region                                      = "us-east-1"
  # availability_zones                          = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
  # vpc_cidr_block                              = "192.168.0.0/16"
  # public_subnets_cidrs_per_availability_zone  = ["192.168.0.0/19", "192.168.32.0/19", "192.168.64.0/19", "192.168.96.0/19"]
  # private_subnets_cidrs_per_availability_zone = ["192.168.128.0/19", "192.168.160.0/19", "192.168.192.0/19", "192.168.224.0/19"]
}
