
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = ">= 4.0" }
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source = "../modules/vpc"
  cidr_block = var.vpc_cidr
}

module "iam" {
  source = "../modules/iam"
  github_oidc_role_name = var.github_oidc_role_name
}

module "ecr" {
  source = "../modules/ecr"
  name = "frontend-app"
}

module "eks" {
  source = "../modules/eks"
  cluster_name = var.cluster_name
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids
}

module "alb" {
  source = "../modules/alb"
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnet_ids
  name = "${var.cluster_name}-alb"
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}
output "cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}
output "ecr_repo_url" {
  value = module.ecr.repository_url
}
output "vpc_id" {
  value = module.vpc.vpc_id
}
