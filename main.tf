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
    cloud {
    organization = "teste-carla"

    workspaces {
      name = "novo-workspace"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}


resource "aws_eks_cluster" "tech" {
  name     = "tech"
  role_arn = "arn:aws:iam::019248244455:role/LabRole"

  vpc_config {
    subnet_ids = [
        "subnet-0f001a61c2a84a217", 
        "subnet-0e13ff3b8ed24e2b9",
        "subnet-09ed108424f3deb06",
        "subnet-07e12442cb4f70b7b",
        "subnet-059aeadf98cf87078"
        ]
  }

}

output "endpoint" {
  value = aws_eks_cluster.tech.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.tech.certificate_authority[0].data
}


resource "aws_eks_node_group" "techNode" {
  cluster_name    = aws_eks_cluster.tech.name
  node_group_name = "techNode"
  node_role_arn   = "arn:aws:iam::019248244455:role/LabRole"
  subnet_ids      = [
        "subnet-0f001a61c2a84a217", 
        "subnet-0e13ff3b8ed24e2b9",
        "subnet-09ed108424f3deb06",
        "subnet-07e12442cb4f70b7b",
        "subnet-059aeadf98cf87078"
        ]
  instance_types   = ["t3.small"] 

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

}

# resource "aws_api_gateway_vpc_link" "main" {
#   name        = "tech_vpclink"
#   description = "Foobar Gateway VPC Link. Managed by Terraform."
#   target_arns = [var.load_balancer_arn]
# }

# resource "aws_api_gateway_rest_api" "main" {
#   name           = "tech_gateway"
#   description    = "Foobar Gateway VPC Link. Managed by Terraform."

#   endpoint_configuration {
#     types = ["REGIONAL"]
#   }
# }

# resource "aws_api_gateway_resource" "proxy" {
#   rest_api_id = aws_api_gateway_rest_api.main.id
#   parent_id   = aws_api_gateway_rest_api.main.root_resource_id
#   path_part   = "{proxy+}"
# }

# resource "aws_api_gateway_method" "proxy" {
#   rest_api_id   = aws_api_gateway_rest_api.main.id
#   resource_id   = aws_api_gateway_resource.proxy.id
#   http_method   = "ANY"
#   authorization = "NONE"

#   request_parameters = {
#     "method.request.path.proxy"           = true
#     "method.request.header.Authorization" = true
#   }
# }

# resource "aws_api_gateway_integration" "proxy" {
#   rest_api_id = aws_api_gateway_rest_api.main.id
#   resource_id = aws_api_gateway_resource.proxy.id
#   http_method = "ANY"

#   integration_http_method = "ANY"
#   type                    = "HTTP_PROXY"
#   uri                     = "http://${var.load_balancer_dns}/{proxy}"
#   passthrough_behavior    = "WHEN_NO_MATCH"
#   content_handling        = "CONVERT_TO_TEXT"

#   request_parameters = {
#     "integration.request.path.proxy"           = "method.request.path.proxy"
#     "integration.request.header.Accept"        = "'application/json'"
#     "integration.request.header.Authorization" = "method.request.header.Authorization"
#   }

#   connection_type = "VPC_LINK"
#   connection_id   = aws_api_gateway_vpc_link.main.id
# }