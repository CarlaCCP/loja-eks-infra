# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.52.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
  required_version = ">= 1.1.0"
  #   cloud {
  #   organization = "teste-carla"

  #   workspaces {
  #     name = "novo-workspace"
  #   }
  # }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_subnets" "tech_subnetes" {
  filter = "availability_zone!=us-east-1e"
}

output subnets_output {
  for_each = toset(data.aws_subnets.tech_subnetes.ids) 
  value = each.value
}


# resource "aws_eks_cluster" "tech" {
#   name     = "tech"
#   role_arn = "arn:aws:iam::019248244455:role/LabRole"

#   vpc_config {
#     for_each   = toset(data.aws_subnets.tech_subnetes.ids) 
#     subnet_ids = [each.value]
#   }

# }

# output "endpoint" {
#   value = aws_eks_cluster.tech.endpoint
# }

# output "kubeconfig-certificate-authority-data" {
#   value = aws_eks_cluster.tech.certificate_authority[0].data
# }


# resource "aws_eks_node_group" "techNode" {
#   cluster_name    = aws_eks_cluster.tech.name
#   node_group_name = "techNode"
#   node_role_arn   = "arn:aws:iam::019248244455:role/LabRole"
#   for_each   = toset(data.aws_subnets.tech_subnetes.ids) 
#   subnet_ids = [each.value]
#   # subnet_ids      = [
#   #     "subnet-0b9190e6af5d60aa2",
#   #     "subnet-0b8ce7688687ab745",
#   #     "subnet-0fe8bd1b60c41c998",
#   #     "subnet-00251cca3661eab7c",
#   #     "subnet-0ce0b9c2470f397e4"
#   #   ]
#   instance_types   = ["t3.small"] 

#   scaling_config {
#     desired_size = 1
#     max_size     = 1
#     min_size     = 1
#   }

#   update_config {
#     max_unavailable = 1
#   }

# }
