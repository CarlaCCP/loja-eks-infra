# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

data "aws_subnets" "tech_subnetes" {
  filter {
    name   = "availability-zone-id"
    values = ["use1-az5","use1-az2", "use1-az1", "use1-az6", "use1-az4"]
  }
}

output subnets_output {
  value = data.aws_subnets.tech_subnetes
}


resource "aws_eks_cluster" "tech" {
  name     = "tech"
  role_arn = "arn:aws:iam::339712924021:role/LabRole"

  vpc_config {
    subnet_ids = data.aws_subnets.tech_subnetes.ids
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
  node_role_arn   = "arn:aws:iam::339712924021:role/LabRole"
  subnet_ids      = data.aws_subnets.tech_subnetes.ids
  instance_types  = ["t3.small"] 

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

}
