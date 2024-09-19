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
      aws_subnet.tech_public_subnet_1.id,
      aws_subnet.tech_public_subnet_2.id,
      aws_subnet.tech_private_subnet_1.id,
      aws_subnet.tech_private_subnet_2.id
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
      aws_subnet.tech_public_subnet_1.id,
      aws_subnet.tech_public_subnet_2.id,
      aws_subnet.tech_private_subnet_1.id,
      aws_subnet.tech_private_subnet_2.id
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
